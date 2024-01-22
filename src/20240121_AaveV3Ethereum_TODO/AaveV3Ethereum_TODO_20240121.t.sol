// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';

import 'forge-std/Test.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/ProtocolV2TestBase.sol';
import {AaveV3Ethereum_TODO_20240121} from './AaveV3Ethereum_TODO_20240121.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

/**
 * @dev Test for AaveV3Ethereum_TODO_20240121
 * command: make test-contract filter=AaveV3Ethereum_TODO_20240121
 */
contract AaveV3Ethereum_TODO_20240121_Test is ProtocolV2TestBase {
  AaveV3Ethereum_TODO_20240121 internal proposal;
  address internal swapper = 0x72427dA7EFBa1585E94F30C72221d8d394aE3Bb7;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19057745);
    proposal = new AaveV3Ethereum_TODO_20240121();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    address collector = address(AaveV3Ethereum.COLLECTOR);
    executePayload(vm, address(proposal));
    uint256 collectorAllowance = IERC20(proposal.INPUT()).allowance(collector, swapper);

    assertEq(collectorAllowance, type(uint256).max);
  }
}
