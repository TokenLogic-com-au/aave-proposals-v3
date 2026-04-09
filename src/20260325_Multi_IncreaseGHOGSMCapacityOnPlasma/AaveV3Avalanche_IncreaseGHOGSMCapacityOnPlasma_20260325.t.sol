// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {IRateLimiter} from 'src/interfaces/ccip/IRateLimiter.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325} from './AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325.sol';

/**
 * @dev Test for AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol -vv
 */
contract AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325_Test is ProtocolV3TestBase {
  AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 82460335);
    proposal = new AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325',
      AaveV3Avalanche.POOL,
      address(proposal)
    );
  }

  function test_newBucketCapacity() public {
    (uint256 limit, ) = IGhoToken(GhoAvalanche.GHO_TOKEN).getFacilitatorBucket(
      GhoAvalanche.GHO_CCIP_TOKEN_POOL
    );
    assertLt(limit, proposal.NEW_BRIDGE_LIMIT());

    executePayload(vm, address(proposal));

    (limit, ) = IGhoToken(GhoAvalanche.GHO_TOKEN).getFacilitatorBucket(
      GhoAvalanche.GHO_CCIP_TOKEN_POOL
    );
    assertEq(limit, proposal.NEW_BRIDGE_LIMIT());
  }

  function test_tokenPoolLimits() public {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.AVALANCHE,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoAvalanche.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoAvalanche.GHO_CCIP_TOKEN_POOL)
          .getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
    }

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoAvalanche.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoAvalanche.GHO_CCIP_TOKEN_POOL)
          .getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        _getRateLimiterConfig()
      );
    }
  }

  function _getOldRateLimiterConfig() internal view virtual returns (IRateLimiter.Config memory) {
    return IRateLimiter.Config({isEnabled: true, capacity: 1_500_000e18, rate: 300e18});
  }

  function _getRateLimiterConfig() internal view virtual returns (IRateLimiter.Config memory) {
    return
      IRateLimiter.Config({
        isEnabled: true,
        capacity: proposal.NEW_DEFAULT_RATE_LIMITER_CAPACITY(),
        rate: proposal.NEW_DEFAULT_RATE_LIMITER_RATE()
      });
  }

  function assertEq(
    IRateLimiter.TokenBucket memory bucket,
    IRateLimiter.Config memory config
  ) internal view virtual {
    assertEq(bucket.isEnabled, config.isEnabled);
    assertEq(bucket.capacity, config.capacity);
    assertEq(bucket.rate, config.rate);
  }
}
