// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido} from 'aave-address-book/AaveV3EthereumLido.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429} from './AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429.sol';

/**
 * @dev Test for AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250429_Multi_ExtendSVRV1ToMoreReserves/AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429.t.sol -vv
 */
contract AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429_Test is ProtocolV3TestBase {
  AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 22374933);
    proposal = new AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3EthereumLido_ExtendSVRV1ToMoreReserves_20250429',
      AaveV3EthereumLido.POOL,
      address(proposal)
    );
  }
}
