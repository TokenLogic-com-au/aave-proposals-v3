// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IAaveCLRobotOperator} from 'src/interfaces/IAaveCLRobotOperator.sol';

/**
 * @title Mainnet GSM migration
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Ethereum_MainnetGSMMigration_20261022 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  // TODO: replace with the deployed Gsm4626 over AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE
  address public constant NEW_GSM_USDC = 0x70D0000000000000000000000000000000000004;

  // TODO: replace with the deployed Gsm4626 over AaveV4EthereumTokenizationSpokes.CORE_USDT_TOKENIZATION_SPOKE
  address public constant NEW_GSM_USDT = 0x70D0000000000000000000000000000000000005;

  // TODO: replace with the deployed ChainlinkOracleSwapFreezer of NEW_GSM_USDC
  address public constant NEW_USDC_ORACLE_SWAP_FREEZER = 0x70D0000000000000000000000000000000000006;

  // TODO: replace with the deployed ChainlinkOracleSwapFreezer of NEW_GSM_USDT
  address public constant NEW_USDT_ORACLE_SWAP_FREEZER = 0x70D0000000000000000000000000000000000007;

  // TODO: re-check caps and limits with the risk providers before going live
  uint128 public constant EXPOSURE_CAP_GSM_USDC = 90_000_000e6; // 6 decimals
  uint128 public constant EXPOSURE_CAP_GSM_USDT = 85_000_000e6; // 6 decimals
  uint128 public constant RESERVE_LIMIT_GSM_USDC = 100_000_000 ether; // GHO, 18 decimals
  uint128 public constant RESERVE_LIMIT_GSM_USDT = 100_000_000 ether; // GHO, 18 decimals

  // Keepers of the existing OracleSwapFreezers, already cancelled by the Chainlink Automation registry owner
  uint256 public constant EXISTING_ORACLE_SWAP_FREEZER_USDC =
    40831331354266106136802006200984629111720755373652730762609034360418296310552;
  uint256 public constant EXISTING_ORACLE_SWAP_FREEZER_USDT =
    14446266862268986374588159863529042189061116405334267310786859452241069238244;

  bytes32 public immutable LIQUIDATOR_ROLE = IGsm(GhoEthereum.GSM_USDC).LIQUIDATOR_ROLE();
  bytes32 public immutable SWAP_FREEZER_ROLE = IGsm(GhoEthereum.GSM_USDC).SWAP_FREEZER_ROLE();
  bytes32 public immutable CONFIGURATOR_ROLE = IGsm(GhoEthereum.GSM_USDC).CONFIGURATOR_ROLE();

  function execute() external {
    _seizeUsdc();
    _grantAccess();
    _updateFeeStrategy();
    _burnAfterSeizeUsdc();
    _disableUsdtGsmSales();
    _revokeAccess();
  }

  function _seizeUsdc() internal {
    IGsm(GhoEthereum.GSM_USDC).distributeFeesToTreasury();
    IGsm(GhoEthereum.GSM_USDC).grantRole(LIQUIDATOR_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGsm(GhoEthereum.GSM_USDC).seize();
  }

  function _grantAccess() internal {
    IGhoReserve(GhoEthereum.GHO_RESERVE).addEntity(NEW_GSM_USDC);
    IGhoReserve(GhoEthereum.GHO_RESERVE).addEntity(NEW_GSM_USDT);

    IGhoReserve(GhoEthereum.GHO_RESERVE).setLimit(NEW_GSM_USDC, RESERVE_LIMIT_GSM_USDC);
    IGhoReserve(GhoEthereum.GHO_RESERVE).setLimit(NEW_GSM_USDT, RESERVE_LIMIT_GSM_USDT);

    IGsm(NEW_GSM_USDC).updateExposureCap(EXPOSURE_CAP_GSM_USDC);
    IGsm(NEW_GSM_USDT).updateExposureCap(EXPOSURE_CAP_GSM_USDT);

    IGsm(NEW_GSM_USDC).grantRole(SWAP_FREEZER_ROLE, NEW_USDC_ORACLE_SWAP_FREEZER);
    IGsm(NEW_GSM_USDT).grantRole(SWAP_FREEZER_ROLE, NEW_USDT_ORACLE_SWAP_FREEZER);
    IGsm(NEW_GSM_USDC).grantRole(SWAP_FREEZER_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGsm(NEW_GSM_USDT).grantRole(SWAP_FREEZER_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);

    IGsmRegistry(GhoEthereum.GSM_REGISTRY).addGsm(NEW_GSM_USDC);
    IGsmRegistry(GhoEthereum.GSM_REGISTRY).addGsm(NEW_GSM_USDT);

    IGsm(NEW_GSM_USDC).grantRole(CONFIGURATOR_ROLE, GhoEthereum.GHO_GSM_STEWARD);
    IGsm(NEW_GSM_USDT).grantRole(CONFIGURATOR_ROLE, GhoEthereum.GHO_GSM_STEWARD);
  }

  function _updateFeeStrategy() internal {
    IGsm(NEW_GSM_USDC).updateFeeStrategy(IGsm(GhoEthereum.GSM_USDC).getFeeStrategy());
    IGsm(NEW_GSM_USDT).updateFeeStrategy(IGsm(GhoEthereum.GSM_USDT).getFeeStrategy());
  }

  function _burnAfterSeizeUsdc() internal {
    uint256 ghoUsdcNeeded = IGhoReserve(GhoEthereum.GHO_RESERVE).getUsed(GhoEthereum.GSM_USDC);

    if (ghoUsdcNeeded > 0) {
      AaveV3Ethereum.COLLECTOR.transfer(
        IERC20(GhoEthereum.GHO_TOKEN),
        address(this),
        ghoUsdcNeeded
      );
      IERC20(GhoEthereum.GHO_TOKEN).forceApprove(GhoEthereum.GSM_USDC, ghoUsdcNeeded);
      IGsm(GhoEthereum.GSM_USDC).burnAfterSeize(ghoUsdcNeeded);
    }
  }

  /// @dev sellAsset (USDT -> GHO) checks the exposure cap; buyAsset (GHO -> USDT) does not
  function _disableUsdtGsmSales() internal {
    IGsm(GhoEthereum.GSM_USDT).updateExposureCap(0);
  }

  function _revokeAccess() internal {
    IGhoReserve(GhoEthereum.GHO_RESERVE).setLimit(GhoEthereum.GSM_USDC, 0);
    IGhoReserve(GhoEthereum.GHO_RESERVE).removeEntity(GhoEthereum.GSM_USDC);
    IGsmRegistry(GhoEthereum.GSM_REGISTRY).removeGsm(GhoEthereum.GSM_USDC);

    IGsm(GhoEthereum.GSM_USDC).revokeRole(
      SWAP_FREEZER_ROLE,
      GhoEthereum.GSM_USDC_ORACLE_SWAP_FREEZER
    );
    IGsm(GhoEthereum.GSM_USDC).revokeRole(SWAP_FREEZER_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGsm(GhoEthereum.GSM_USDC).revokeRole(LIQUIDATOR_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGsm(GhoEthereum.GSM_USDC).revokeRole(CONFIGURATOR_ROLE, GhoEthereum.GHO_GSM_STEWARD);

    IAaveCLRobotOperator(MiscEthereum.AAVE_CL_ROBOT_OPERATOR).withdrawLink(
      EXISTING_ORACLE_SWAP_FREEZER_USDC
    );
    IAaveCLRobotOperator(MiscEthereum.AAVE_CL_ROBOT_OPERATOR).withdrawLink(
      EXISTING_ORACLE_SWAP_FREEZER_USDT
    );
  }
}
