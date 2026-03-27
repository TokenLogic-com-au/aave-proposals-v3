// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle} from 'aave-address-book/AaveV3Mantle.sol';
import {GhoMantle} from 'aave-address-book/GhoMantle.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325} from './AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325.sol';

/**
 * @dev Test for AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol -vv
 */
contract AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325_Test is ProtocolV3TestBase {
  AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mantle'), 93160044);
    proposal = new AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325',
      AaveV3Mantle.POOL,
      address(proposal),
      false,
      false
    );
  }

  function test_newBucketCapacity() public {
    (uint256 limit, ) = IGhoToken(GhoMantle.GHO_TOKEN).getFacilitatorBucket(
      GhoMantle.GHO_CCIP_TOKEN_POOL
    );
    assertLt(limit, proposal.NEW_BRIDGE_LIMIT());

    executePayload(vm, address(proposal));

    (limit, ) = IGhoToken(GhoMantle.GHO_TOKEN).getFacilitatorBucket(GhoMantle.GHO_CCIP_TOKEN_POOL);
    assertEq(limit, proposal.NEW_BRIDGE_LIMIT());
  }
}
