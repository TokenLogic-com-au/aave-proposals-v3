// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Sonic} from 'aave-address-book/AaveV3Sonic.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Sonic_DeployGHOOnSonic_20250519} from './AaveV3Sonic_DeployGHOOnSonic_20250519.sol';

/**
 * @dev Test for AaveV3Sonic_DeployGHOOnSonic_20250519
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250519_Multi_DeployGHOOnSonic/AaveV3Sonic_DeployGHOOnSonic_20250519.t.sol -vv
 */
contract AaveV3Sonic_DeployGHOOnSonic_20250519_Test is ProtocolV3TestBase {
  AaveV3Sonic_DeployGHOOnSonic_20250519 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('sonic'), 28001278);
    proposal = new AaveV3Sonic_DeployGHOOnSonic_20250519();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Sonic_DeployGHOOnSonic_20250519', AaveV3Sonic.POOL, address(proposal));
  }
}
