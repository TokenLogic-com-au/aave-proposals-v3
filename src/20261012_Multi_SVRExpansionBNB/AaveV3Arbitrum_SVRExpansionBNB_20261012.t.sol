// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Arbitrum_SVRExpansionBNB_20261012} from './AaveV3Arbitrum_SVRExpansionBNB_20261012.sol';

/**
 * @dev Test for AaveV3Arbitrum_SVRExpansionBNB_20261012
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261012_Multi_SVRExpansionBNB/AaveV3Arbitrum_SVRExpansionBNB_20261012.t.sol -vv
 */
contract AaveV3Arbitrum_SVRExpansionBNB_20261012_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_SVRExpansionBNB_20261012 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 515457000);
    proposal = new AaveV3Arbitrum_SVRExpansionBNB_20261012();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Arbitrum_SVRExpansionBNB_20261012', AaveV3Arbitrum.POOL, address(proposal));
  }

  function test_stewardRemoved() public {
    assertTrue(AaveV3Arbitrum.ACL_MANAGER.isAssetListingAdmin(proposal.STEWARD()));

    executePayload(vm, address(proposal), AaveV3Arbitrum.POOL);

    assertFalse(AaveV3Arbitrum.ACL_MANAGER.isAssetListingAdmin(proposal.STEWARD()));
  }
}
