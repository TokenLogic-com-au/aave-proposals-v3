// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724} from './AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724.sol';

/**
 * @dev Test for AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20240724_AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum/AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724.t.sol -vv
 */
contract AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724_Test is ProtocolV3TestBase {
  AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 20491191);
    proposal = new AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724();

    vm.startPrank(0x22561c5931143536309C17e832587b625C390b9A);
    IERC20(proposal.rsETH()).transfer(
      address(AaveV3Ethereum.ACL_ADMIN),
      proposal.rsETH_SEED_AMOUNT()
    );
    vm.stopPrank();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_initialFundDeposit() public {
    uint256 prevExecutorBalance = IERC20(proposal.rsETH()).balanceOf(
      address(AaveV3Ethereum.ACL_ADMIN)
    );

    GovV3Helpers.executePayload(vm, address(proposal));
    (address aTokenAddress, , ) = AaveV3Ethereum
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveTokensAddresses(proposal.rsETH());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Ethereum.COLLECTOR)),
      proposal.rsETH_SEED_AMOUNT()
    );

    uint256 afterExecutorBalance = IERC20(proposal.rsETH()).balanceOf(
      address(AaveV3Ethereum.ACL_ADMIN)
    );
    assertEq(prevExecutorBalance - afterExecutorBalance, proposal.rsETH_SEED_AMOUNT());
  }
}
