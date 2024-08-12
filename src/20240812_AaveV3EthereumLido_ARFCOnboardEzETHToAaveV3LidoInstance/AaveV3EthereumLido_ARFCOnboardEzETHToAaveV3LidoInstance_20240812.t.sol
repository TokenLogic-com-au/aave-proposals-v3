// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3EthereumLido} from 'aave-address-book/AaveV3EthereumLido.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812} from './AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812.sol';

/**
 * @dev Test for AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20240812_AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance/AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812.t.sol -vv
 */
contract AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812_Test is
  ProtocolV3TestBase
{
  AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20513986);
    proposal = new AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812();

    vm.startPrank(0xC8140dA31E6bCa19b287cC35531c2212763C2059);
    IERC20(proposal.ezETH()).transfer(
      address(AaveV3EthereumLido.ACL_ADMIN),
      proposal.ezETH_SEED_AMOUNT()
    );
    vm.stopPrank();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812',
      AaveV3EthereumLido.POOL,
      address(proposal)
    );
  }

  function test_initialFundDeposit() public {
    uint256 prevExecutorBalance = IERC20(proposal.ezETH()).balanceOf(
      address(AaveV3EthereumLido.ACL_ADMIN)
    );

    GovV3Helpers.executePayload(vm, address(proposal));
    (address aTokenAddress, , ) = AaveV3EthereumLido
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveTokensAddresses(proposal.ezETH());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3EthereumLido.COLLECTOR)),
      proposal.ezETH_SEED_AMOUNT()
    );

    uint256 afterExecutorBalance = IERC20(proposal.ezETH()).balanceOf(
      address(AaveV3EthereumLido.ACL_ADMIN)
    );
    assertEq(prevExecutorBalance - afterExecutorBalance, proposal.ezETH_SEED_AMOUNT());
  }
}
