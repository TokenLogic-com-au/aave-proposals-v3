// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IStreamable} from 'aave-address-book/common/IStreamable.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526} from './AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526.sol';

/**
 * @dev Test for AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526.t.sol -vv
 */
contract AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526_Test is ProtocolV3TestBase {
  AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25177100);
    proposal = new AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_aaveStreamCreated() public {
    IStreamable reserve = IStreamable(MiscEthereum.ECOSYSTEM_RESERVE);
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = reserve.getNextStreamId();
    uint256 expectedAmount = (proposal.AAVE_STREAM_AMOUNT() / proposal.STREAM_DURATION()) *
      proposal.STREAM_DURATION();

    vm.expectRevert();
    reserve.getStream(nextStreamId);

    executePayload(vm, address(proposal));

    (
      address sender,
      address streamReceiver,
      uint256 deposit,
      address tokenAddress,
      uint256 startTime,
      uint256 stopTime,
      ,

    ) = reserve.getStream(nextStreamId);

    assertEq(sender, MiscEthereum.ECOSYSTEM_RESERVE);
    assertEq(streamReceiver, receiver);
    assertEq(tokenAddress, AaveV3EthereumAssets.AAVE_UNDERLYING);
    assertEq(stopTime - startTime, proposal.STREAM_DURATION());
    assertEq(deposit, expectedAmount);
  }

  function test_aaveStreamPartialWithdraw() public {
    IStreamable reserve = IStreamable(MiscEthereum.ECOSYSTEM_RESERVE);
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = reserve.getNextStreamId();

    executePayload(vm, address(proposal));

    vm.warp(block.timestamp + 1 days);

    uint256 balanceBefore = IERC20(AaveV3EthereumAssets.AAVE_UNDERLYING).balanceOf(receiver);

    vm.prank(receiver);
    reserve.withdrawFromStream(nextStreamId, 1);

    uint256 balanceAfter = IERC20(AaveV3EthereumAssets.AAVE_UNDERLYING).balanceOf(receiver);
    assertEq(balanceAfter, balanceBefore + 1);
  }

  function test_aaveStreamEndBalance() public {
    IStreamable reserve = IStreamable(MiscEthereum.ECOSYSTEM_RESERVE);
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = reserve.getNextStreamId();
    uint256 expectedAmount = (proposal.AAVE_STREAM_AMOUNT() / proposal.STREAM_DURATION()) *
      proposal.STREAM_DURATION();

    executePayload(vm, address(proposal));

    vm.warp(block.timestamp + proposal.STREAM_DURATION());

    uint256 streamable = reserve.balanceOf(nextStreamId, receiver);
    assertEq(streamable, expectedAmount);

    uint256 balanceBefore = IERC20(AaveV3EthereumAssets.AAVE_UNDERLYING).balanceOf(receiver);

    vm.prank(receiver);
    reserve.withdrawFromStream(nextStreamId, streamable);

    uint256 balanceAfter = IERC20(AaveV3EthereumAssets.AAVE_UNDERLYING).balanceOf(receiver);
    assertEq(balanceAfter, balanceBefore + expectedAmount);
  }
}
