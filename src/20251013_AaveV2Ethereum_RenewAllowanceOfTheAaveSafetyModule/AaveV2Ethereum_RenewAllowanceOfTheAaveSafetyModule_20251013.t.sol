// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV2TestBase.sol';
import {AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013} from './AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013.sol';

/**
 * @dev Test for AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20251013_AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule/AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013.t.sol -vv
 */
contract AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013_Test is ProtocolV2TestBase {
  AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 23567428);
    proposal = new AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013',
      AaveV2Ethereum.POOL,
      address(proposal)
    );
  }
}
