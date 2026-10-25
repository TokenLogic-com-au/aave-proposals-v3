// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {AaveV3PayloadPlasma} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadPlasma.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Asset Listing - Pendle PT-sUSDe-28JAN2027 Plasma
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-onboard-pt-susde-28jan2027-to-aave-v3-plasma-instance/25902
 */
contract AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022 is AaveV3PayloadPlasma {
  using SafeERC20 for IERC20;

  // https://plasmascan.to/address/0x257561233419039BeC3a28be717d14B4f490883D
  address public constant PT_sUSDE_28JAN2027 = 0x257561233419039BeC3a28be717d14B4f490883D;
  uint256 public constant PT_sUSDE_28JAN2027_SEED_AMOUNT = 160e18;
  address public constant PT_sUSDE_28JAN2027_PRICE_FEED = address(0);

  function _postExecute() internal override {
    IERC20(PT_sUSDE_28JAN2027).forceApprove(
      address(AaveV3Plasma.POOL),
      PT_sUSDE_28JAN2027_SEED_AMOUNT
    );
    AaveV3Plasma.POOL.supply(
      PT_sUSDE_28JAN2027,
      PT_sUSDE_28JAN2027_SEED_AMOUNT,
      address(AaveV3Plasma.DUST_BIN),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: PT_sUSDE_28JAN2027,
      assetSymbol: 'PT_sUSDE_28JAN2027',
      priceFeed: PT_sUSDE_28JAN2027_PRICE_FEED,
      enabledToBorrow: EngineFlags.DISABLED,
      flashloanable: EngineFlags.DISABLED,
      ltv: 0,
      liqThreshold: 0,
      liqBonus: 0,
      reserveFactor: 45_00,
      supplyCap: 150_000_000,
      borrowCap: 1,
      liqProtocolFee: 10_00,
      rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
        optimalUsageRatio: 45_00,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 10_00,
        variableRateSlope2: 300_00
      })
    });

    return listings;
  }

  function eModeCategoryCreations()
    public
    pure
    override
    returns (IAaveV3ConfigEngine.EModeCategoryCreation[] memory)
  {
    IAaveV3ConfigEngine.EModeCategoryCreation[]
      memory eModeCreations = new IAaveV3ConfigEngine.EModeCategoryCreation[](2);

    address[] memory collateralAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins = new address[](2);
    address[] memory borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins = new address[](3);

    collateralAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[0] = AaveV3PlasmaAssets.sUSDe_UNDERLYING;
    collateralAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[1] = PT_sUSDE_28JAN2027;
    borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[0] = AaveV3PlasmaAssets.USDT0_UNDERLYING;
    borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[1] = AaveV3PlasmaAssets.USDe_UNDERLYING;
    borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[2] = AaveV3PlasmaAssets.GHO_UNDERLYING;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 87_71,
      liqThreshold: 89_71,
      liqBonus: 4_87,
      label: 'sUSDe_PT_sUSDe_28JAN2027__Stablecoins',
      isolated: true,
      collaterals: collateralAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins,
      borrowables: borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__Stablecoins
    });

    address[] memory collateralAssets_SUSDe_PT_sUSDe_28JAN2027__USDe = new address[](2);
    address[] memory borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__USDe = new address[](1);

    collateralAssets_SUSDe_PT_sUSDe_28JAN2027__USDe[0] = AaveV3PlasmaAssets.sUSDe_UNDERLYING;
    collateralAssets_SUSDe_PT_sUSDe_28JAN2027__USDe[1] = PT_sUSDE_28JAN2027;
    borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__USDe[0] = AaveV3PlasmaAssets.USDe_UNDERLYING;

    eModeCreations[1] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 90_35,
      liqThreshold: 92_35,
      liqBonus: 1_87,
      label: 'sUSDe_PT_sUSDe_28JAN2027__USDe',
      isolated: true,
      collaterals: collateralAssets_SUSDe_PT_sUSDe_28JAN2027__USDe,
      borrowables: borrowableAssets_SUSDe_PT_sUSDe_28JAN2027__USDe
    });

    return eModeCreations;
  }
}
