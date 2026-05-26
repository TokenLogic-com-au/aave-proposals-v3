// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526} from './AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526.sol';
import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @dev Test for AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260526_Multi_RemoteGSMLaunchXLayer/AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526.t.sol -vv
 */
contract AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526_Test is ProtocolV3TestBase {
  AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 84734234);
    proposal = new AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526();
  }

  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Avalanche_RemoteGSMLaunchXLayer_20260526',
      AaveV3Avalanche.POOL,
      address(proposal)
    );
  }

  function test_facilitatorBucketCapacityIncrease() public {
    IGhoToken gho = IGhoToken(GhoAvalanche.GHO_TOKEN);
    IGhoToken.Facilitator memory preFacilitator = gho.getFacilitator(
      GhoAvalanche.GHO_CCIP_TOKEN_POOL
    );

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory postFacilitator = gho.getFacilitator(
      GhoAvalanche.GHO_CCIP_TOKEN_POOL
    );

    assertEq(
      postFacilitator.bucketCapacity,
      preFacilitator.bucketCapacity + RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT,
      'post-proposal facilitator capacity should have incremented by GHO_BRIDGE_AMOUNT'
    );
    assertEq(
      postFacilitator.bucketLevel,
      preFacilitator.bucketLevel,
      'facilitator bucket level should be unchanged by the capacity update'
    );
  }
}
