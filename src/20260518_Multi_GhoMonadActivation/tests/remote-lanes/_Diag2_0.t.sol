// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {IERC20} from 'forge-std/interfaces/IERC20.sol';
import {IClient} from 'src/interfaces/ccip/IClient.sol';
import {IRouter} from 'src/interfaces/ccip/IRouter.sol';
import {IOnRamp_1_6} from 'src/interfaces/ccip/IEVM2EVMOnRamp.sol';
import {CCIPUtils} from 'src/helpers/gho-launch/tests/utils/CCIPUtils.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

contract Diag2_0 is Test {
  // Ethereum mainnet
  address constant ROUTER = 0x80226fc0Ee2b096224EeAc085Bb9a8cba1146f7D;
  address constant GHO = 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f;
  address constant LINK = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
  uint64 constant MANTLE_SEL = 1556008542357238666;
  address constant MANTLE_GHO = 0xfc421aD3C883Bf9E7C4f42dE845C4e4405799e73;
  uint256 constant ETH_BLOCK = 25343705;

  function test_diag() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), ETH_BLOCK);

    address onRamp = IRouter(ROUTER).getOnRamp(MANTLE_SEL);
    emit log_named_string('onRamp typeAndVersion', IOnRamp_1_6(onRamp).typeAndVersion());

    // raw getDynamicConfig
    (bool ok, bytes memory data) = onRamp.staticcall(abi.encodeWithSignature('getDynamicConfig()'));
    emit log_named_uint('getDynamicConfig ok', ok ? 1 : 0);
    emit log_named_uint('getDynamicConfig words', data.length / 32);
    emit log_named_bytes('getDynamicConfig raw', data);

    address alice = makeAddr('alice');
    uint256 amount = 1e18;

    IClient.EVM2AnyMessage memory message = CCIPUtils.generateMessage_1_6(alice, 1, LINK);
    message.tokenAmounts[0] = IClient.EVMTokenAmount({token: GHO, amount: amount});

    uint256 fee = IRouter(ROUTER).getFee(MANTLE_SEL, message);
    deal(LINK, alice, fee);
    deal(GHO, alice, amount);
    vm.startPrank(alice);
    IERC20(LINK).approve(ROUTER, fee);
    IERC20(GHO).approve(ROUTER, amount);

    vm.recordLogs();
    IRouter(ROUTER).ccipSend(MANTLE_SEL, message);
    vm.stopPrank();

    Vm.Log[] memory logs = vm.getRecordedLogs();
    for (uint256 i = 0; i < logs.length; i++) {
      emit log_named_uint('--- log index', i);
      emit log_named_address('emitter', logs[i].emitter);
      for (uint256 t = 0; t < logs[i].topics.length; t++) {
        emit log_named_bytes32('topic', logs[i].topics[t]);
      }
      emit log_named_uint('data words', logs[i].data.length / 32);
      emit log_named_bytes('data', logs[i].data);
    }
  }
}
