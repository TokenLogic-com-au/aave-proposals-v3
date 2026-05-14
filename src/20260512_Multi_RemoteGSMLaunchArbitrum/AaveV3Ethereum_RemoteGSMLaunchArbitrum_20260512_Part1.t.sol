// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';

/**
 * @dev Test for AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260512_Multi_RemoteGSMLaunchArbitrum/AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1.t.sol -vv
 */
contract AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1_Test is ProtocolV3TestBase {
  AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25080900);
    proposal = new AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_bridgeLimit() public {
    uint256 bridgeLimitBefore = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getBridgeLimit();

    executePayload(vm, address(proposal));

    assertEq(
      IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).getBridgeLimit(),
      bridgeLimitBefore + proposal.TEMP_BRIDGE_CAPACITY(),
      'bridge limit not raised by TEMP_BRIDGE_CAPACITY after proposal'
    );
  }

  function test_rateLimiter() public {
    // Start with default values.
    IRateLimiter.TokenBucket memory bucket = IUpgradeableLockReleaseTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.ARBITRUM);

    assertEq(
      bucket.capacity,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'pre-proposal outbound capacity should be default'
    );
    assertEq(
      bucket.rate,
      proposal.DEFAULT_RATE_LIMITER_RATE(),
      'pre-proposal outbound rate should be default'
    );
    assertTrue(bucket.isEnabled, 'pre-proposal outbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'pre-proposal outbound tokens should equal default capacity'
    );

    executePayload(vm, address(proposal));

    // State moves to new temporary capacity after proposal, but tokens do not change instantly.
    bucket = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.ARBITRUM);

    assertEq(
      bucket.capacity,
      proposal.TEMP_BRIDGE_CAPACITY(),
      'post-proposal outbound capacity should be TEMP_BRIDGE_CAPACITY'
    );
    assertEq(
      bucket.rate,
      proposal.TEMP_BRIDGE_CAPACITY() - 1,
      'post-proposal outbound rate should be TEMP_BRIDGE_CAPACITY - 1'
    );
    assertTrue(bucket.isEnabled, 'post-proposal outbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'tokens should not refill instantly after proposal'
    );

    vm.warp(block.timestamp + 1);

    // 1 second after execution, we have temporary token capacity as well.
    bucket = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.ARBITRUM);

    assertEq(
      bucket.capacity,
      proposal.TEMP_BRIDGE_CAPACITY(),
      'outbound capacity should remain TEMP_BRIDGE_CAPACITY after 1s'
    );
    assertEq(
      bucket.rate,
      proposal.TEMP_BRIDGE_CAPACITY() - 1,
      'outbound rate should remain TEMP_BRIDGE_CAPACITY - 1 after 1s'
    );
    assertTrue(bucket.isEnabled, 'outbound rate limiter should remain enabled after 1s');
    assertEq(
      bucket.tokens,
      proposal.TEMP_BRIDGE_CAPACITY(),
      'tokens should refill to TEMP_BRIDGE_CAPACITY after 1s'
    );
  }
}
