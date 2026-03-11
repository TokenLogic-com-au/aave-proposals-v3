// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';
import {IAaveArbEthERC20Bridge} from 'aave-helpers/src/bridges/arbitrum/IAaveArbEthERC20Bridge.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title March Funding Update
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-march-2026-funding-update/24225
 */
contract AaveV3Arbitrum_MarchFundingUpdate_20260311 is IProposalGenericExecutor {
  uint256 public constant USDC_ALLOWANCE = 3_300_000e6;
  uint256 public constant USDT_ALLOWANCE = 1_300_000e6;

  /// https://arbiscan.io/address/0x467194771dAe2967Aef3ECbEDD3Bf9a310C76C65
  address public constant DAI_GATEWAY = 0x467194771dAe2967Aef3ECbEDD3Bf9a310C76C65;

  /// https://arbiscan.io/address/0x096760F208390250649E3e8763348E783AEF5562
  address public constant USDC_GATEWAY = 0x096760F208390250649E3e8763348E783AEF5562;

  function execute() external {
    _approvals();
    _bridges();
  }

  function _approvals() internal {
    AaveV3Arbitrum.COLLECTOR.approve(
      IERC20(AaveV3ArbitrumAssets.USDCn_UNDERLYING),
      MiscArbitrum.AFC_SAFE,
      USDC_ALLOWANCE
    );
    AaveV3Arbitrum.COLLECTOR.approve(
      IERC20(AaveV3ArbitrumAssets.USDT_UNDERLYING),
      MiscArbitrum.AFC_SAFE,
      USDT_ALLOWANCE
    );
  }

  function _bridges() internal {
    // DAI
    uint256 daiBalance = IERC20(AaveV3ArbitrumAssets.DAI_UNDERLYING).balanceOf(
      address(AaveV3Arbitrum.COLLECTOR)
    );
    AaveV3Arbitrum.COLLECTOR.transfer(
      IERC20(AaveV3ArbitrumAssets.DAI_UNDERLYING),
      MiscArbitrum.AAVE_ARB_ETH_BRIDGE,
      daiBalance
    );
    IAaveArbEthERC20Bridge(MiscArbitrum.AAVE_ARB_ETH_BRIDGE).bridge(
      AaveV3ArbitrumAssets.DAI_UNDERLYING,
      AaveV3EthereumAssets.DAI_UNDERLYING,
      DAI_GATEWAY,
      daiBalance
    );

    // LINK
    uint256 linkBalance = IERC20(AaveV3ArbitrumAssets.LINK_UNDERLYING).balanceOf(
      address(AaveV3Arbitrum.COLLECTOR)
    );
    AaveV3Arbitrum.COLLECTOR.transfer(
      IERC20(AaveV3ArbitrumAssets.LINK_UNDERLYING),
      MiscArbitrum.AAVE_ARB_ETH_BRIDGE,
      linkBalance
    );
    IAaveArbEthERC20Bridge(MiscArbitrum.AAVE_ARB_ETH_BRIDGE).bridge(
      AaveV3ArbitrumAssets.LINK_UNDERLYING,
      AaveV3EthereumAssets.LINK_UNDERLYING,
      USDC_GATEWAY, // TODO: Correct Gateway
      linkBalance
    );

    // wstETH
    uint256 wstethBalance = IERC20(AaveV3ArbitrumAssets.wstETH_UNDERLYING).balanceOf(
      address(AaveV3Arbitrum.COLLECTOR)
    );
    AaveV3Arbitrum.COLLECTOR.transfer(
      IERC20(AaveV3ArbitrumAssets.wstETH_UNDERLYING),
      MiscArbitrum.AAVE_ARB_ETH_BRIDGE,
      wstethBalance
    );
    IAaveArbEthERC20Bridge(MiscArbitrum.AAVE_ARB_ETH_BRIDGE).bridge(
      AaveV3ArbitrumAssets.wstETH_UNDERLYING,
      AaveV3EthereumAssets.wstETH_UNDERLYING,
      USDC_GATEWAY, // TODO: Correct Gateway
      wstethBalance
    );

    // USDC
    uint256 usdcBalance = IERC20(AaveV3ArbitrumAssets.USDC_UNDERLYING).balanceOf(
      address(AaveV3Arbitrum.COLLECTOR)
    );
    AaveV3Arbitrum.COLLECTOR.transfer(
      IERC20(AaveV3ArbitrumAssets.USDC_UNDERLYING),
      MiscArbitrum.AAVE_ARB_ETH_BRIDGE,
      usdcBalance
    );
    IAaveArbEthERC20Bridge(MiscArbitrum.AAVE_ARB_ETH_BRIDGE).bridge(
      AaveV3ArbitrumAssets.USDC_UNDERLYING,
      AaveV3EthereumAssets.USDC_UNDERLYING,
      USDC_GATEWAY,
      usdcBalance
    );
  }
}
