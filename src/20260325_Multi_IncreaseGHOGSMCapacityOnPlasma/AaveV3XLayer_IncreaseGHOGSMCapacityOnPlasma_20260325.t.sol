// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3XLayer} from 'aave-address-book/AaveV3XLayer.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325} from './AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325.sol';

/**
 * @dev Test for AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol -vv
 */
contract AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325_Test is ProtocolV3TestBase {
  AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('xlayer'), 55681365);
    proposal = new AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325',
      AaveV3XLayer.POOL,
      address(proposal)
    );
  }
}
