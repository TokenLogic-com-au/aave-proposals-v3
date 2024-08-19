// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_AddFlashborrowers_20240815} from './AaveV3Ethereum_AddFlashborrowers_20240815.sol';

/**
 * @dev Test for AaveV3Ethereum_AddFlashborrowers_20240815
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20240815_Multi_AddFlashborrowers/AaveV3Ethereum_AddFlashborrowers_20240815.t.sol -vv
 */
contract AaveV3Ethereum_AddFlashborrowers_20240815_Test is ProtocolV3TestBase {
  AaveV3Ethereum_AddFlashborrowers_20240815 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20535321);
    proposal = new AaveV3Ethereum_AddFlashborrowers_20240815();
  }

  function test_isFlashBorrower() external {
    GovV3Helpers.executePayload(vm, address(proposal));
    bool isFlashBorrower = AaveV3Ethereum.ACL_MANAGER.isFlashBorrower(
      proposal.CIAN_PROTOCOL_FLASHLOAN_HELPER()
    );
    assertEq(isFlashBorrower, true);
  }
}
