// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {CollectorUtils} from 'aave-helpers/src/CollectorUtils.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title May/June 2026 Funding Update
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-may-june-2026-funding-update/25000
 */
contract AaveV3Ethereum_MayJune2026FundingUpdate_20260601 is IProposalGenericExecutor {
  address public constant MERIT_AHAB = 0xAA2461f0f0A3dE5fEAF3273eAe16DEF861cf594e;
  uint256 public constant MERIT_AHAB_A_GHO_ALLOWANCE = 5_000_000 ether; // 5M aGHO, 18 decimals

  address public constant TOKENLOGIC = 0xAA088dfF3dcF619664094945028d44E779F19894;
  uint256 public constant TOKENLOGIC_A_GHO_PAYMENT_AMOUNT = 11_655 ether; // 11,655 aGHO, 18 decimals

  address public constant AAVE_LABS = 0x1c037b3C22240048807cC9d7111be5d455F640bd;
  uint256 public constant AAVE_LABS_A_GHO_PAYMENT_AMOUNT = 392_746.66 ether; // 392,746.66 aGHO, 18 decimals

  address public constant SECURITY_RESEARCHER = 0xcC7383b24631d8BfC8571dbF9c81d6D094688628;
  uint256 public constant SECURITY_RESEARCHER_USDC_PAYMENT_AMOUNT = 7_500e6; // 7,500 USDC, 6 decimals

  address public constant IMMUNEFI = 0x7119f398b6C06095c6E8964C1f58e7C1BAa79E18;
  uint256 public constant IMMUNEFI_USDC_PAYMENT_AMOUNT = 750e6; // 750 USDC, 6 decimals

  uint256 public constant SWAP_STEWARD_WETH_ALLOWANCE = 5_000 ether;

  uint256 public constant SWAP_STEWARD_USDT_ALLOWANCE = 10_000_000e6; // 10M USDT, 6 decimals
  uint256 public constant SWAP_STEWARD_USDC_ALLOWANCE = 10_000_000e6; // 10M USDC6 decimals
  uint256 public constant SWAP_STEWARD_USDe_ALLOWANCE = 10_000_000 ether; // 10M USDe,18 decimals
  uint256 public constant SWAP_STEWARD_USDS_ALLOWANCE = 10_000_000 ether; // 10M USDS, 18 decimals
  uint256 public constant SWAP_STEWARD_DAI_ALLOWANCE = 5_000_000 ether; // 5M DAI, 18 decimals

  function execute() external {
    _depositETH();
    _approvals();
    _payments();
  }

  function _depositETH() internal {
    uint256 collectorEthBalance = address(AaveV3Ethereum.COLLECTOR).balance;
    // Wrap ETH by sending it to WETH.
    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3Ethereum.COLLECTOR.ETH_MOCK_ADDRESS()),
      AaveV3EthereumAssets.WETH_UNDERLYING,
      collectorEthBalance
    );
    CollectorUtils.depositToV3(
      AaveV3Ethereum.COLLECTOR,
      CollectorUtils.IOInput({
        pool: address(AaveV3Ethereum.POOL),
        underlying: AaveV3EthereumAssets.WETH_UNDERLYING,
        amount: collectorEthBalance
      })
    );
  }

  function _approvals() internal {
    // Merit aEthLidoGHO Approval
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      MERIT_AHAB,
      MERIT_AHAB_A_GHO_ALLOWANCE
    );

    // Replenish Mainnet Swap Steward allowances
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.WETH_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_WETH_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.USDT_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_USDT_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.USDC_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_USDC_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.USDe_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_USDe_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.USDS_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_USDS_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.DAI_UNDERLYING),
      AaveV3Ethereum.COLLECTOR_SWAP_STEWARD,
      SWAP_STEWARD_DAI_ALLOWANCE
    );
  }

  function _payments() internal {
    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      TOKENLOGIC,
      TOKENLOGIC_A_GHO_PAYMENT_AMOUNT
    );

    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      AAVE_LABS,
      AAVE_LABS_A_GHO_PAYMENT_AMOUNT
    );

    // The USDC payments are made in underlying USDC, but the collector holds aUSDC.
    // Withdraw the required amount from the V3 pool back to the collector first.
    CollectorUtils.withdrawFromV3(
      AaveV3Ethereum.COLLECTOR,
      CollectorUtils.IOInput({
        pool: address(AaveV3Ethereum.POOL),
        underlying: AaveV3EthereumAssets.USDC_UNDERLYING,
        amount: SECURITY_RESEARCHER_USDC_PAYMENT_AMOUNT + IMMUNEFI_USDC_PAYMENT_AMOUNT
      }),
      address(AaveV3Ethereum.COLLECTOR)
    );

    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3EthereumAssets.USDC_UNDERLYING),
      SECURITY_RESEARCHER,
      SECURITY_RESEARCHER_USDC_PAYMENT_AMOUNT
    );

    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3EthereumAssets.USDC_UNDERLYING),
      IMMUNEFI,
      IMMUNEFI_USDC_PAYMENT_AMOUNT
    );
  }
}
