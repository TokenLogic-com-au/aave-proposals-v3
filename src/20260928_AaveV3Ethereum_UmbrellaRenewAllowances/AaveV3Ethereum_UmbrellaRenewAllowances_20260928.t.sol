// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UmbrellaEthereum, UmbrellaEthereumAssets} from 'aave-address-book/UmbrellaEthereum.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IRewardsDistributor} from 'aave-umbrella/rewards/interfaces/IRewardsDistributor.sol';

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

    uint256 aUsdtBefore = IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 aUsdcBefore = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 aWethBefore = IERC20(AaveV3EthereumAssets.WETH_A_TOKEN).allowance(
      collector,
      rewardsController
    );

    executePayload(vm, address(proposal));

    uint256 aUsdtAfter = IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 aUsdcAfter = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).allowance(
      collector,
      rewardsController
    );
    uint256 aWethAfter = IERC20(AaveV3EthereumAssets.WETH_A_TOKEN).allowance(
      collector,
      rewardsController
    );

    assertNotEq(aUsdtBefore, aUsdtAfter, 'USDT allowance should be modified');
    assertNotEq(aUsdcBefore, aUsdcAfter, 'USDC allowance should be modified');
    assertNotEq(aWethBefore, aWethAfter, 'WETH allowance should be modified');
    assertEq(
      aUsdtAfter,
      proposal.USDT_ABSOLUTE_ALLOWANCE(),
      'USDT allowance should equal the absolute target, not current + target'
    );
    assertEq(
      aUsdcAfter,
      proposal.USDC_ABSOLUTE_ALLOWANCE(),
      'USDC allowance should equal the absolute target, not current + target'
    );
    assertEq(
      aWethAfter,
      proposal.WETH_ABSOLUTE_ALLOWANCE(),
      'WETH allowance should equal the absolute target, not current + target'
    );
  }

  function test_stakerCanClaimUsdtRewards() public {
    executePayload(vm, address(proposal));

    address staker = 0xB524D79cC76fdFf645c3c841a5C006b30c6693BF;

    uint256 balanceBefore = IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).balanceOf(staker);

    vm.prank(staker);
    IRewardsDistributor(UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER).claimAllRewards(
      address(UmbrellaEthereumAssets.STK_WA_USDT_V1),
      staker
    );

    uint256 balanceAfter = IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).balanceOf(staker);

    assertGt(balanceAfter, balanceBefore, 'USDT staker should receive rewards');
  }

  function test_stakerCanClaimUsdcRewards() public {
    executePayload(vm, address(proposal));

    address staker = 0x48AACE1f5547f201178FD422f93117DaA03a38c1;

    uint256 balanceBefore = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).balanceOf(staker);

    vm.prank(staker);
    IRewardsDistributor(UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER).claimAllRewards(
      address(UmbrellaEthereumAssets.STK_WA_USDC_V1),
      staker
    );

    uint256 balanceAfter = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).balanceOf(staker);

    assertGt(balanceAfter, balanceBefore, 'USDC staker should receive rewards');
  }

  function test_stakerCanClaimWethRewards() public {
    executePayload(vm, address(proposal));

    address staker = 0x60092Ec09978FacF690Bc79464699D07eC89c61f;

    uint256 balanceBefore = IERC20(AaveV3EthereumAssets.WETH_A_TOKEN).balanceOf(staker);

    vm.prank(staker);
    IRewardsDistributor(UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER).claimAllRewards(
      address(UmbrellaEthereumAssets.STK_WA_WETH_V1),
      staker
    );

    uint256 balanceAfter = IERC20(AaveV3EthereumAssets.WETH_A_TOKEN).balanceOf(staker);

    assertGt(balanceAfter, balanceBefore, 'WETH staker should receive rewards');
  }
}
