// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3XLayer, AaveV3XLayerAssets} from 'aave-address-book/AaveV3XLayer.sol';
import {AaveV3PayloadXLayer} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadXLayer.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Onboard syrupUSDG to Aave V3 X Layer
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-x-layer/25855
 */
contract AaveV3XLayer_AaveV3XLayerSyrupUSDGListing_20261014 is AaveV3PayloadXLayer {
  using SafeERC20 for IERC20;

  address public constant syrupUSDG = 0x0000000000000000000000000000000000000000;
  uint256 public constant syrupUSDG_SEED_AMOUNT = 150e6;
  address public constant syrupUSDG_PRICE_FEED = 0x0000000000000000000000000000000000000000;

  function _postExecute() internal override {
    IERC20(syrupUSDG).forceApprove(address(AaveV3XLayer.POOL), syrupUSDG_SEED_AMOUNT);
    AaveV3XLayer.POOL.supply(syrupUSDG, syrupUSDG_SEED_AMOUNT, address(AaveV3XLayer.DUST_BIN), 0);
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: syrupUSDG,
      assetSymbol: 'syrupUSDG',
      priceFeed: syrupUSDG_PRICE_FEED,
      enabledToBorrow: EngineFlags.DISABLED,
      flashloanable: EngineFlags.DISABLED,
      ltv: 0,
      liqThreshold: 0,
      liqBonus: 0,
      reserveFactor: 20_00,
      supplyCap: 20_000_000,
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
      memory eModeCreations = new IAaveV3ConfigEngine.EModeCategoryCreation[](1);

    address[] memory collateralAssets_SyrupUSDG__Stablecoins = new address[](1);
    address[] memory borrowableAssets_SyrupUSDG__Stablecoins = new address[](4);

    collateralAssets_SyrupUSDG__Stablecoins[0] = syrupUSDG;
    borrowableAssets_SyrupUSDG__Stablecoins[0] = AaveV3XLayerAssets.USDT_UNDERLYING;
    borrowableAssets_SyrupUSDG__Stablecoins[1] = AaveV3XLayerAssets.USDG_UNDERLYING;
    borrowableAssets_SyrupUSDG__Stablecoins[2] = AaveV3XLayerAssets.USDC_UNDERLYING;
    borrowableAssets_SyrupUSDG__Stablecoins[3] = AaveV3XLayerAssets.GHO_UNDERLYING;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 90_00,
      liqThreshold: 92_00,
      liqBonus: 4_00,
      label: 'syrupUSDG__Stablecoins',
      isolated: false,
      collaterals: collateralAssets_SyrupUSDG__Stablecoins,
      borrowables: borrowableAssets_SyrupUSDG__Stablecoins
    });

    return eModeCreations;
  }
}
