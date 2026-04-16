// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IWrappedTokenGatewayV3} from 'aave-v3-origin/contracts/helpers/interfaces/IWrappedTokenGatewayV3.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

interface IMainnetSwapSteward {
  function increaseTokenBudget(address token, uint256 budget) external;
}

/**
 * @title April 2026 - Funding Update
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-april-2026-funding-update/24447
 */
contract AaveV3Ethereum_April2026FundingUpdate_20260415 is IProposalGenericExecutor {
  // https://etherscan.io/address/0xAA088dfF3dcF619664094945028d44E779F19894
  address public constant TOKEN_LOGIC = 0xAA088dfF3dcF619664094945028d44E779F19894;
  uint256 public constant REIMBURSEMENTS_GHO_AMOUNT = 21_322 ether;

  uint256 public constant WETH_SWAP_BUDGET_AMOUNT = 5_000 ether;
  uint256 public constant USDT_SWAP_BUDGET_AMOUNT = 10_000_000e6;
  uint256 public constant USDC_SWAP_BUDGET_AMOUNT = 10_000_000e6;
  uint256 public constant USDe_SWAP_BUDGET_AMOUNT = 10_000_000 ether;
  uint256 public constant USDS_SWAP_BUDGET_AMOUNT = 10_000_000 ether;
  uint256 public constant DAI_SWAP_BUDGET_AMOUNT = 5_000_000 ether;

  uint256 public constant MERIT_ALLOWANCE = 2_000_000 ether;
  uint256 public constant TYDRO_ALLOWANCE = 30_000 ether;
  uint256 public constant STREAM = 1;

  uint256 public constant OLD_STREAM = 100015;
  address public constant STREAM_RECIPIENT = 0xbC540e0729B732fb14afA240aA5A047aE9ba7dF0;

  function execute() external {
    _depositEth();
    _reimbursements();
    _replenishAllowances();
    _merit();
    _tydro();
    _streams();
  }

  function _depositEth() internal {
    uint256 ethBalance = address(AaveV3Ethereum.COLLECTOR).balance;
    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3Ethereum.COLLECTOR.ETH_MOCK_ADDRESS()),
      address(this),
      ethBalance
    );
    IWrappedTokenGatewayV3(AaveV3Ethereum.WETH_GATEWAY).depositETH{value: ethBalance}(
      address(AaveV3Ethereum.POOL),
      address(AaveV3Ethereum.COLLECTOR),
      0
    );
  }

  function _reimbursements() internal {
    uint256 currentAllowance = IERC20(AaveV3EthereumAssets.GHO_UNDERLYING).allowance(
      address(AaveV3Ethereum.COLLECTOR),
      TOKEN_LOGIC
    );
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.GHO_UNDERLYING),
      TOKEN_LOGIC,
      currentAllowance + REIMBURSEMENTS_GHO_AMOUNT
    );
  }

  function _replenishAllowances() internal {
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.WETH_UNDERLYING,
      WETH_SWAP_BUDGET_AMOUNT
    );

    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDT_UNDERLYING,
      USDT_SWAP_BUDGET_AMOUNT
    );

    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDC_UNDERLYING,
      USDC_SWAP_BUDGET_AMOUNT
    );

    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDe_UNDERLYING,
      USDe_SWAP_BUDGET_AMOUNT
    );

    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDS_UNDERLYING,
      USDS_SWAP_BUDGET_AMOUNT
    );

    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.DAI_UNDERLYING,
      DAI_SWAP_BUDGET_AMOUNT
    );
  }

  function _merit() internal {
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      MiscEthereum.MERIT_AHAB_SAFE,
      MERIT_ALLOWANCE
    );
  }

  function _tydro() internal {
    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.approve(
      MiscEthereum.ECOSYSTEM_RESERVE,
      AaveV3EthereumAssets.AAVE_UNDERLYING,
      MiscEthereum.AFC_SAFE,
      TYDRO_ALLOWANCE
    );
  }

  function _streams() internal {
    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.cancelStream(
      MiscEthereum.ECOSYSTEM_RESERVE,
      OLD_STREAM
    );
  }
}
