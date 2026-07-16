// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IWrappedTokenGatewayV3} from 'aave-v3-origin/contracts/helpers/interfaces/IWrappedTokenGatewayV3.sol';
import {IAToken} from 'aave-v3-origin/contracts/interfaces/IAToken.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IMainnetSwapSteward} from 'src/interfaces/IMainnetSwapSteward.sol';

/**
 * @title July 2026 Funding Update
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-july-2026-funding-update/25277
 */
contract AaveV3Ethereum_July2026FundingUpdate_20260715 is IProposalGenericExecutor {
  uint256 public constant GHO_MONAD_ALLOWANCE = 500_000 ether;
  uint256 public constant WBTC_MONAD_ALLOWANCE = 72e8;

  address public constant TOKEN_LOGIC = 0xAA088dfF3dcF619664094945028d44E779F19894;
  uint256 public constant REIMBURSEMENTS_GHO_AMOUNT = 50_000 ether;

  address public constant RESCUE_USDC_OWNER = 0x32FcF748e4dCEBD1081BfcccB94eB721101F27C0;
  uint256 public constant RESCUE_USDC_AMOUNT = 25_000e6;

  uint256 public constant WETH_SWAP_BUDGET_AMOUNT = 5_000 ether;
  uint256 public constant USDT_SWAP_BUDGET_AMOUNT = 10_000_000e6;
  uint256 public constant USDC_SWAP_BUDGET_AMOUNT = 10_000_000e6;
  uint256 public constant USDe_SWAP_BUDGET_AMOUNT = 1_000_000 ether;
  uint256 public constant USDS_SWAP_BUDGET_AMOUNT = 1_000_000 ether;
  uint256 public constant DAI_SWAP_BUDGET_AMOUNT = 1_000_000 ether;
  uint256 public constant RLUSD_SWAP_BUDGET_AMOUNT = 1_000_000 ether;
  uint256 public constant PYUSD_SWAP_BUDGET_AMOUNT = 500_000e6;

  function execute() external {
    _monad();
    _depositEth();
    _reimbursements();
    _replenishAllowances();
    _swapPaths();
    _cancelAllowances();
    _rescueTokens();
  }

  function _cancelAllowances() internal {
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.USDC_A_TOKEN),
      MiscEthereum.MERIT_AHAB_SAFE,
      0
    );
  }

  function _monad() internal {
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      MiscEthereum.ALC_SAFE,
      GHO_MONAD_ALLOWANCE
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.WBTC_A_TOKEN),
      MiscEthereum.AHAB_SAFE,
      WBTC_MONAD_ALLOWANCE
    );
  }

  function _depositEth() internal {
    uint256 collectorEthBalance = address(AaveV3Ethereum.COLLECTOR).balance;
    AaveV3Ethereum.COLLECTOR.transfer(
      IERC20(AaveV3Ethereum.COLLECTOR.ETH_MOCK_ADDRESS()),
      address(this),
      collectorEthBalance
    );
    IWrappedTokenGatewayV3(AaveV3Ethereum.WETH_GATEWAY).depositETH{value: collectorEthBalance}(
      address(AaveV3Ethereum.POOL),
      address(AaveV3Ethereum.COLLECTOR),
      0
    );
  }

  function _reimbursements() internal {
    uint256 currentAllowance = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3Ethereum.COLLECTOR),
      TOKEN_LOGIC
    );
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      TOKEN_LOGIC,
      currentAllowance + REIMBURSEMENTS_GHO_AMOUNT
    );
  }

  function _replenishAllowances() internal {
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.WETH_UNDERLYING,
      WETH_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDT_UNDERLYING,
      USDT_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDC_UNDERLYING,
      USDC_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDe_UNDERLYING,
      USDe_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.USDS_UNDERLYING,
      USDS_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.DAI_UNDERLYING,
      DAI_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.RLUSD_UNDERLYING,
      RLUSD_SWAP_BUDGET_AMOUNT
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).increaseTokenBudget(
      AaveV3EthereumAssets.PYUSD_UNDERLYING,
      PYUSD_SWAP_BUDGET_AMOUNT
    );
  }

  function _swapPaths() internal {
    // rlUSD Swap Paths
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.RLUSD_UNDERLYING,
      AaveV3EthereumAssets.GHO_UNDERLYING,
      true
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.RLUSD_UNDERLYING,
      AaveV3EthereumAssets.AAVE_UNDERLYING,
      true
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.RLUSD_UNDERLYING,
      AaveV3EthereumAssets.WETH_UNDERLYING,
      true
    );

    // pyUSD Swap Paths
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.PYUSD_UNDERLYING,
      AaveV3EthereumAssets.GHO_UNDERLYING,
      true
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.PYUSD_UNDERLYING,
      AaveV3EthereumAssets.AAVE_UNDERLYING,
      true
    );
    IMainnetSwapSteward(AaveV3Ethereum.COLLECTOR_SWAP_STEWARD).setSwappablePair(
      AaveV3EthereumAssets.PYUSD_UNDERLYING,
      AaveV3EthereumAssets.WETH_UNDERLYING,
      true
    );
  }

  function _rescueTokens() internal {
    //   IAToken(AaveV3EthereumAssets.USDC_A_TOKEN).rescueTokens(
    //     AaveV3EthereumAssets.USDC_UNDERLYING,
    //     RESCUE_USDC_OWNER,
    //     RESCUE_USDC_AMOUNT
    //   );
  }
}
