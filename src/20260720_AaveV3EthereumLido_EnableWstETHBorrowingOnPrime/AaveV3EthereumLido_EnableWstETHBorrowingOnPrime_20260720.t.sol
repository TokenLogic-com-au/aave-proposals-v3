// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720} from './AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720.sol';

/**
 * @dev Test for AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260720_AaveV3EthereumLido_EnableWstETHBorrowingOnPrime/AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720.t.sol -vv
 */
contract AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720_Test is ProtocolV3TestBase {
  AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25576654);
    proposal = new AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720',
      AaveV3EthereumLido.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](1);
    updatedAssets[0] = AaveV3EthereumLidoAssets.wstETH_UNDERLYING;
    reserveConfigChangesTest(AaveV3EthereumLido.POOL, address(proposal), updatedAssets);
  }

  function _expectedBorrowChanges()
    internal
    pure
    override
    returns (IAaveV3ConfigEngine.BorrowUpdate[] memory)
  {
    IAaveV3ConfigEngine.BorrowUpdate[] memory borrowUpdates;
    borrowUpdates = new IAaveV3ConfigEngine.BorrowUpdate[](1);

    borrowUpdates[0] = IAaveV3ConfigEngine.BorrowUpdate({
      asset: AaveV3EthereumLidoAssets.wstETH_UNDERLYING,
      enabledToBorrow: EngineFlags.ENABLED,
      flashloanable: EngineFlags.KEEP_CURRENT,
      reserveFactor: EngineFlags.KEEP_CURRENT
    });
    return borrowUpdates;
  }
}
