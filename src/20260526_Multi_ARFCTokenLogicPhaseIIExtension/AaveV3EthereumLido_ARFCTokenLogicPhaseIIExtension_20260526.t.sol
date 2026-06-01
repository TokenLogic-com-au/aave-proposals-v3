// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {ICollector} from 'aave-v3-origin/contracts/treasury/ICollector.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526} from './AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.sol';

/**
 * @dev Test for AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.t.sol -vv
 */
contract AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526_Test is ProtocolV3TestBase {
  uint256 internal constant MAX_DELTA_STREAM_BALANCE = 0.00001e18; // 0.001%

  AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25177110);
    proposal = new AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526',
      AaveV3EthereumLido.POOL,
      address(proposal)
    );
  }

  function test_previousStreamCanceled() public {
    uint256 streamId = proposal.PREVIOUS_STREAM();
    AaveV3EthereumLido.COLLECTOR.getStream(streamId);

    executePayload(vm, address(proposal));

    vm.expectRevert(ICollector.StreamDoesNotExist.selector);
    AaveV3EthereumLido.COLLECTOR.getStream(streamId);
  }

  function test_ghoAllowanceIncreased() public {
    address tokenLogic = proposal.TOKEN_LOGIC();

    uint256 allowanceBefore = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3EthereumLido.COLLECTOR),
      tokenLogic
    );

    executePayload(vm, address(proposal));

    uint256 allowanceAfter = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3EthereumLido.COLLECTOR),
      tokenLogic
    );

    assertEq(allowanceAfter, allowanceBefore + proposal.GHO_ALLOWANCE());
  }

  function test_ghoAllowanceAdditiveWithUnclaimed() public {
    address tokenLogic = proposal.TOKEN_LOGIC();
    uint256 preExistingAllowance = 500_000 ether;

    vm.prank(address(AaveV3EthereumLido.COLLECTOR));
    IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).approve(tokenLogic, preExistingAllowance);

    assertEq(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
        address(AaveV3EthereumLido.COLLECTOR),
        tokenLogic
      ),
      preExistingAllowance
    );

    executePayload(vm, address(proposal));

    uint256 allowanceAfter = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3EthereumLido.COLLECTOR),
      tokenLogic
    );

    assertEq(allowanceAfter, preExistingAllowance + proposal.GHO_ALLOWANCE());
  }

  function test_ghoStreamCreated() public {
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = AaveV3EthereumLido.COLLECTOR.getNextStreamId();

    vm.expectRevert(ICollector.StreamDoesNotExist.selector);
    AaveV3EthereumLido.COLLECTOR.getStream(nextStreamId);

    executePayload(vm, address(proposal));

    (
      address sender,
      address streamReceiver,
      uint256 deposit,
      address tokenAddress,
      uint256 startTime,
      uint256 stopTime,
      ,

    ) = AaveV3EthereumLido.COLLECTOR.getStream(nextStreamId);

    assertEq(sender, address(AaveV3EthereumLido.COLLECTOR));
    assertEq(streamReceiver, receiver);
    assertEq(tokenAddress, AaveV3EthereumLidoAssets.GHO_A_TOKEN);
    assertEq(stopTime - startTime, proposal.STREAM_DURATION());
    assertApproxEqRel(deposit, proposal.GHO_STREAM_AMOUNT(), MAX_DELTA_STREAM_BALANCE);
  }

  function test_ghoStreamPartialWithdraw() public {
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = AaveV3EthereumLido.COLLECTOR.getNextStreamId();

    executePayload(vm, address(proposal));

    vm.warp(block.timestamp + 1 days);

    uint256 balanceBefore = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).balanceOf(receiver);

    vm.prank(receiver);
    AaveV3EthereumLido.COLLECTOR.withdrawFromStream(nextStreamId, 1);

    uint256 balanceAfter = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).balanceOf(receiver);
    assertEq(balanceAfter, balanceBefore + 1);
  }

  function test_ghoStreamFullRedeem() public {
    address receiver = proposal.TOKEN_LOGIC();
    uint256 nextStreamId = AaveV3EthereumLido.COLLECTOR.getNextStreamId();

    executePayload(vm, address(proposal));

    uint256 allowanceAfterPayload = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3EthereumLido.COLLECTOR),
      receiver
    );

    vm.warp(block.timestamp + proposal.STREAM_DURATION());

    uint256 streamable = AaveV3EthereumLido.COLLECTOR.balanceOf(nextStreamId, receiver);
    assertApproxEqRel(streamable, proposal.GHO_STREAM_AMOUNT(), MAX_DELTA_STREAM_BALANCE);

    uint256 balanceBefore = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).balanceOf(receiver);

    vm.prank(receiver);
    AaveV3EthereumLido.COLLECTOR.withdrawFromStream(nextStreamId, streamable);

    uint256 balanceAfter = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).balanceOf(receiver);
    assertApproxEqRel(
      balanceAfter,
      balanceBefore + proposal.GHO_STREAM_AMOUNT(),
      MAX_DELTA_STREAM_BALANCE
    );

    assertEq(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
        address(AaveV3EthereumLido.COLLECTOR),
        receiver
      ),
      allowanceAfterPayload
    );
  }
}
