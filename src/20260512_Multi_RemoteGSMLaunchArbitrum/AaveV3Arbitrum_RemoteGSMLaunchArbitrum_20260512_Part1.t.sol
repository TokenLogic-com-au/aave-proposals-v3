// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';

/**
 * @dev Test for AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260512_Multi_RemoteGSMLaunchArbitrum/AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.t.sol -vv
 */
contract AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 462142700);
    proposal = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1',
      AaveV3Arbitrum.POOL,
      address(proposal)
    );
  }

  function test_bridgeLimitIncrease() public {
    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'pre-proposal inbound capacity should be default'
    );
    assertEq(
      bucket.rate,
      proposal.DEFAULT_RATE_LIMITER_RATE(),
      'pre-proposal inbound rate should be default'
    );
    assertTrue(bucket.isEnabled, 'pre-proposal inbound rate limiter should be enabled');

    executePayload(vm, address(proposal));

    vm.warp(block.timestamp + 1);

    bucket = IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      proposal.TEMP_BRIDGE_CAPACITY(),
      'post-proposal inbound capacity should be TEMP_BRIDGE_CAPACITY'
    );
    assertEq(
      bucket.rate,
      proposal.TEMP_BRIDGE_CAPACITY() - 1,
      'post-proposal inbound rate should be TEMP_BRIDGE_CAPACITY - 1'
    );
    assertTrue(bucket.isEnabled, 'post-proposal inbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      proposal.TEMP_BRIDGE_CAPACITY(),
      'inbound tokens should refill to TEMP_BRIDGE_CAPACITY after 1s'
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    // CCIP mints GHO on the destination chain via the token pool facilitator. For the
    // bridged amount to land on Arbitrum, that facilitator's bucket capacity must be
    // raised to at least TEMP_BRIDGE_CAPACITY before the bridge runs.
    IGhoToken gho = IGhoToken(GhoArbitrum.GHO_TOKEN);

    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );
    uint128 preBucketLevel = preFacilitator.bucketLevel;

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );

    assertEq(
      postFacilitator.bucketCapacity,
      preFacilitator.bucketCapacity + proposal.TEMP_BRIDGE_CAPACITY(),
      'post-proposal facilitator capacity should have incremented by TEMP_BRIDGE_CAPACITY'
    );
    assertEq(
      postFacilitator.bucketLevel,
      preBucketLevel,
      'facilitator bucket level should be unchanged by the capacity update'
    );
  }
}
