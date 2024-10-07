// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_GHOStewardV2Upgrade_20241007} from './AaveV3Ethereum_GHOStewardV2Upgrade_20241007.sol';

/**
 * @dev Test for AaveV3Ethereum_GHOStewardV2Upgrade_20241007
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20241007_Multi_GHOStewardV2Upgrade/AaveV3Ethereum_GHOStewardV2Upgrade_20241007.t.sol -vv
 */
contract AaveV3Ethereum_GHOStewardV2Upgrade_20241007_Test is ProtocolV3TestBase {
  AaveV3Ethereum_GHOStewardV2Upgrade_20241007 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20914155);
    proposal = new AaveV3Ethereum_GHOStewardV2Upgrade_20241007();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_GHOStewardV2Upgrade_20241007',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }
}
