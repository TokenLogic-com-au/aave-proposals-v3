// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';

/**
 * @title Remote GSM Launch: Arbitrum
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 *
 * NOTE: granting RISK_ADMIN_ROLE on AaveV3Arbitrum.ACL_MANAGER to a GhoAaveSteward
 * is intentionally OUT OF SCOPE for this proposal. If a steward is not already
 * empowered on Arbitrum, that grant must be made in a separate proposal before
 * the steward can call updateGhoBorrowCap / updateGhoBorrowRate / updateGhoSupplyCap.
 */
contract AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 300 ether;

  // GhoReserve
  // TODO: deployed GhoReserve on Arbitrum
  address public constant GHO_RESERVE = address(0);
  uint256 public constant BRIDGED_AMOUNT = 50_000_000 ether;

  // Capacities
  uint128 public constant RESERVE_LIMIT_GSM_USDT = 50_000_000 ether;
  // TODO: confirm collateral asset's decimals (6 assumed, mirroring Plasma stataUSDT)
  uint128 public constant INITIAL_EXPOSURE_CAP = 10_000_000e6;

  // TODO: deployed GhoGsmSteward on Arbitrum
  address public constant GHO_GSM_STEWARD = address(0);

  // TODO: deployed GsmRegistry on Arbitrum
  address public constant GSM_REGISTRY = address(0);

  // TODO: deployed stataUSDT Remote GSM on Arbitrum
  address public constant NEW_GSM_USDT = address(0);

  // TODO: deployed USDT OracleSwapFreezer on Arbitrum
  address public constant USDT_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on Arbitrum (mint 0% / burn 0.10%)
  address public constant FEE_STRATEGY = address(0);

  function execute() external {
    _grantAccess();
    IGsm(NEW_GSM_USDT).updateFeeStrategy(FEE_STRATEGY);

    AaveV3Arbitrum.COLLECTOR.transfer(IERC20(GhoArbitrum.GHO_TOKEN), GHO_RESERVE, BRIDGED_AMOUNT);

    // Restore bridge limits after GHO bridging
    IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: DEFAULT_RATE_LIMITER_CAPACITY,
        rate: DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: DEFAULT_RATE_LIMITER_CAPACITY,
        rate: DEFAULT_RATE_LIMITER_RATE
      })
    );
  }

  function _grantAccess() internal {
    IGsm(NEW_GSM_USDT).updateGhoReserve(GHO_RESERVE);

    // Enroll GSMs as entities and set limit
    IGhoReserve(GHO_RESERVE).grantRole(
      IGhoReserve(GHO_RESERVE).LIMIT_MANAGER_ROLE(),
      GhoArbitrum.RISK_COUNCIL
    );
    IGhoReserve(GHO_RESERVE).addEntity(NEW_GSM_USDT);
    IGhoReserve(GHO_RESERVE).setLimit(NEW_GSM_USDT, RESERVE_LIMIT_GSM_USDT);

    // Add GSM Swap Freezer role to OracleSwapFreezers
    bytes32 swapFreezerRole = IGsm(NEW_GSM_USDT).SWAP_FREEZER_ROLE();
    IGsm(NEW_GSM_USDT).grantRole(swapFreezerRole, USDT_ORACLE_SWAP_FREEZER);
    IGsm(NEW_GSM_USDT).grantRole(swapFreezerRole, GovernanceV3Arbitrum.EXECUTOR_LVL_1);

    // Add GSMs to GSM Registry
    IGsmRegistry(GSM_REGISTRY).addGsm(NEW_GSM_USDT);

    // GHO GSM Steward
    IGsm(NEW_GSM_USDT).grantRole(IGsm(NEW_GSM_USDT).CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // Update deployed exposure cap to initial
    IGsm(NEW_GSM_USDT).updateExposureCap(INITIAL_EXPOSURE_CAP);
  }
}
