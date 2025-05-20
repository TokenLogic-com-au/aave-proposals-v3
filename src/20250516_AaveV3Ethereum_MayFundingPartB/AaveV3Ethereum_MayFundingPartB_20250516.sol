// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {CollectorUtils, ICollector} from 'aave-helpers/src/CollectorUtils.sol';

/// taken from https://etherscan.io/address/0xf86141a5657Cf52AEB3E30eBccA5Ad3a8f714B89#code#F1#L63
interface MigrationActions {
  /**
   * @notice Migrate `assetsIn` of `dai` to `usds`.
   * @param  receiver The receiver of `usds`.
   * @param  assetsIn The amount of `dai` to migrate.
   */
  function migrateDAIToUSDS(address receiver, uint256 assetsIn) external;
}

/**
 * @title May Funding Part B
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: TODO
 */
contract AaveV3Ethereum_MayFundingPartB_20250516 is IProposalGenericExecutor {
  using CollectorUtils for ICollector;

  /// https://etherscan.io/address/0xf86141a5657Cf52AEB3E30eBccA5Ad3a8f714B89
  MigrationActions public constant MIGRATION_ACTIONS = 0xf86141a5657Cf52AEB3E30eBccA5Ad3a8f714B89;

  /// https://etherscan.io/address/0xdeadD8aB03075b7FBA81864202a2f59EE25B312b
  address public constant MERIT_SAFE = 0xdeadD8aB03075b7FBA81864202a2f59EE25B312b;

  /// https://etherscan.io/address/0xAA088dfF3dcF619664094945028d44E779F19894
  address public constant NEW_TOKENLOGIC_SAFE = 0xAA088dfF3dcF619664094945028d44E779F19894;

  address public constant COLLECTOR = address(AaveV3Ethereum.COLLECTOR);

  uint256 public constant GHO_ALLOWANCE_AMOUNT = 3_000_000e18;

  uint256 public constant TOKENLOGIC_STREAM_ID = 100055;

  function execute() external {
    _modifyTokenlogicStream();
    _migrateDaiToUsds();
    _allowances();
  }

  function _allowances() internal {
    AaveV3Ethereum.COLLECTOR.approve(IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN), MERIT_SAFE, 0);

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      MERIT_SAFE,
      GHO_ALLOWANCE_AMOUNT
    );
  }

  function _migrateDaiToUsds() internal {
    uint256 daiAmount = IERC20(AaveV3EthereumAssets.DAI_UNDERLYING).balanceOf(COLLECTOR);
    AaveV3Ethereum.COLLECTOR.transfer(
      AaveV3EthereumAssets.DAI_UNDERLYING,
      address(this),
      daiAmount
    );
    IERC20(AaveV3EthereumAssets.DAI_UNDERLYING).approve(address(MIGRATION_ACTIONS), daiAmount);
    MIGRATION_ACTIONS.migrateDAIToUSDS(COLLECTOR, daiAmount);
  }

  function _modifyTokenlogicStream() internal {
    (, , , address tokenAddress, , uint256 stopTime, uint256 remainingBalance, ) = AaveV3Ethereum
      .COLLECTOR
      .getStream(TOKENLOGIC_STREAM_ID);

    AaveV3Ethereum.COLLECTOR.cancelStream(TOKENLOGIC_STREAM_ID);

    uint256 timeLeft = stopTime - block.timestamp;

    CollectorUtils.stream(
      AaveV3Ethereum.COLLECTOR,
      CollectorUtils.CreateStreamInput({
        underlying: tokenAddress,
        receiver: NEW_TOKENLOGIC_SAFE,
        amount: remainingBalance,
        start: block.timestamp,
        duration: timeLeft
      })
    );
  }
}
