// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';

/**
 * @notice Constants and helpers shared by the Ethereum and Avalanche payloads.
 * @dev Forum: https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852
 */
library PermissionedGSMUSATAvalancheSetup {
  // Initial GHO funding, minted on Ethereum and bridged to the Avalanche Collector
  uint256 public constant GHO_BRIDGE_AMOUNT = 65_000_000 ether;

  // Initial GHO funding * 110%, applied to the Ethereum <> Avalanche lane for the one-off transfer
  uint128 public constant TEMP_BRIDGE_CAPACITY = 66_000_000 ether;

  // Ongoing Ethereum <> Avalanche lane config, both directions, on both token pools (current on-chain values)
  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000 ether;
  uint128 public constant DEFAULT_LIMITER_RATE = 1_000 ether;

  uint128 public constant DIRECT_FACILITATOR_CAPACITY = uint128(GHO_BRIDGE_AMOUNT);

  // Remote GSM Draw Limit
  uint256 public constant GSM_RESERVE_LIMIT = 25_000_000 ether;

  // waCoreUSAT shares, 6 decimals (TokenizationSpoke decimals = underlying decimals)
  uint128 public constant GSM_EXPOSURE_CAP = 20_000_000e6;

  /**
   * @notice Restores both directions of one GHO lane to the ongoing config, leaving every other lane untouched.
   * @dev `setChainRateLimiterConfig` has the same selector on the lock-release and burn-mint pools.
   */
  function restoreLaneRateLimitConfig(address tokenPool, uint64 remoteChainSelector) internal {
    IRateLimiter.Config memory standardConfig = IRateLimiter.Config({
      isEnabled: true,
      capacity: DEFAULT_RATE_LIMITER_CAPACITY,
      rate: DEFAULT_LIMITER_RATE
    });

    IUpgradeableLockReleaseTokenPool(tokenPool).setChainRateLimiterConfig(
      remoteChainSelector,
      standardConfig,
      standardConfig
    );
  }
}
