// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';
import {ISvrOracleSteward} from '../interfaces/ISvrOracleSteward.sol';
import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012} from './AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012.sol';

/**
 * @dev Test for AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012.t.sol -vv
 */
contract AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012_Test is ProtocolV3TestBase {
  AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('bnb'), 127245802);
    proposal = new AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    // TODO: remove once the steward and SVR oracle addresses are set
    vm.skip(true);

    defaultTest(
      'AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012',
      AaveV3BNB.POOL,
      address(proposal)
    );
  }

  function test_activation() public {
    // TODO: remove once the steward and SVR oracle addresses are set
    vm.skip(true);

    ISvrOracleSteward.AssetOracle[] memory cfg = proposal.getSvrOracles();

    for (uint256 i = 0; i < cfg.length; i++) {
      assertNotEq(AaveV3BNB.ORACLE.getSourceOfAsset(cfg[i].asset), cfg[i].svrOracle);
    }

    executePayload(vm, address(proposal), AaveV3BNB.POOL);

    for (uint256 i = 0; i < cfg.length; i++) {
      assertEq(AaveV3BNB.ORACLE.getSourceOfAsset(cfg[i].asset), cfg[i].svrOracle);
    }
  }
}
