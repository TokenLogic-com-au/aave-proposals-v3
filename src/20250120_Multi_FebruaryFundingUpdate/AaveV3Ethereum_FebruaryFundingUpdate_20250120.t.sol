// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_FebruaryFundingUpdate_20250120} from './AaveV3Ethereum_FebruaryFundingUpdate_20250120.sol';

/**
 * @dev Test for AaveV3Ethereum_FebruaryFundingUpdate_20250120
 * command: FOUNDRY_PROFILE=mainnet forge test --match-path=src/20250120_Multi_FebruaryFundingUpdate/AaveV3Ethereum_FebruaryFundingUpdate_20250120.t.sol -vv
 */
contract AaveV3Ethereum_FebruaryFundingUpdate_20250120_Test is ProtocolV3TestBase {
  event SwapRequested(
    address milkman,
    address indexed fromToken,
    address indexed toToken,
    address fromOracle,
    address toOracle,
    uint256 amount,
    address indexed recipient,
    uint256 slippage
  );

  AaveV3Ethereum_FebruaryFundingUpdate_20250120 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 21667725);
    proposal = new AaveV3Ethereum_FebruaryFundingUpdate_20250120();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  // function test_defaultProposalExecution() public {
  //   defaultTest(
  //     'AaveV3Ethereum_FebruaryFundingUpdate_20250120',
  //     AaveV3Ethereum.POOL,
  //     address(proposal)
  //   );
  // }

  function test_transfers() public {
    uint256 balanceMeritBefore = IERC20(proposal.FLUID()).balanceOf(proposal.MERIT_SAFE());
    uint256 balanceUSDCAciBefore = IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).balanceOf(
      proposal.ACI_SAFE()
    );
    uint256 balanceWETHAciBefore = IERC20(AaveV3EthereumAssets.WETH_UNDERLYING).balanceOf(
      proposal.ACI_SAFE()
    );
    uint256 balancePYUSDAciBefore = IERC20(AaveV3EthereumAssets.PYUSD_UNDERLYING).balanceOf(
      proposal.ACI_SAFE()
    );

    executePayload(vm, address(proposal));

    assertEq(
      IERC20(proposal.FLUID()).balanceOf(proposal.MERIT_SAFE()),
      balanceMeritBefore + proposal.FLUID_AMOUNT()
    );
    assertEq(
      IERC20(AaveV3EthereumAssets.USDC_A_TOKEN).balanceOf(proposal.ACI_SAFE()),
      balanceUSDCAciBefore + proposal.USDC_ACI_REIMBURSEMENT()
    );
    assertEq(
      IERC20(AaveV3EthereumAssets.WETH_UNDERLYING).balanceOf(proposal.ACI_SAFE()),
      balanceWETHAciBefore + proposal.ETH_ACI_REIMBURSEMENT()
    );
    assertEq(
      IERC20(AaveV3EthereumAssets.PYUSD_UNDERLYING).balanceOf(proposal.ACI_SAFE()),
      balancePYUSDAciBefore + proposal.PYUSD_ACI_REIMBURSEMENT()
    );
  }

  function test_transfersALC() public {}
}
