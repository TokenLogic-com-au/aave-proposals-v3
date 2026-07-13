// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {StdConstants} from 'forge-std/StdConstants.sol';

import {IUpgradeableBurnMintTokenPool} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';

/**
 * @notice Common setup library containing constants and helper functions used in the proposal.
 * @dev See forum post for reference: TODO add the Monad RemoteGSM launch discussion link.
 */
library RemoteGSMLaunchMonadSetup {
  // Amount to mint in Mainnet and bridge to Monad
  uint256 public constant GHO_BRIDGE_AMOUNT = 50_000_000 ether;

  // 50M GHO bridge amount + 10% leeway in case of other bridges
  uint128 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;

  // Standard per-lane transaction limit the Ethereum <> Monad GHO lane is RESTORED to after
  // the one-off 50M bridge. Unlike the Arbitrum launch (TODO: insert link), this proposal does NOT normalize every
  // network's lanes: it only widens the single Ethereum <> Monad lane for the transfer and then
  // puts that lane back to its pre-execution config, leaving every other lane untouched.
  // TODO: these values are assumed to match the Ethereum <> Monad GHO lane's config at execution
  // time (both directions, on both the Ethereum and Monad token pools). Verify on-chain before
  // deploy; if the lane currently uses different values, set them here so the proposal restores
  // the lane faithfully ("keep the capacity the same").
  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000 ether;

  // Refill rate per second the lane is restored to
  uint128 public constant DEFAULT_LIMITER_RATE = 1_000 ether;

  // Facilitator capacity matches bridge amount (as uint128)
  uint128 public constant DIRECT_FACILITATOR_CAPACITY = uint128(GHO_BRIDGE_AMOUNT);

  // Expected GHO facilitator bucket capacity after payloads are executed
  uint128 public constant EXPECTED_BUCKET_CAPACITY = 200_000_000 ether;

  // GSM USDC
  // Maximum amount that can be withdrawn by GSM (can be changed by steward later)
  uint128 public constant GSM_USDC_RESERVE_LIMIT = 25_000_000 ether;

  // 40M underlying (6 decimals).
  // TODO: confirm the intended initial exposure cap for the Monad USDC GSM (and the stataUSDC
  // rate on Monad) once the GSM is deployed.
  uint128 public constant GSM_USDC_INITIAL_EXPOSURE_CAP = 40_000_000e6; // 40M, 6 decimals

  /**
   * @notice Restores the inbound and outbound CCIP rate-limit config of a single GHO lane to the
   * standard config, without touching any other lane on the pool.
   * @dev Used to undo the temporary capacity bump applied for the one-off 50M seed bridge, so the
   * Ethereum <> Monad lane ends the proposal with the same config it had beforehand.
   * @param tokenPool The GHO CCIP token pool whose lane will be restored. Typed as
   * `IUpgradeableLockReleaseTokenPool`, but `setChainRateLimiterConfig` shares the same selector
   * across the lock-release and burn-mint pools, so a burn-mint pool address may also be passed.
   * @param remoteChainSelector The CCIP selector of the remote chain (the lane) to restore.
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

  function assertLaneDefaults(
    address ccipTokenPool,
    uint64 remoteChainSelector,
    bool postProposal
  ) internal {
    // TODO: re-enable tests after ARB proposal is executed and lanes are normalized
    StdConstants.VM.skip(true);
    string memory msgPrefix = postProposal ? 'post' : 'pre';

    IRateLimiter.TokenBucket memory inbound = IUpgradeableBurnMintTokenPool(ccipTokenPool)
      .getCurrentInboundRateLimiterState(remoteChainSelector);

    StdConstants.VM.assertEq(
      inbound.capacity,
      DEFAULT_RATE_LIMITER_CAPACITY,
      string.concat(msgPrefix, '-proposal inbound capacity should be default')
    );
    StdConstants.VM.assertEq(
      inbound.rate,
      DEFAULT_LIMITER_RATE,
      string.concat(msgPrefix, '-proposal inbound rate should be default')
    );
    StdConstants.VM.assertTrue(
      inbound.isEnabled,
      string.concat(msgPrefix, '-proposal inbound rate limiter should be enabled')
    );

    IRateLimiter.TokenBucket memory outbound = IUpgradeableBurnMintTokenPool(ccipTokenPool)
      .getCurrentOutboundRateLimiterState(remoteChainSelector);

    StdConstants.VM.assertEq(
      outbound.capacity,
      DEFAULT_RATE_LIMITER_CAPACITY,
      string.concat(msgPrefix, '-proposal outbound capacity should be default')
    );
    StdConstants.VM.assertEq(
      outbound.rate,
      DEFAULT_LIMITER_RATE,
      string.concat(msgPrefix, '-proposal outbound rate should be default')
    );
    StdConstants.VM.assertTrue(
      outbound.isEnabled,
      string.concat(msgPrefix, '-proposal outbound rate limiter should be enabled')
    );
  }
}
