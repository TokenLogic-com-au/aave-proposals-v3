// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Arbitrum_AddFlashBorrowers_20240821} from './AaveV3Arbitrum_AddFlashBorrowers_20240821.sol';

/**
 * @dev Test for AaveV3Arbitrum_AddFlashBorrowers_20240821
 * command: FOUNDRY_PROFILE=arbitrum forge test --match-path=src/20240821_Multi_AddFlashBorrowers/AaveV3Arbitrum_AddFlashBorrowers_20240821.t.sol -vv
 */
contract AaveV3Arbitrum_AddFlashBorrowers_20240821_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_AddFlashBorrowers_20240821 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 245217825);
    proposal = new AaveV3Arbitrum_AddFlashBorrowers_20240821();
  }

  function test_isFlashBorrower() external {
    GovV3Helpers.executePayload(vm, address(proposal));
    bool isFlashBorrower = AaveV3Arbitrum.ACL_MANAGER.isFlashBorrower(
      proposal.CIAN_FLASH_LOAN_HELPER()
    );
    assertEq(isFlashBorrower, true);
  }
}
