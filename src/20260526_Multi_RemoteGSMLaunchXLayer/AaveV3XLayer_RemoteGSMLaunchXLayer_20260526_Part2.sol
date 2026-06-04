// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3XLayer} from 'aave-address-book/AaveV3XLayer.sol';
import {GhoXLayer} from 'aave-address-book/GhoXLayer.sol';
import {GovernanceV3XLayer} from 'aave-address-book/GovernanceV3XLayer.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';

import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @title Remote GSM Launch: X-Layer
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 *
 * NOTE: granting RISK_ADMIN_ROLE on AaveV3XLayer.ACL_MANAGER to a GhoAaveSteward
 * is intentionally OUT OF SCOPE for this proposal. If a steward is not already
 * empowered on X-Layer, that grant must be made in a separate proposal before
 * the steward can call updateGhoBorrowCap / updateGhoBorrowRate / updateGhoSupplyCap.
 *
 * NOTE (CCIP receiver assumption): this proposal assumes the CCIP token-pool on
 * the X-Layer lane delivers bridged GHO to `AaveV3XLayer.COLLECTOR`. The
 * Collector -> GhoReserve transfer below depends on that. If the CCIP receiver
 * for this lane is anything other than the Collector, this payload will revert.
 * Verify on-chain before deploy.
 */
contract AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  // GhoReserve
  // TODO: deployed GhoReserve on X-Layer (assuming single reserve for all GSMs)
  IGhoReserve public constant GHO_RESERVE = IGhoReserve(address(0));

  // TODO: deployed GhoGsmSteward on X-Layer
  address public constant GHO_GSM_STEWARD = address(0);

  // TODO: deployed GsmRegistry on X-Layer
  address public constant GSM_REGISTRY = address(0);

  // GSM USDT
  // TODO: deployed stataUSDT Remote GSM on X-Layer
  address public constant GSM_USDT = address(0);

  // TODO: deployed USDT OracleSwapFreezer on X-Layer
  address public constant USDT_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on X-Layer (mint 0% / burn 0.10%)
  address public constant GSM_USDT_FEE_STRATEGY = address(0);

  // GSM USDC
  // TODO: deployed stataUSDC Remote GSM on X-Layer
  address public constant GSM_USDC = address(0);

  // TODO: deployed USDC OracleSwapFreezer on X-Layer
  address public constant USDC_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on X-Layer (mint 0% / burn 0.10%)
  address public constant GSM_USDC_FEE_STRATEGY = address(0);

  function execute() external {
    GHO_RESERVE.grantRole(GHO_RESERVE.LIMIT_MANAGER_ROLE(), GhoXLayer.RISK_COUNCIL);

    _wireGsm(
      IGsm(GSM_USDT),
      RemoteGSMLaunchXLayerConstants.GSM_USDT_RESERVE_LIMIT,
      USDT_ORACLE_SWAP_FREEZER,
      RemoteGSMLaunchXLayerConstants.GSM_USDT_INITIAL_EXPOSURE_CAP,
      GSM_USDT_FEE_STRATEGY
    );
    _wireGsm(
      IGsm(GSM_USDC),
      RemoteGSMLaunchXLayerConstants.GSM_USDC_RESERVE_LIMIT,
      USDC_ORACLE_SWAP_FREEZER,
      RemoteGSMLaunchXLayerConstants.GSM_USDC_INITIAL_EXPOSURE_CAP,
      GSM_USDC_FEE_STRATEGY
    );

    AaveV3XLayer.COLLECTOR.transfer(
      IERC20(GhoXLayer.GHO_TOKEN),
      address(GHO_RESERVE),
      RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT
    );

    // Restore bridge limits after GHO bridging.
    // Facilitator Bucket Capacity does not need to change.
    IUpgradeableBurnMintTokenPool(GhoXLayer.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE
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
    gsm.grantRole(swapFreezerRole, GovernanceV3XLayer.EXECUTOR_LVL_1);

    // Add GSMs to GSM Registry
    IGsmRegistry(GSM_REGISTRY).addGsm(address(gsm));

    // GHO GSM Steward
    gsm.grantRole(gsm.CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // Update deployed exposure cap to initial value
    gsm.updateExposureCap(initialExposureCap);

    gsm.updateFeeStrategy(feeStrategy);
  }
}
