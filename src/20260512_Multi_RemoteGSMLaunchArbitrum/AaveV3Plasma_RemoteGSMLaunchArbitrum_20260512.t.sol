// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Plasma} from 'aave-address-book/AaveV3Plasma.sol';
import {GhoPlasma} from 'aave-address-book/GhoPlasma.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512} from './AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512.sol';
import {RemoteGSMLaunchArbitrumConstants} from './setup/RemoteGSMLaunchArbitrumConstants.sol';

/**
 * @dev Test for AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260512_Multi_RemoteGSMLaunchArbitrum/AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512.t.sol -vv
 */
contract AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512_Test is ProtocolV3TestBase {
  AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('plasma'), 21132780);
    proposal = new AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Plasma_RemoteGSMLaunchArbitrum_20260512',
      AaveV3Plasma.POOL,
      address(proposal)
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    IGhoToken gho = IGhoToken(GhoPlasma.GHO_TOKEN);
    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(GhoPlasma.GHO_CCIP_TOKEN_POOL);

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(
      GhoPlasma.GHO_CCIP_TOKEN_POOL
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
}
