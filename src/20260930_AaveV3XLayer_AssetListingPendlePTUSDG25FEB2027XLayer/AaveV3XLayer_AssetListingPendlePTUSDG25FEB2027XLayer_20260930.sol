// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3XLayer, AaveV3XLayerEModes} from 'aave-address-book/AaveV3XLayer.sol';
import {AaveV3PayloadXLayer} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadXLayer.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Asset Listing - Pendle PT-USDG-25FEB2027 X Layer
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-onboard-pt-usdg-25feb2027-on-x-layer/25733
 */
contract AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930 is AaveV3PayloadXLayer {
  using SafeERC20 for IERC20;

  // https://www.oklink.com/xlayer/address/0x5eA1F184af5Ced57725213D8267B5c4C834557D4
  address public constant PT_USDG_25FEB2027 = 0x5eA1F184af5Ced57725213D8267B5c4C834557D4;
  uint256 public constant PT_USDG_25FEB2027_SEED_AMOUNT = 100e6;
  // https://www.oklink.com/xlayer/address/0x6052839E52ab454F164ee5668e5B523cF5A389Fc
  address public constant PT_USDG_25FEB2027_PRICE_FEED = 0x6052839E52ab454F164ee5668e5B523cF5A389Fc;

  function _postExecute() internal override {
    IERC20(PT_USDG_25FEB2027).forceApprove(
      address(AaveV3XLayer.POOL),
      PT_USDG_25FEB2027_SEED_AMOUNT
    );
    AaveV3XLayer.POOL.supply(
      PT_USDG_25FEB2027,
      PT_USDG_25FEB2027_SEED_AMOUNT,
      address(AaveV3XLayer.DUST_BIN),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: PT_USDG_25FEB2027,
      assetSymbol: 'PT_USDG_25FEB2027',
      priceFeed: PT_USDG_25FEB2027_PRICE_FEED,
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
    });

    return listings;
  }

  function assetsEModeUpdates()
    public
    pure
    override
    returns (IAaveV3ConfigEngine.AssetEModeUpdate[] memory)
  {
    IAaveV3ConfigEngine.AssetEModeUpdate[]
      memory assetEModeUpdates = new IAaveV3ConfigEngine.AssetEModeUpdate[](1);

    assetEModeUpdates[0] = IAaveV3ConfigEngine.AssetEModeUpdate({
      asset: PT_USDG_25FEB2027,
      eModeCategory: AaveV3XLayerEModes.PT_USDG_29OCT2026__USDT_USDG_GHO_USDC,
      borrowable: EngineFlags.DISABLED,
      collateral: EngineFlags.ENABLED,
      ltvzero: EngineFlags.DISABLED
    });

    return assetEModeUpdates;
  }
}
