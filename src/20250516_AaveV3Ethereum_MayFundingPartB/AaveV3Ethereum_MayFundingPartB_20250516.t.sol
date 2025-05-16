// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_MayFundingPartB_20250516} from './AaveV3Ethereum_MayFundingPartB_20250516.sol';

/**
 * @dev Test for AaveV3Ethereum_MayFundingPartB_20250516
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250516_AaveV3Ethereum_MayFundingPartB/AaveV3Ethereum_MayFundingPartB_20250516.t.sol -vv
 */
contract AaveV3Ethereum_MayFundingPartB_20250516_Test is ProtocolV3TestBase {
  AaveV3Ethereum_MayFundingPartB_20250516 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 22496153);
    proposal = new AaveV3Ethereum_MayFundingPartB_20250516();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    executePayload(vm, address(proposal));
  }
}
