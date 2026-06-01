// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Plasma_MayJune2026FundingUpdate_20260601} from './AaveV3Plasma_MayJune2026FundingUpdate_20260601.sol';

/**
 * @dev Test for AaveV3Plasma_MayJune2026FundingUpdate_20260601
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260601_Multi_MayJune2026FundingUpdate/AaveV3Plasma_MayJune2026FundingUpdate_20260601.t.sol -vv
 */
contract AaveV3Plasma_MayJune2026FundingUpdate_20260601_Test is ProtocolV3TestBase {
  AaveV3Plasma_MayJune2026FundingUpdate_20260601 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('plasma'), 23376630);
    proposal = new AaveV3Plasma_MayJune2026FundingUpdate_20260601();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Plasma_MayJune2026FundingUpdate_20260601',
      AaveV3Plasma.POOL,
      address(proposal)
    );
  }

  /**
   * @dev The AFC has no aUSDT0 allowance before the proposal and exactly the configured
   *      allowance from the collector afterwards.
   */
  function test_afcAUsdt0Allowance() public {
    address collector = address(AaveV3Plasma.COLLECTOR);
    address afc = proposal.AFC();
    address token = AaveV3PlasmaAssets.USDT0_A_TOKEN;
    uint256 amount = proposal.AFC_A_USDT0_ALLOWANCE();

    assertEq(IERC20(token).allowance(collector, afc), 0, 'unexpected allowance before');

    executePayload(vm, address(proposal));

    assertEq(IERC20(token).allowance(collector, afc), amount, 'allowance not set');
  }
}
