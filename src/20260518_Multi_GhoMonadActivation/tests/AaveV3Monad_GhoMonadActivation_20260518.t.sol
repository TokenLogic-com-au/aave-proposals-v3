// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Monad} from 'aave-address-book/AaveV3Monad.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Monad_GhoMonadActivation_20260518} from '../AaveV3Monad_GhoMonadActivation_20260518.sol';

/**
 * @dev Test for AaveV3Monad_GhoMonadActivation_20260518
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260518_Multi_GhoMonadActivation/tests/AaveV3Monad_GhoMonadActivation_20260518.t.sol -vv
 */
contract AaveV3Monad_GhoMonadActivation_20260518_Test is ProtocolV3TestBase {
  AaveV3Monad_GhoMonadActivation_20260518 internal proposal;
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('monad'), 82069090);
    proposal = new AaveV3Monad_GhoMonadActivation_20260518();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Monad_GhoMonadActivation_20260518',
      AaveV3Monad.POOL,
      address(proposal),
      false,
      false
    );
  }
}
