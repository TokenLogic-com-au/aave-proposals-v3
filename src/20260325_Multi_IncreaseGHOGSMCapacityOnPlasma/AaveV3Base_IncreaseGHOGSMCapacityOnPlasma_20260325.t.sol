// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';
import {GhoBase} from 'aave-address-book/GhoBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325} from './AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325.sol';

/**
 * @dev Test for AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol -vv
 */
contract AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325_Test is ProtocolV3TestBase {
  AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 43830526);
    proposal = new AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325',
      AaveV3Base.POOL,
      address(proposal)
    );
  }

  function test_newBucketCapacity() public {
    (uint256 limit, ) = IGhoToken(GhoBase.GHO_TOKEN).getFacilitatorBucket(
      GhoBase.GHO_CCIP_TOKEN_POOL
    );
    assertLt(limit, proposal.NEW_BRIDGE_LIMIT());

    executePayload(vm, address(proposal));

    (limit, ) = IGhoToken(GhoBase.GHO_TOKEN).getFacilitatorBucket(GhoBase.GHO_CCIP_TOKEN_POOL);
    assertEq(limit, proposal.NEW_BRIDGE_LIMIT());
  }
}
