// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3XLayer} from 'aave-address-book/AaveV3XLayer.sol';
import {GhoXLayer} from 'aave-address-book/GhoXLayer.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512} from './AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512.sol';
import {RemoteGSMLaunchArbitrumConstants} from './setup/RemoteGSMLaunchArbitrumConstants.sol';

/**
 * @dev Test for AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260512_Multi_RemoteGSMLaunchArbitrum/AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512.t.sol -vv
 */
contract AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512_Test is ProtocolV3TestBase {
  AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512 internal proposal;

  function setUp() public {
    // TODO: pick a current X-Layer block number to pin the fork.
    vm.createSelectFork(vm.rpcUrl('xlayer'));
    proposal = new AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3XLayer_RemoteGSMLaunchArbitrum_20260512',
      AaveV3XLayer.POOL,
      address(proposal)
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    IGhoToken gho = IGhoToken(GhoXLayer.GHO_TOKEN);
    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(GhoXLayer.GHO_CCIP_TOKEN_POOL);

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(
      GhoXLayer.GHO_CCIP_TOKEN_POOL
    );

    assertEq(
      postFacilitator.bucketCapacity,
      preFacilitator.bucketCapacity + RemoteGSMLaunchArbitrumConstants.GHO_BRIDGE_AMOUNT,
      'post-proposal facilitator capacity should have incremented by GHO_BRIDGE_AMOUNT'
    );
    assertEq(
      postFacilitator.bucketLevel,
      preFacilitator.bucketLevel,
      'facilitator bucket level should be unchanged by the capacity update'
    );
  }

  function test_ethereumLaneRateLimitNormalized() public {
    executePayload(vm, address(proposal));

    IRateLimiter.TokenBucket memory inbound = IUpgradeableBurnMintTokenPool(
      GhoXLayer.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      inbound.capacity,
      RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-proposal inbound capacity should be default'
    );
    assertEq(
      inbound.rate,
      RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_RATE,
      'post-proposal inbound rate should be default'
    );
    assertTrue(inbound.isEnabled, 'post-proposal inbound rate limiter should be enabled');

    IRateLimiter.TokenBucket memory outbound = IUpgradeableBurnMintTokenPool(
      GhoXLayer.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      outbound.capacity,
      RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-proposal outbound capacity should be default'
    );
    assertEq(
      outbound.rate,
      RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_RATE,
      'post-proposal outbound rate should be default'
    );
    assertTrue(outbound.isEnabled, 'post-proposal outbound rate limiter should be enabled');
  }
}
