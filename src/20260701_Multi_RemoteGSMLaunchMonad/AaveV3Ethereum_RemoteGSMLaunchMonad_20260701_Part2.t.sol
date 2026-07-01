// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IAaveGhoCcipBridge} from 'aave-helpers/src/bridges/ccip/interfaces/IAaveGhoCcipBridge.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1} from './AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1.sol';
import {AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2} from './AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @dev Test for AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2.t.sol -vv
 *
 * NOTE: every test here executes Part 2, which registers the (not-yet-deployed)
 * `DIRECT_FACILITATOR` and bridges to the `MONAD_BRIDGE_DESTINATION`. While those are still
 * address(0), the execution tests are skipped via `_skipIfNotDeployed`; they activate
 * automatically once the real addresses are set in the payload.
 * TODO: setUp executes Part 1, which requires the Ethereum -> Monad GHO lane to already exist on
 * the mainnet GHO_CCIP_TOKEN_POOL at the pinned block.
 */
contract AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2_Test is ProtocolV3TestBase {
  AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1 internal part1;
  AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25424170);
    part1 = new AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1();
    proposal = new AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2();

    // Run Part 1 so the GHO_CCIP_TOKEN_POOL bridge limit and outbound rate limiter are
    // raised before any Part 2 test runs. Without this, Part 2's `IAaveGhoCcipBridge.send`
    // would revert (rate-limit exceeded). Mirrors the real on-chain sequencing.
    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1); // let the outbound rate limiter refill to capacity
  }

  /// @dev Skips the calling test while the launch addresses are still placeholders.
  function _skipIfNotDeployed() internal {
    vm.skip(proposal.DIRECT_FACILITATOR() == address(0));
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    _skipIfNotDeployed();
    defaultTest(
      'AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_ccipBridgeDestinationChainSetUp() public {
    _skipIfNotDeployed();
    IAaveGhoCcipBridge bridge = IAaveGhoCcipBridge(proposal.CCIP_BRIDGE());

    IAaveGhoCcipBridge.RemoteChainConfig memory config = bridge.getDestinationRemoteConfig(
      CCIPChainSelectors.MONAD
    );

    assertEq(config.destination, new bytes(0));
    assertEq(config.extraArgsOverride, new bytes(0));
    assertEq(config.gasLimit, 0);

    executePayload(vm, address(proposal));

    config = bridge.getDestinationRemoteConfig(CCIPChainSelectors.MONAD);

    assertEq(config.destination, abi.encode(proposal.MONAD_BRIDGE_DESTINATION()));
    assertEq(config.extraArgsOverride, new bytes(0));
    assertEq(config.gasLimit, proposal.MONAD_BRIDGE_GAS_LIMIT());
  }

  function test_bridgeLaneRestored() public {
    _skipIfNotDeployed();
    // setUp already executed Part 1, which raised the outbound rate limiter for the Monad lane to
    // (capacity = TEMP_BRIDGE_CAPACITY, rate = TEMP_BRIDGE_CAPACITY - 1) and warped 1 second so
    // the bucket refilled to capacity.
    IRateLimiter.TokenBucket memory bucket = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.MONAD);

    assertGt(
      bucket.capacity,
      RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_CAPACITY,
      'pre-proposal outbound capacity should be raised'
    );

    executePayload(vm, address(proposal));

    // The Monad lane finishes restored to the standard config after executing the proposal.
    bucket = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.MONAD);

    assertEq(
      bucket.capacity,
      RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-proposal outbound capacity should be restored to standard'
    );
    assertEq(
      bucket.rate,
      RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_RATE,
      'post-proposal outbound rate should be restored to standard'
    );
    assertTrue(bucket.isEnabled, 'post-proposal outbound rate limiter should be enabled');

    // The proposal restores both outbound and inbound configs; assert inbound too.
    bucket = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.MONAD);

    assertEq(
      bucket.capacity,
      RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-proposal inbound capacity should be restored to standard'
    );
    assertEq(
      bucket.rate,
      RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_RATE,
      'post-proposal inbound rate should be restored to standard'
    );
    assertTrue(bucket.isEnabled, 'post-proposal inbound rate limiter should be enabled');
  }

  function test_bridge() public {
    _skipIfNotDeployed();
    // setUp already executed Part 1, raising the bridge limit and outbound rate limiter
    // on the GHO_CCIP_TOKEN_POOL so Part 2's bridge step has the headroom it needs.
    IGhoToken.Facilitator memory facilitator = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING)
      .getFacilitator(proposal.DIRECT_FACILITATOR());

    assertEq(facilitator.bucketCapacity, 0, 'facilitator should not be registered before proposal');
    assertEq(facilitator.bucketLevel, 0, 'facilitator bucket level should be 0 before proposal');

    // messageId is unknown ahead of time, so leave the first indexed topic unchecked.
    vm.expectEmit(false, true, true, true, proposal.CCIP_BRIDGE());
    emit IAaveGhoCcipBridge.BridgeMessageInitiated(
      bytes32(0),
      CCIPChainSelectors.MONAD,
      GovernanceV3Ethereum.EXECUTOR_LVL_1,
      RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT
    );

    executePayload(vm, address(proposal));

    facilitator = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING).getFacilitator(
      proposal.DIRECT_FACILITATOR()
    );

    assertEq(
      facilitator.bucketCapacity,
      RemoteGSMLaunchMonadSetup.DIRECT_FACILITATOR_CAPACITY,
      'facilitator capacity not set to DIRECT_FACILITATOR_CAPACITY'
    );
    assertEq(
      facilitator.bucketLevel,
      RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT,
      'facilitator bucket level should match bridged amount'
    );
  }

  function test_otherLanesUntouched() public {
    _skipIfNotDeployed();
    // This proposal must not change lane capacities other than the single Ethereum <> Monad lane.
    // Snapshot two unrelated lanes (Arbitrum, Base) before and after, and assert they are equal.
    IRateLimiter.TokenBucket memory arbBefore = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.ARBITRUM);
    IRateLimiter.TokenBucket memory baseBefore = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.BASE);

    executePayload(vm, address(proposal));

    IRateLimiter.TokenBucket memory arbAfter = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.ARBITRUM);
    IRateLimiter.TokenBucket memory baseAfter = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.BASE);

    assertEq(arbAfter.capacity, arbBefore.capacity, 'Arbitrum lane capacity should be untouched');
    assertEq(arbAfter.rate, arbBefore.rate, 'Arbitrum lane rate should be untouched');
    assertEq(baseAfter.capacity, baseBefore.capacity, 'Base lane capacity should be untouched');
    assertEq(baseAfter.rate, baseBefore.rate, 'Base lane rate should be untouched');
  }
}
