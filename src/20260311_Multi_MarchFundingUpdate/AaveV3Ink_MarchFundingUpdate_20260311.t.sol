// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3InkWhitelabel, AaveV3InkWhitelabelAssets} from 'aave-address-book/AaveV3InkWhitelabel.sol';
import {MiscInkWhitelabel} from 'aave-address-book/MiscInkWhitelabel.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ink_MarchFundingUpdate_20260311} from './AaveV3Ink_MarchFundingUpdate_20260311.sol';

/**
 * @dev Test for AaveV3Ink_MarchFundingUpdate_20260311
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260311_Multi_MarchFundingUpdate/AaveV3Ink_MarchFundingUpdate_20260311.t.sol -vv
 */
contract AaveV3Ink_MarchFundingUpdate_20260311_Test is ProtocolV3TestBase {
  AaveV3Ink_MarchFundingUpdate_20260311 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ink'), 39760729);
    proposal = new AaveV3Ink_MarchFundingUpdate_20260311();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ink_MarchFundingUpdate_20260311',
      AaveV3InkWhitelabel.POOL,
      address(proposal)
    );
  }

  function test_approvals() public {
    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.GHO_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      0
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.WETH_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      0
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDT_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      0
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDG_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      0
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDC_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      0
    );

    executePayload(vm, address(proposal));

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.GHO_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      proposal.GHO_ALLOWANCE()
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.WETH_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      proposal.WETH_ALLOWANCE()
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDT_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      proposal.USDT_ALLOWANCE()
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDG_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      proposal.USDG_ALLOWANCE()
    );

    assertEq(
      IERC20(AaveV3InkWhitelabelAssets.USDC_A_TOKEN).allowance(
        address(AaveV3InkWhitelabel.COLLECTOR),
        proposal.AFC_SAFE()
      ),
      proposal.USDC_ALLOWANCE()
    );

    vm.startPrank(proposal.AFC_SAFE());
    IERC20(AaveV3InkWhitelabelAssets.GHO_A_TOKEN).transferFrom(
      address(AaveV3InkWhitelabel.COLLECTOR),
      proposal.AFC_SAFE(),
      proposal.GHO_ALLOWANCE()
    );

    IERC20(AaveV3InkWhitelabelAssets.WETH_A_TOKEN).transferFrom(
      address(AaveV3InkWhitelabel.COLLECTOR),
      proposal.AFC_SAFE(),
      proposal.WETH_ALLOWANCE()
    );

    IERC20(AaveV3InkWhitelabelAssets.USDT_A_TOKEN).transferFrom(
      address(AaveV3InkWhitelabel.COLLECTOR),
      proposal.AFC_SAFE(),
      proposal.USDT_ALLOWANCE()
    );

    IERC20(AaveV3InkWhitelabelAssets.USDG_A_TOKEN).transferFrom(
      address(AaveV3InkWhitelabel.COLLECTOR),
      proposal.AFC_SAFE(),
      proposal.USDG_ALLOWANCE()
    );

    IERC20(AaveV3InkWhitelabelAssets.USDC_A_TOKEN).transferFrom(
      address(AaveV3InkWhitelabel.COLLECTOR),
      proposal.AFC_SAFE(),
      proposal.USDC_ALLOWANCE()
    );
    vm.stopPrank();
  }
}
