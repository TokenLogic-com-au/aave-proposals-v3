// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Monad, AaveV3MonadAssets} from 'aave-address-book/AaveV3Monad.sol';
import {AaveV3PayloadMonad} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadMonad.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Onboard PT-ASSET-DDMMMYYYY to Aave V3 Monad
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/<slug>/<id>
 */
contract AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD is AaveV3PayloadMonad {
  using SafeERC20 for IERC20;

  // https://monadscan.com/address/0x0000000000000000000000000000000000000000
  address public constant PT_ASSET_DDMMMYYYY = 0x0000000000000000000000000000000000000000;
  uint256 public constant PT_ASSET_DDMMMYYYY_SEED_AMOUNT = 100e6;
  // https://monadscan.com/address/0x0000000000000000000000000000000000000000
  address public constant PT_ASSET_DDMMMYYYY_PRICE_FEED =
    0x0000000000000000000000000000000000000000;

  function _postExecute() internal override {
    IERC20(PT_ASSET_DDMMMYYYY).forceApprove(
      address(AaveV3Monad.POOL),
      PT_ASSET_DDMMMYYYY_SEED_AMOUNT
    );
    AaveV3Monad.POOL.supply(
      PT_ASSET_DDMMMYYYY,
      PT_ASSET_DDMMMYYYY_SEED_AMOUNT,
      address(AaveV3Monad.DUST_BIN),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: PT_ASSET_DDMMMYYYY,
      assetSymbol: 'PT_ASSET_DDMMMYYYY',
      priceFeed: PT_ASSET_DDMMMYYYY_PRICE_FEED,
      enabledToBorrow: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 0,
      liqThreshold: 0,
      liqBonus: 0,
      reserveFactor: 20_00,
      supplyCap: 0,
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

    address[] memory collateralAssets_PT_ASSET_DDMMMYYYY__Stablecoins = new address[](1);
    address[] memory borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins = new address[](5);

    collateralAssets_PT_ASSET_DDMMMYYYY__Stablecoins[0] = PT_ASSET_DDMMMYYYY;
    borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins[0] = AaveV3MonadAssets.USDT0_UNDERLYING;
    borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins[1] = AaveV3MonadAssets.USDC_UNDERLYING;
    borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins[2] = AaveV3MonadAssets.GHO_UNDERLYING;
    borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins[3] = AaveV3MonadAssets.USDe_UNDERLYING;
    borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins[4] = AaveV3MonadAssets.mUSD_UNDERLYING;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 0,
      liqThreshold: 0,
      liqBonus: 0,
      label: 'PT_ASSET_DDMMMYYYY__Stablecoins',
      isolated: false,
      collaterals: collateralAssets_PT_ASSET_DDMMMYYYY__Stablecoins,
      borrowables: borrowableAssets_PT_ASSET_DDMMMYYYY__Stablecoins
    });

    return eModeCreations;
  }
}
