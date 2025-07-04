// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Celo} from 'aave-address-book/AaveV3Celo.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Celo_AssetParametersOptimization_20250527} from './AaveV3Celo_AssetParametersOptimization_20250527.sol';

/**
 * @dev Test for AaveV3Celo_AssetParametersOptimization_20250527
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250527_Multi_AssetParametersOptimization/AaveV3Celo_AssetParametersOptimization_20250527.t.sol -vv
 */
contract AaveV3Celo_AssetParametersOptimization_20250527_Test is ProtocolV3TestBase {
  AaveV3Celo_AssetParametersOptimization_20250527 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('celo'), 37085611);
    proposal = new AaveV3Celo_AssetParametersOptimization_20250527();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Celo_AssetParametersOptimization_20250527',
      AaveV3Celo.POOL,
      address(proposal)
    );
  }
}
