// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Plasma} from 'aave-address-book/AaveV3Plasma.sol';
import {GhoPlasma} from 'aave-address-book/GhoPlasma.sol';
import {GovernanceV3Plasma} from 'aave-address-book/GovernanceV3Plasma.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {IRateLimiter} from 'src/interfaces/ccip/IRateLimiter.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2} from './AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.sol';

/**
 * @dev Test for AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.t.sol -vv
 */
contract AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2_Test is ProtocolV3TestBase {
  AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('plasma'), 18757880);
    proposal = new AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2();

    deal(GhoPlasma.GHO_TOKEN, address(AaveV3Plasma.COLLECTOR), 50_000_000 ether);
  }

  function test_executionFailsNoFunds() public {
    AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2 newProposal = new AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2();
    vm.expectRevert();
    vm.prank(GovernanceV3Plasma.EXECUTOR_LVL_1);
    newProposal.execute();
  }

  function test_tokenPoolLimits() public {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.PLASMA,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoPlasma.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoPlasma.GHO_CCIP_TOKEN_POOL)
          .getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
    }

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoPlasma.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool_1_5_1(GhoPlasma.GHO_CCIP_TOKEN_POOL)
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
