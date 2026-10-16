// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Base_SVRExpansionBNB_20261012} from './AaveV3Base_SVRExpansionBNB_20261012.sol';

/**
 * @dev Test for AaveV3Base_SVRExpansionBNB_20261012
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261012_Multi_SVRExpansionBNB/AaveV3Base_SVRExpansionBNB_20261012.t.sol -vv
 */
contract AaveV3Base_SVRExpansionBNB_20261012_Test is ProtocolV3TestBase {
  AaveV3Base_SVRExpansionBNB_20261012 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 52693200);
    proposal = new AaveV3Base_SVRExpansionBNB_20261012();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Base_SVRExpansionBNB_20261012', AaveV3Base.POOL, address(proposal));
  }

  function test_stewardRemoved() public {
    assertTrue(AaveV3Base.ACL_MANAGER.isAssetListingAdmin(proposal.STEWARD()));

    executePayload(vm, address(proposal), AaveV3Base.POOL);

    assertFalse(AaveV3Base.ACL_MANAGER.isAssetListingAdmin(proposal.STEWARD()));
  }
}
