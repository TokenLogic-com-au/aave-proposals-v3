// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {Rescuable} from 'solidity-utils/contracts/utils/Rescuable.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';
import {OwnableWithGuardian} from 'solidity-utils/contracts/access-control/OwnableWithGuardian.sol';

import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';

import {AaveSwapper} from 'aave-helpers/swaps/AaveSwapper.sol';
import {IMilkman} from 'aave-helpers/swaps/interfaces/IMilkman.sol';
import {IPriceChecker} from 'aave-helpers/swaps/interfaces/IExpectedOutCalculator.sol';

///
///
/**
 * @title AavePermissionedSwapper
 * @author TokenLogic
 * @notice before using this swapper, collector (via governance) should give this contract
 * a timed max allowance of INPUT using Permit2
 */
contract AavePermissionedSwapper is OwnableWithGuardian, Rescuable {
  using SafeERC20 for IERC20;

  event SwapCanceled(address indexed fromToken, address indexed toToken, uint256 amount);
  event SwapRequested(
    address milkman,
    address indexed fromToken,
    address indexed toToken,
    address fromOracle,
    address toOracle,
    uint256 amount,
    address indexed recipient,
    uint256 slippage
  );

  error InvalidOutput();
  error InvalidAmount();
  error OracleNotSet();

  address public immutable INPUT;
  address public immutable INPUT_ORACLE;

  mapping(address => bool) public outputEnabled;

  constructor(address guardian, address input, address inputOracle) {
    INPUT = input;
    INPUT_ORACLE = inputOracle;
    _transferOwnership(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    _updateGuardian(guardian);
  }

  function pullFromCollector(uint256 amount) external onlyGuardian {
    AaveV3Ethereum.COLLECTOR.transfer(INPUT, address(this), amount);
  }

  function releaseToCollector(IERC20 asset) external onlyGuardian {
    asset.safeTransfer(address(AaveV3Ethereum.COLLECTOR), asset.balanceOf(address(this)));
  }

  function setOutputEnabled(address[] calldata output, bool[] calldata enabled) external onlyOwner {
    require(output.length == enabled.length);
    for (uint256 i = 0; i < output.length; i++) {
      outputEnabled[output[i]] = enabled[i];
    }
  }

  function swap(
    address milkman,
    address priceChecker,
    address toToken,
    address toOracle,
    uint256 amount,
    uint256 slippage
  ) external onlyGuardian {
    if (!outputEnabled[toToken]) revert InvalidOutput();
    if (amount == 0) revert InvalidAmount();

    address fromToken = INPUT;
    address fromOracle = INPUT_ORACLE;
    address recipient = address(this);

    IERC20(fromToken).forceApprove(milkman, amount);

    bytes memory data = _getPriceCheckerAndData(fromOracle, toOracle, slippage);

    IMilkman(milkman).requestSwapExactTokensForTokens(
      amount,
      IERC20(fromToken),
      IERC20(toToken),
      recipient,
      priceChecker,
      data
    );

    emit SwapRequested(
      milkman,
      fromToken,
      toToken,
      fromOracle,
      toOracle,
      amount,
      recipient,
      slippage
    );
  }

  function cancelSwap(
    address tradeMilkman,
    address priceChecker,
    address toToken,
    address toOracle,
    uint256 amount,
    uint256 slippage
  ) external onlyOwnerOrGuardian {
    address fromToken = INPUT;
    address fromOracle = INPUT_ORACLE;
    address recipient = address(this);

    bytes memory data = _getPriceCheckerAndData(fromOracle, toOracle, slippage);

    IMilkman(tradeMilkman).cancelSwap(
      amount,
      IERC20(fromToken),
      IERC20(toToken),
      recipient,
      priceChecker,
      data
    );

    emit SwapCanceled(fromToken, toToken, amount);
  }

  function getExpectedOut(
    address priceChecker,
    uint256 amount,
    address fromToken,
    address toToken,
    address fromOracle,
    address toOracle
  ) public view returns (uint256) {
    bytes memory data = _getPriceCheckerAndData(fromOracle, toOracle, 0);

    (, bytes memory _data) = abi.decode(data, (uint256, bytes));

    return
      IPriceChecker(priceChecker).EXPECTED_OUT_CALCULATOR().getExpectedOut(
        amount,
        fromToken,
        toToken,
        _data
      );
  }

  function whoCanRescue() public view override returns (address) {
    return owner();
  }

  function _getPriceCheckerAndData(
    address fromOracle,
    address toOracle,
    uint256 slippage
  ) internal pure returns (bytes memory) {
    return abi.encode(slippage, _getChainlinkCheckerData(fromOracle, toOracle));
  }

  function _getChainlinkCheckerData(
    address fromOracle,
    address toOracle
  ) internal pure returns (bytes memory) {
    if (toOracle == address(0)) revert OracleNotSet();

    address[] memory paths = new address[](2);
    paths[0] = fromOracle;
    paths[1] = toOracle;

    bool[] memory reverses = new bool[](2);
    reverses[1] = true;

    return abi.encode(paths, reverses);
  }
}
