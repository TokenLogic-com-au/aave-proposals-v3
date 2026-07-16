// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {MiscPlasma} from 'aave-address-book/MiscPlasma.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title July 2026 Funding Update
 * @author TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-july-2026-funding-update/25277
 */
contract AaveV3Plasma_July2026FundingUpdate_20260715 is IProposalGenericExecutor {
  uint256 public constant USDT_ALLOWANCE = 3_000_000e6;
  address public constant AHAB_SAFE = 0xAA2461f0f0A3dE5fEAF3273eAe16DEF861cf594e;

  function execute() external {
    _smallAllowances();
    _refreshUsdtAllowance();
  }

  function _smallAllowances() internal {
    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_9APR2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_9APR2026_A_TOKEN).balanceOf(
        address(AaveV3Plasma.COLLECTOR)
      )
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_USDe_15JAN2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_USDe_15JAN2026_A_TOKEN).balanceOf(
        address(AaveV3Plasma.COLLECTOR)
      )
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_18JUN2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_18JUN2026_A_TOKEN).balanceOf(
        address(AaveV3Plasma.COLLECTOR)
      )
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_15JAN2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_sUSDE_15JAN2026_A_TOKEN).balanceOf(
        address(AaveV3Plasma.COLLECTOR)
      )
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_USDe_9APR2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_USDe_9APR2026_A_TOKEN).balanceOf(address(AaveV3Plasma.COLLECTOR))
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.PT_USDe_18JUN2026_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.PT_USDe_18JUN2026_A_TOKEN).balanceOf(
        address(AaveV3Plasma.COLLECTOR)
      )
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.WETH_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.WETH_A_TOKEN).balanceOf(address(AaveV3Plasma.COLLECTOR))
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.weETH_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.weETH_A_TOKEN).balanceOf(address(AaveV3Plasma.COLLECTOR))
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.sUSDe_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      IERC20(AaveV3PlasmaAssets.sUSDe_A_TOKEN).balanceOf(address(AaveV3Plasma.COLLECTOR))
    );
  }

  function _refreshUsdtAllowance() internal {
    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.USDT0_A_TOKEN),
      MiscPlasma.AFC_SAFE,
      0
    );

    AaveV3Plasma.COLLECTOR.approve(
      IERC20(AaveV3PlasmaAssets.USDT0_A_TOKEN),
      AHAB_SAFE,
      USDT_ALLOWANCE
    );
  }
}
