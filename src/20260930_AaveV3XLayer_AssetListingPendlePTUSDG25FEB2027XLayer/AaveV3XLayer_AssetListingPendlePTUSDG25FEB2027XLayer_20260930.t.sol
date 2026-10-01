// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3XLayer, AaveV3XLayerAssets, AaveV3XLayerEModes} from 'aave-address-book/AaveV3XLayer.sol';
import {GovernanceV3XLayer} from 'aave-address-book/GovernanceV3XLayer.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930} from './AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930.sol';
import {IPendlePriceCapAdapter} from '../interfaces/IPendlePriceCapAdapter.sol';

/**
 * @dev Test for AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260930_AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer/AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930.t.sol -vv
 */
contract AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930_Test is ProtocolV3TestBase {
  AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('xlayer'), 72026700);
    proposal = new AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930();
    // I will change this when I do the prefunding
    deal(
      proposal.PT_USDG_25FEB2027(),
      GovernanceV3XLayer.EXECUTOR_LVL_1,
      proposal.PT_USDG_25FEB2027_SEED_AMOUNT()
    );
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930',
      AaveV3XLayer.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3XLayer.POOL, address(proposal), updatedAssets);
  }

  function test_dustBinHasPT_USDG_25FEB2027Funds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3XLayer.POOL.getReserveAToken(proposal.PT_USDG_25FEB2027());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3XLayer.DUST_BIN)),
      proposal.PT_USDG_25FEB2027_SEED_AMOUNT(),
      'DustBin should hold at least the seed amount'
    );
  }

  function test_priceFeedReturnsSanePrice() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    assertEq(
      AaveV3XLayer.ORACLE.getSourceOfAsset(proposal.PT_USDG_25FEB2027()),
      proposal.PT_USDG_25FEB2027_PRICE_FEED(),
      'PT-USDG should be priced by the configured linear discount oracle'
    );
    uint256 price = AaveV3XLayer.ORACLE.getAssetPrice(proposal.PT_USDG_25FEB2027());
    assertGt(price, 0.9e8, 'PT-USDG price should be within a sane discount band');
    assertLt(price, 1e8, 'PT-USDG should price below par (1 USD) before maturity');

    IPendlePriceCapAdapter adapter = IPendlePriceCapAdapter(
      proposal.PT_USDG_25FEB2027_PRICE_FEED()
    );
    assertEq(
      adapter.discountRatePerYear(),
      0.03106e18,
      'initial discount rate should be 3.106% per LlamaRisk'
    );
    assertEq(
      adapter.MAX_DISCOUNT_RATE_PER_YEAR(),
      0.1108e18,
      'max discount rate should be 11.080% per LlamaRisk'
    );
    assertEq(adapter.MATURITY(), 1803513600, 'maturity should be 25 February 2027 UTC');
    assertEq(
      adapter.PENDLE_PRINCIPAL_TOKEN(),
      proposal.PT_USDG_25FEB2027(),
      'oracle should price the listed PT'
    );
    assertEq(
      adapter.ASSET_TO_USD_AGGREGATOR(),
      AaveV3XLayerAssets.USDG_ORACLE,
      'underlying aggregator should be the Capped USDG/USD feed'
    );
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0x5eA1F184af5Ced57725213D8267B5c4C834557D4,
        assetSymbol: 'PT-USDG-25FEB2027',
        priceFeed: 0x6052839E52ab454F164ee5668e5B523cF5A389Fc,
        enabledToBorrow: EngineFlags.DISABLED,
        flashloanable: EngineFlags.ENABLED,
        ltv: 0,
        liqThreshold: 0,
        liqBonus: 0,
        reserveFactor: 20_00,
        supplyCap: 35_000_000,
        borrowCap: 1,
        liqProtocolFee: 10_00,
        rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
          optimalUsageRatio: 45_00,
          baseVariableBorrowRate: 0,
          variableRateSlope1: 10_00,
          variableRateSlope2: 300_00
        })
      }),
      decimals: 6
    });
  }

  function test_eModeConfiguration() public {
    uint8 eMode_PTUSDGStablecoins = AaveV3XLayerEModes.PT_USDG_29OCT2026__USDT_USDG_GHO_USDC;
    uint8 eMode_PTUSDGUSDG = AaveV3XLayerEModes.PT_USDG_29OCT2026__USDG;

    address[] memory collateralsBefore = new address[](1);
    collateralsBefore[0] = AaveV3XLayerAssets.PT_USDG_29OCT2026_UNDERLYING;
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(eMode_PTUSDGStablecoins),
      _toBitmap(collateralsBefore),
      'eMode collateral bitmap should contain exactly PT-USDG-29OCT2026 before execution'
    );

    GovV3Helpers.executePayload(vm, address(proposal));

    _assertEModeCollateralConfig({
      id: eMode_PTUSDGStablecoins,
      ltv: 92_66,
      liquidationThreshold: 94_66,
      liquidationBonus: 100_00 + 2_34,
      isolated: true
    });

    address[] memory collaterals_PTUSDGStablecoins = new address[](2);
    collaterals_PTUSDGStablecoins[0] = AaveV3XLayerAssets.PT_USDG_29OCT2026_UNDERLYING;
    collaterals_PTUSDGStablecoins[1] = proposal.PT_USDG_25FEB2027();
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(eMode_PTUSDGStablecoins),
      _toBitmap(collaterals_PTUSDGStablecoins),
      'eMode collateral bitmap should contain exactly both PT-USDG maturities'
    );

    address[] memory borrowables_PTUSDGStablecoins = new address[](4);
    borrowables_PTUSDGStablecoins[0] = AaveV3XLayerAssets.USDT_UNDERLYING;
    borrowables_PTUSDGStablecoins[1] = AaveV3XLayerAssets.USDG_UNDERLYING;
    borrowables_PTUSDGStablecoins[2] = AaveV3XLayerAssets.GHO_UNDERLYING;
    borrowables_PTUSDGStablecoins[3] = AaveV3XLayerAssets.USDC_UNDERLYING;
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryBorrowableBitmap(eMode_PTUSDGStablecoins),
      _toBitmap(borrowables_PTUSDGStablecoins),
      'eMode borrowable bitmap should contain exactly USDT0, USDG, GHO and USDC'
    );

    _assertEModeCollateralConfig({
      id: eMode_PTUSDGUSDG,
      ltv: 93_59,
      liquidationThreshold: 95_59,
      liquidationBonus: 100_00 + 1_34,
      isolated: true
    });

    address[] memory collaterals_PTUSDGUSDG = new address[](1);
    collaterals_PTUSDGUSDG[0] = AaveV3XLayerAssets.PT_USDG_29OCT2026_UNDERLYING;
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(eMode_PTUSDGUSDG),
      _toBitmap(collaterals_PTUSDGUSDG),
      'PT-USDG/USDG eMode collateral bitmap should still contain exactly PT-USDG-29OCT2026'
    );

    address[] memory borrowables_PTUSDGUSDG = new address[](1);
    borrowables_PTUSDGUSDG[0] = AaveV3XLayerAssets.USDG_UNDERLYING;
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryBorrowableBitmap(eMode_PTUSDGUSDG),
      _toBitmap(borrowables_PTUSDGUSDG),
      'PT-USDG/USDG eMode borrowable bitmap should still contain exactly USDG'
    );
  }

  function test_eMode_PTUSDGStablecoins_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      AaveV3XLayerEModes.PT_USDG_29OCT2026__USDT_USDG_GHO_USDC,
      proposal.PT_USDG_25FEB2027(),
      AaveV3XLayerAssets.USDT_UNDERLYING
    );
  }

  function test_PT_USDG_25FEB2027BorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.PT_USDG_25FEB2027()).decimals();
    deal(proposal.PT_USDG_25FEB2027(), user, supplyAmount);

    vm.startPrank(user);

    IERC20(proposal.PT_USDG_25FEB2027()).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(proposal.PT_USDG_25FEB2027(), supplyAmount, user, 0);

    // LTV is 0 outside the e-mode, so the borrow must revert
    vm.expectRevert(Errors.LtvValidationFailed.selector);
    AaveV3XLayer.POOL.borrow(AaveV3XLayerAssets.USDT_UNDERLYING, 1, 2, 0, user);

    vm.stopPrank();
  }

  function _assertEModeCollateralConfig(
    uint8 id,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus,
    bool isolated
  ) internal view {
    DataTypes.CollateralConfig memory cfg = AaveV3XLayer.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(cfg.ltv, ltv, 'unexpected eMode ltv');
    assertEq(
      cfg.liquidationThreshold,
      liquidationThreshold,
      'unexpected eMode liquidation threshold'
    );
    assertEq(cfg.liquidationBonus, liquidationBonus, 'unexpected eMode liquidation bonus');
    assertEq(
      AaveV3XLayer.POOL.getIsEModeCategoryIsolated(id),
      isolated,
      'unexpected eMode isolation flag'
    );
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3XLayer.POOL.getReserveData(assets[i]).id;
    }
  }

  function _supplyAndBorrowInEMode(
    uint8 eModeId,
    address collateral,
    address borrowAsset
  ) internal {
    address user = makeAddr('eModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(collateral).decimals();
    deal(collateral, user, supplyAmount);

    vm.startPrank(user);

    AaveV3XLayer.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3XLayer.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3XLayer.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1, 'borrowed amount mismatch');

    IERC20(borrowAsset).approve(address(AaveV3XLayer.POOL), borrowAmount);
    AaveV3XLayer.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3XLayer.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }
}
