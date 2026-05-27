// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle} from 'aave-address-book/AaveV3Mantle.sol';
import {GhoMantle} from 'aave-address-book/GhoMantle.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1} from './AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1.sol';
import {RemoteGSMLaunchMantleConstants} from './setup/RemoteGSMLaunchMantleConstants.sol';

/**
 * @dev Test for AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1.t.sol -vv
 */
contract AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1_Test is ProtocolV3TestBase {
  // Existing on-chain rate-limiter values for the Eth->Mantle GHO lane.
  // The proposal intentionally raises these to the new defaults
  // (DEFAULT_RATE_LIMITER_CAPACITY / DEFAULT_RATE_LIMITER_RATE in the constants file).
  uint128 internal constant EXISTING_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 internal constant EXISTING_RATE_LIMITER_RATE = 300 ether;

  AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mantle'), 95179108);
    proposal = new AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1();
  }

  function test_defaultProposalExecution() public {
    // e2e is skipped: at this fork block no Mantle reserve satisfies all of ProtocolV3TestBase._getGoodCollateral's
    // gates (active, unfrozen, not paused, usable as collateral, debtCeiling == 0, ltv != 0), so the default e2e
    // supply / borrow path reverts with "No usable collateral found".
    // This payload only touches the GHO CCIP bucket capacity and lane rate-limit config.
    // It does not modify pool reserves, so e2e adds no coverage here.
    defaultTest(
      'AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1',
      AaveV3Mantle.POOL,
      address(proposal),
      false,
      false
    );
  }

  function test_bridgeLimitIncrease() public {
    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoMantle.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      EXISTING_RATE_LIMITER_CAPACITY,
      'pre-proposal inbound capacity should match existing on-chain value'
    );
    assertEq(
      bucket.rate,
      EXISTING_RATE_LIMITER_RATE,
      'pre-proposal inbound rate should match existing on-chain value'
    );
    assertTrue(bucket.isEnabled, 'pre-proposal inbound rate limiter should be enabled');

    executePayload(vm, address(proposal));

    vm.warp(block.timestamp + 1);

    bucket = IUpgradeableBurnMintTokenPool(GhoMantle.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      RemoteGSMLaunchMantleConstants.TEMP_BRIDGE_CAPACITY,
      'post-proposal inbound capacity should be TEMP_BRIDGE_CAPACITY'
    );
    assertEq(
      bucket.rate,
      RemoteGSMLaunchMantleConstants.TEMP_BRIDGE_CAPACITY - 1,
      'post-proposal inbound rate should be TEMP_BRIDGE_CAPACITY - 1'
    );
    assertTrue(bucket.isEnabled, 'post-proposal inbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      RemoteGSMLaunchMantleConstants.TEMP_BRIDGE_CAPACITY,
      'inbound tokens should refill to TEMP_BRIDGE_CAPACITY after 1s'
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    // CCIP mints GHO on the destination chain via the token pool facilitator. For the
    // bridged amount to land on Mantle, that facilitator's bucket capacity must be
    // raised by at least GHO_BRIDGE_AMOUNT before the bridge runs.
    IGhoToken gho = IGhoToken(GhoMantle.GHO_TOKEN);

    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(GhoMantle.GHO_CCIP_TOKEN_POOL);
    uint128 preBucketLevel = preFacilitator.bucketLevel;

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(
      GhoMantle.GHO_CCIP_TOKEN_POOL
    );

    assertEq(
      postFacilitator.bucketCapacity,
      preFacilitator.bucketCapacity + RemoteGSMLaunchMantleConstants.GHO_BRIDGE_AMOUNT,
      'post-proposal facilitator capacity should have incremented by GHO_BRIDGE_AMOUNT'
    );
    assertEq(
      postFacilitator.bucketLevel,
      preBucketLevel,
      'facilitator bucket level should be unchanged by the capacity update'
    );
  }
}
