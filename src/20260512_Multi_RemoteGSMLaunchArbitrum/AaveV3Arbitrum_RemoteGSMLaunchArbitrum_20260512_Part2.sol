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
  // TODO: deployed GhoReserve on Arbitrum (assuming single reserve for all GSMs)
  IGhoReserve public constant GHO_RESERVE = IGhoReserve(address(0));
  uint256 public constant BRIDGED_AMOUNT = 50_000_000 ether;

  // TODO: deployed GhoGsmSteward on Arbitrum
  address public constant GHO_GSM_STEWARD = address(0);

  // TODO: deployed GsmRegistry on Arbitrum
  address public constant GSM_REGISTRY = address(0);

  // GSM USDT
  uint128 public constant GSM_USDT_RESERVE_LIMIT = 50_000_000 ether;

  uint128 public constant GSM_USDT_INITIAL_EXPOSURE_CAP = 10_000_000e6; // 10M, 6 decimals

  // TODO: deployed stataUSDT Remote GSM on Arbitrum
  address public constant GSM_USDT = address(0);

  // TODO: deployed USDT OracleSwapFreezer on Arbitrum
  address public constant USDT_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on Arbitrum (mint 0% / burn 0.10%)
  address public constant GSM_USDT_FEE_STRATEGY = address(0);

  // GSM USDC
  uint128 public constant GSM_USDC_RESERVE_LIMIT = 50_000_000 ether;

  uint128 public constant GSM_USDC_INITIAL_EXPOSURE_CAP = 10_000_000e6; // 10M, 6 decimals

  // TODO: deployed stataUSDC Remote GSM on Arbitrum
  address public constant GSM_USDC = address(0);

  // TODO: deployed USDC OracleSwapFreezer on Arbitrum
  address public constant USDC_ORACLE_SWAP_FREEZER = address(0);

  // TODO: deployed FeeStrategy on Arbitrum (mint 0% / burn 0.10%)
  address public constant GSM_USDC_FEE_STRATEGY = address(0);

  function execute() external {
    GHO_RESERVE.grantRole(GHO_RESERVE.LIMIT_MANAGER_ROLE(), GhoArbitrum.RISK_COUNCIL);

    _wireGsm(
      IGsm(GSM_USDT),
      USDT_ORACLE_SWAP_FREEZER,
      GSM_USDT_INITIAL_EXPOSURE_CAP,
      GSM_USDT_FEE_STRATEGY,
      GSM_USDT_RESERVE_LIMIT
    );
    _wireGsm(
      IGsm(GSM_USDC),
      USDC_ORACLE_SWAP_FREEZER,
      GSM_USDC_INITIAL_EXPOSURE_CAP,
      GSM_USDC_FEE_STRATEGY,
      GSM_USDC_RESERVE_LIMIT
    );

    AaveV3Arbitrum.COLLECTOR.transfer(
      IERC20(GhoArbitrum.GHO_TOKEN),
      address(GHO_RESERVE),
      BRIDGED_AMOUNT
    );

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
    gsm.grantRole(swapFreezerRole, GovernanceV3Arbitrum.EXECUTOR_LVL_1);

    // Add GSMs to GSM Registry
    IGsmRegistry(GSM_REGISTRY).addGsm(address(gsm));

    // GHO GSM Steward
    gsm.grantRole(gsm.CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // Update deployed exposure cap to initial value
    gsm.updateExposureCap(initialExposureCap);

    gsm.updateFeeStrategy(feeStrategy);
  }
}
