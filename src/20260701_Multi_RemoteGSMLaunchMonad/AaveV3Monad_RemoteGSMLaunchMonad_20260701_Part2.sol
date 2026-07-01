// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3Monad} from 'aave-address-book/AaveV3Monad.sol';
import {GovernanceV3Monad} from 'aave-address-book/GovernanceV3Monad.sol';
import {CollectorUtils, ICollector} from 'aave-helpers/src/CollectorUtils.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @title Remote GSM Launch: Monad
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 *
 * NOTE: granting RISK_ADMIN_ROLE on AaveV3Monad.ACL_MANAGER to a GhoAaveSteward
 * is intentionally OUT OF SCOPE for this proposal. If a steward is not already
 * empowered on Monad, that grant must be made in a separate proposal before
 * the steward can call updateGhoBorrowCap / updateGhoBorrowRate / updateGhoSupplyCap.
 *
 * NOTE (CCIP receiver assumption): this proposal assumes the CCIP token-pool on
 * the Monad lane delivers bridged GHO to `AaveV3Monad.COLLECTOR`. The
 * Collector -> GhoReserve transfer below depends on that. If the CCIP receiver
 * for this lane is anything other than the Collector, this payload will revert.
 * Verify on-chain before deploy.
 *
 * TODO: every GSM/Reserve/Steward/Registry address below, plus the Risk Council, are Monad
 * deployments that are not available yet. They are left as address(0) so the payload compiles;
 * fill them in before deploy. Tests that execute this payload are skipped until they are set.
 */
contract AaveV3Monad_RemoteGSMLaunchMonad_20260701_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;
  using CollectorUtils for ICollector;

  // GHO addresses on Monad. Hardcoded because `GhoMonad` is not yet in aave-address-book.
  // TODO: replace with `GhoMonad.GHO_TOKEN` / `GhoMonad.GHO_CCIP_TOKEN_POOL` once available.
  address public constant GHO_TOKEN = 0xfc421aD3C883Bf9E7C4f42dE845C4e4405799e73;
  address public constant GHO_CCIP_TOKEN_POOL = 0xA5AE05b71c3F170E12E7620Fdf7679721aec1EC8;

  // Monad Risk Council (LIMIT_MANAGER_ROLE on the GhoReserve).
  // TODO: set the Monad Risk Council address (no GhoMonad.RISK_COUNCIL in aave-address-book yet).
  address public constant RISK_COUNCIL = address(0);

  // GhoReserve
  // TODO: set the deployed Monad GhoReserve address.
  IGhoReserve public constant GHO_RESERVE = IGhoReserve(address(0));

  // TODO: set the deployed Monad GhoGsmSteward address.
  address public constant GHO_GSM_STEWARD = address(0);

  // TODO: set the deployed Monad GsmRegistry address.
  address public constant GSM_REGISTRY = address(0);

  // GSM USDC
  // TODO: set the deployed Monad USDC GSM address.
  address public constant GSM_USDC = address(0);

  // TODO: set the deployed Monad USDC OracleSwapFreezer address.
  address public constant USDC_ORACLE_SWAP_FREEZER = address(0);

  // TODO: set the deployed Monad USDC GSM fee strategy address.
  address public constant GSM_USDC_FEE_STRATEGY = address(0);

  function execute() external {
    GHO_RESERVE.grantRole(GHO_RESERVE.LIMIT_MANAGER_ROLE(), RISK_COUNCIL);

    _wireGsm(
      IGsm(GSM_USDC),
      RemoteGSMLaunchMonadSetup.GSM_USDC_RESERVE_LIMIT,
      USDC_ORACLE_SWAP_FREEZER,
      RemoteGSMLaunchMonadSetup.GSM_USDC_INITIAL_EXPOSURE_CAP,
      GSM_USDC_FEE_STRATEGY
    );

    AaveV3Monad.COLLECTOR.transfer(
      IERC20(GHO_TOKEN),
      address(GHO_RESERVE),
      RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT
    );

    // Restore ONLY the Monad <> Ethereum lane rate-limit config to its standard values, undoing
    // the temporary inbound bump from Part 1. Every other lane is intentionally left untouched.
    // Facilitator Bucket Capacity does not need to change.
    RemoteGSMLaunchMonadSetup.restoreLaneRateLimitConfig(
      GHO_CCIP_TOKEN_POOL,
      CCIPChainSelectors.ETHEREUM
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

    // Enroll GSM as entity and set limit
    GHO_RESERVE.addEntity(address(gsm));
    GHO_RESERVE.setLimit(address(gsm), reserveLimit);

    // Add GSM Swap Freezer role to OracleSwapFreezers
    bytes32 swapFreezerRole = gsm.SWAP_FREEZER_ROLE();
    gsm.grantRole(swapFreezerRole, oracleSwapFreezer);
    gsm.grantRole(swapFreezerRole, GovernanceV3Monad.EXECUTOR_LVL_1);

    // Add GSM to GSM Registry
    IGsmRegistry(GSM_REGISTRY).addGsm(address(gsm));

    // GHO GSM Steward
    gsm.grantRole(gsm.CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // Update deployed exposure cap to initial value
    gsm.updateExposureCap(initialExposureCap);

    gsm.updateFeeStrategy(feeStrategy);
  }
}
