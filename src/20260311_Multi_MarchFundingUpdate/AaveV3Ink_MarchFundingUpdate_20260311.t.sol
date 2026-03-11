// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3InkWhitelabel} from 'aave-address-book/AaveV3InkWhitelabel.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ink_MarchFundingUpdate_20260311} from './AaveV3Ink_MarchFundingUpdate_20260311.sol';

/**
 * @dev Test for AaveV3Ink_MarchFundingUpdate_20260311
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260311_Multi_MarchFundingUpdate/AaveV3Ink_MarchFundingUpdate_20260311.t.sol -vv
 */
contract AaveV3Ink_MarchFundingUpdate_20260311_Test is ProtocolV3TestBase {
  AaveV3Ink_MarchFundingUpdate_20260311 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('Ink'), 39760729);
    proposal = new AaveV3Ink_MarchFundingUpdate_20260311();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ink_MarchFundingUpdate_20260311',
      AaveV3InkWhitelabel.POOL,
      address(proposal)
    );
  }
}
