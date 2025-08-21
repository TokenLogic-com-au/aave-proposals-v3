// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821} from './AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821.sol';

/**
 * @dev Test for AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250821_Multi_StewardDeploymentMainnetSwapStewardAndRewardsSteward/AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821.t.sol -vv
 */
contract AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821_Test is
  ProtocolV3TestBase
{
  AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('bnb'), 58402040);
    proposal = new AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3BNB_StewardDeploymentMainnetSwapStewardAndRewardsSteward_20250821',
      AaveV3BNB.POOL,
      address(proposal)
    );
  }
}
