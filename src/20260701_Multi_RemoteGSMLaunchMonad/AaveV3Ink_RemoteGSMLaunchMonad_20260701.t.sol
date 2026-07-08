// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3InkWhitelabel} from 'aave-address-book/AaveV3InkWhitelabel.sol';
import {GhoInk} from 'aave-address-book/GhoInk.sol';
import {GovernanceV3Ink} from 'aave-address-book/GovernanceV3Ink.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {GhoCCIPChains} from '../helpers/gho-launch/constants/GhoCCIPChains.sol';

import {AaveV3Ink_RemoteGSMLaunchMonad_20260701} from './AaveV3Ink_RemoteGSMLaunchMonad_20260701.sol';
import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @dev Test for AaveV3Ink_RemoteGSMLaunchMonad_20260701
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ink_RemoteGSMLaunchMonad_20260701.t.sol -vv
 */
contract AaveV3Ink_RemoteGSMLaunchMonad_20260701_Test is ProtocolV3TestBase {
  AaveV3Ink_RemoteGSMLaunchMonad_20260701 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ink'), 50043600);
    proposal = new AaveV3Ink_RemoteGSMLaunchMonad_20260701();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  /// forge-config: default.isolate = true
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ink_RemoteGSMLaunchArbitrum_20260512',
      AaveV3InkWhitelabel.POOL,
      address(proposal),
      GovernanceV3Ink.PAYLOADS_CONTROLLER
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    IGhoToken gho = IGhoToken(GhoInk.GHO_TOKEN);
    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(GhoInk.GHO_CCIP_TOKEN_POOL);

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(GhoInk.GHO_CCIP_TOKEN_POOL);

    assertEq(
      postFacilitator.bucketCapacity,
      preFacilitator.bucketCapacity + RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT,
      'post-proposal facilitator capacity should have incremented by GHO_BRIDGE_AMOUNT'
    );
    assertEq(
      postFacilitator.bucketLevel,
      preFacilitator.bucketLevel,
      'facilitator bucket level should be unchanged by the capacity update'
    );
  }

  function test_allLaneRateLimitsNormalized() public {
    // Every lane to every other supported network (itself excluded).
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.INK,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      RemoteGSMLaunchMonadSetup.assertLaneDefaults(
        GhoInk.GHO_CCIP_TOKEN_POOL,
        chains[i].chainSelector,
        false
      );
    }

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
      RemoteGSMLaunchMonadSetup.assertLaneDefaults(
        GhoInk.GHO_CCIP_TOKEN_POOL,
        chains[i].chainSelector,
        true
      );
    }
  }
}
