// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UmbrellaEthereum} from 'aave-address-book/UmbrellaEthereum.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_UmbrellaRenewAllowances_20260928} from './AaveV3Ethereum_UmbrellaRenewAllowances_20260928.sol';

/**
 * @dev Test for AaveV3Ethereum_UmbrellaRenewAllowances_20260928
 * command:
 *  FOUNDRY_PROFILE=test forge test \
 *    --match-path=src/20260928_AaveV3Ethereum_UmbrellaRenewAllowances/AaveV3Ethereum_UmbrellaRenewAllowances_20260928.t.sol \
 *    -vv
 */
contract AaveV3Ethereum_UmbrellaRenewAllowances_20260928_Test is ProtocolV3TestBase {
  AaveV3Ethereum_UmbrellaRenewAllowances_20260928 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 26075443);
    proposal = new AaveV3Ethereum_UmbrellaRenewAllowances_20260928();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_UmbrellaRenewAllowances_20260928',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_allowancesBeforeAfter() public {
    address collector = address(AaveV3Ethereum.COLLECTOR);
    address rewardsController = UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER;

    executePayload(vm, address(proposal));

    uint256 usdtAfter = IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 usdcAfter = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 wethAfter = IERC20(AaveV3EthereumAssets.WETH_A_TOKEN).allowance(
      collector,
      rewardsController
    );

    assertEq(
      usdtAfter,
      proposal.USDT_TARGET_ALLOWANCE(),
      'USDT allowance should equal the absolute target, not current + target'
    );
    assertEq(
      usdcAfter,
      proposal.USDC_TARGET_ALLOWANCE(),
      'USDC allowance should equal the absolute target, not current + target'
    );
    assertEq(
      wethAfter,
      proposal.WETH_TARGET_ALLOWANCE(),
      'WETH allowance should equal the absolute target, not current + target'
    );
  }
}
