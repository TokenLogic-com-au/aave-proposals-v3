// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveSafetyModule} from 'aave-address-book/AaveSafetyModule.sol';
import {IStakeToken} from 'aave-address-book/common/IStakeToken.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224} from './AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224.sol';

/**
 * @dev Test for AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260224_AaveV3Ethereum_ReduceSafetyModuleEmissions/AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224.t.sol -vv
 */
contract AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224_Test is ProtocolV3TestBase {
  AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 24528301);
    proposal = new AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_stkABPT_emissionsZero() public {
    (uint128 emissionBefore, , ) = IStakeToken(AaveSafetyModule.STK_ABPT).assets(
      AaveSafetyModule.STK_ABPT
    );
    assertEq(emissionBefore, 0, 'stkABPT emission already 0 before');

    executePayload(vm, address(proposal));

    (uint128 emissionAfter, , ) = IStakeToken(AaveSafetyModule.STK_ABPT).assets(
      AaveSafetyModule.STK_ABPT
    );
    assertEq(emissionAfter, 0, 'stkABPT emission should be 0 after');
  }

  function test_stkABPT_cooldownZero() public {
    uint256 cooldownBefore = IStakeToken(AaveSafetyModule.STK_ABPT).getCooldownSeconds();
    assertEq(cooldownBefore, 20 days, 'stkABPT cooldown should be 20 days before');

    executePayload(vm, address(proposal));

    uint256 cooldownAfter = IStakeToken(AaveSafetyModule.STK_ABPT).getCooldownSeconds();
    assertEq(cooldownAfter, 0, 'stkABPT cooldown should be 0 after');
  }

  function test_stkABPT_slashingDisabled() public {
    uint256 slashBefore = IStakeToken(AaveSafetyModule.STK_ABPT).getMaxSlashablePercentage();
    assertEq(slashBefore, 0, 'stkABPT slashing already 0 before');

    executePayload(vm, address(proposal));

    uint256 slashAfter = IStakeToken(AaveSafetyModule.STK_ABPT).getMaxSlashablePercentage();
    assertEq(slashAfter, 0, 'stkABPT slashing should be 0 after');
  }

  function test_stkAAVE_emissionsReduced() public {
    (uint128 emissionBefore, , ) = IStakeToken(AaveSafetyModule.STK_AAVE).assets(
      AaveSafetyModule.STK_AAVE
    );
    assertGt(
      emissionBefore,
      proposal.STK_AAVE_EMISSION_PER_SECOND(),
      'stkAAVE emission should be higher before'
    );

    executePayload(vm, address(proposal));

    (uint128 emissionAfter, , ) = IStakeToken(AaveSafetyModule.STK_AAVE).assets(
      AaveSafetyModule.STK_AAVE
    );
    assertEq(
      emissionAfter,
      proposal.STK_AAVE_EMISSION_PER_SECOND(),
      'stkAAVE emission mismatch after'
    );
  }

  function test_stkAAVE_cooldownReduced() public {
    uint256 cooldownBefore = IStakeToken(AaveSafetyModule.STK_AAVE).getCooldownSeconds();
    assertGt(
      cooldownBefore,
      proposal.STK_AAVE_COOLDOWN_SECONDS(),
      'stkAAVE cooldown should be higher before'
    );

    executePayload(vm, address(proposal));

    uint256 cooldownAfter = IStakeToken(AaveSafetyModule.STK_AAVE).getCooldownSeconds();
    assertEq(
      cooldownAfter,
      proposal.STK_AAVE_COOLDOWN_SECONDS(),
      'stkAAVE cooldown should be 2 days after'
    );
  }

  function test_stkAAVE_rewardsAccrue() public {
    address staker = makeAddr('staker');
    deal(AaveV3EthereumAssets.AAVE_UNDERLYING, staker, 1 ether);

    executePayload(vm, address(proposal));

    vm.startPrank(staker);
    IERC20(AaveV3EthereumAssets.AAVE_UNDERLYING).approve(AaveSafetyModule.STK_AAVE, 1 ether);
    IStakeToken(AaveSafetyModule.STK_AAVE).stake(staker, 1 ether);
    vm.stopPrank();

    vm.warp(block.timestamp + 1 days);

    uint256 rewardsBalance = IStakeToken(AaveSafetyModule.STK_AAVE).getTotalRewardsBalance(staker);

    assertTrue(rewardsBalance > 0 && rewardsBalance <= 220e18, 'stkAAVE rewards out of range');
  }
}
