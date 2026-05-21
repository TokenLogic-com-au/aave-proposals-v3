// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3Mantle} from 'aave-address-book/AaveV3Mantle.sol';
import {GhoMantle} from 'aave-address-book/GhoMantle.sol';
import {GovernanceV3Mantle} from 'aave-address-book/GovernanceV3Mantle.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';

import {RemoteGSMLaunchMantleConstants} from './setup/RemoteGSMLaunchMantleConstants.sol';

/**
 * @title Remote GSM Launch: Mantle
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 *
 * NOTE: granting RISK_ADMIN_ROLE on AaveV3Mantle.ACL_MANAGER to a GhoAaveSteward
 * is intentionally OUT OF SCOPE for this proposal. If a steward is not already
 * empowered on Mantle, that grant must be made in a separate proposal before
 * the steward can call updateGhoBorrowCap / updateGhoBorrowRate / updateGhoSupplyCap.
 *
 * NOTE (CCIP receiver assumption): this proposal assumes the CCIP token-pool on
 * the Mantle lane delivers bridged GHO to `AaveV3Mantle.COLLECTOR`. The
 * Collector -> GhoReserve transfer below depends on that. If the CCIP receiver
 * for this lane is anything other than the Collector, this payload will revert.
 * Verify on-chain before deploy.
 */
contract AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  // GhoReserve
  // TODO: deployed GhoReserve on Mantle (assuming single reserve for all GSMs)
  IGhoReserve public constant GHO_RESERVE = IGhoReserve(address(0));

  // TODO: deployed GhoGsmSteward on Mantle
  address public constant GHO_GSM_STEWARD = address(0);

  // TODO: deployed GsmRegistry on Mantle
  address public constant GSM_REGISTRY = address(0);

  // GSM USDT0
  // TODO: deployed stataUSDT0 Remote GSM on Mantle
  address public constant GSM_USDT0 = address(0);

  // TODO: deployed USDT0 OracleSwapFreezer on Mantle
  address public constant USDT0_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on Mantle (mint 0% / burn 0.10%)
  address public constant GSM_USDT0_FEE_STRATEGY = address(0);

  // GSM USDC
  // TODO: deployed stataUSDC Remote GSM on Mantle
  address public constant GSM_USDC = address(0);

  // TODO: deployed USDC OracleSwapFreezer on Mantle
  address public constant USDC_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on Mantle (mint 0% / burn 0.10%)
  address public constant GSM_USDC_FEE_STRATEGY = address(0);

  function execute() external {
    GHO_RESERVE.grantRole(GHO_RESERVE.LIMIT_MANAGER_ROLE(), GhoMantle.RISK_COUNCIL);

    _wireGsm(
      IGsm(GSM_USDT0),
      RemoteGSMLaunchMantleConstants.GSM_USDT0_RESERVE_LIMIT,
      USDT0_ORACLE_SWAP_FREEZER,
      RemoteGSMLaunchMantleConstants.GSM_USDT0_INITIAL_EXPOSURE_CAP,
      GSM_USDT0_FEE_STRATEGY
    );
    _wireGsm(
      IGsm(GSM_USDC),
      RemoteGSMLaunchMantleConstants.GSM_USDC_RESERVE_LIMIT,
      USDC_ORACLE_SWAP_FREEZER,
      RemoteGSMLaunchMantleConstants.GSM_USDC_INITIAL_EXPOSURE_CAP,
      GSM_USDC_FEE_STRATEGY
    );

    AaveV3Mantle.COLLECTOR.transfer(
      IERC20(GhoMantle.GHO_TOKEN),
      address(GHO_RESERVE),
      RemoteGSMLaunchMantleConstants.GHO_BRIDGE_AMOUNT
    );

    // Restore bridge limits after GHO bridging.
    // Facilitator Bucket Capacity does not need to change.
    IUpgradeableBurnMintTokenPool(GhoMantle.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_RATE
      })
    );
  }

  function _wireGsm(
    IGsm gsm,
    uint128 reserveLimit,
    address oracleSwapFreezer,
    uint128 initialExposureCap,
    address feeStrategy
  ) internal {
    gsm.updateGhoReserve(address(GHO_RESERVE));

    // Enroll GSMs as entities and set limit
    GHO_RESERVE.addEntity(address(gsm));
    GHO_RESERVE.setLimit(address(gsm), reserveLimit);

    // Add GSM Swap Freezer role to OracleSwapFreezers
    bytes32 swapFreezerRole = gsm.SWAP_FREEZER_ROLE();
    gsm.grantRole(swapFreezerRole, oracleSwapFreezer);
    gsm.grantRole(swapFreezerRole, GovernanceV3Mantle.EXECUTOR_LVL_1);

    // Add GSMs to GSM Registry
    IGsmRegistry(GSM_REGISTRY).addGsm(address(gsm));

    // GHO GSM Steward
    gsm.grantRole(gsm.CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // Update deployed exposure cap to initial value
    gsm.updateExposureCap(initialExposureCap);

    gsm.updateFeeStrategy(feeStrategy);
  }
}
