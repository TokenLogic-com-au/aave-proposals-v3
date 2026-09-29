// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Monad, AaveV3MonadAssets} from 'aave-address-book/AaveV3Monad.sol';
import {AaveV3PayloadMonad} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadMonad.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Onboard PT-AUSD-17DEC2026 to Aave V3 Monad
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-onboard-pt-ausd-17dec2026-to-aave-v3-monad-instance/25701
 */
contract AaveV3Monad_AssetListingPendlePTAUSD17DEC2026Monad_20260929 is AaveV3PayloadMonad {
  using SafeERC20 for IERC20;

  // https://monadscan.com/address/0x8B562578b2f9Aa8C14cCda3c5d6CBCEaD3B06a57
  address public constant PT_AUSD_17DEC2026 = 0x8B562578b2f9Aa8C14cCda3c5d6CBCEaD3B06a57;
  uint256 public constant PT_AUSD_17DEC2026_SEED_AMOUNT = 100e6;
  // https://monadscan.com/address/0x608250bbc11eeaeD31794f976946399eB49bd57c
  address public constant PT_AUSD_17DEC2026_PRICE_FEED = 0x608250bbc11eeaeD31794f976946399eB49bd57c;

  function _postExecute() internal override {
    IERC20(PT_AUSD_17DEC2026).forceApprove(
      address(AaveV3Monad.POOL),
      PT_AUSD_17DEC2026_SEED_AMOUNT
    );
    AaveV3Monad.POOL.supply(
      PT_AUSD_17DEC2026,
      PT_AUSD_17DEC2026_SEED_AMOUNT,
      address(AaveV3Monad.DUST_BIN),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: PT_AUSD_17DEC2026,
      assetSymbol: 'PT_AUSD_17DEC2026',
      priceFeed: PT_AUSD_17DEC2026_PRICE_FEED,
      enabledToBorrow: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
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

    address[] memory collateralAssets_PT_AUSD_17DEC2026__Stablecoins = new address[](1);
    address[] memory borrowableAssets_PT_AUSD_17DEC2026__Stablecoins = new address[](4);

    collateralAssets_PT_AUSD_17DEC2026__Stablecoins[0] = PT_AUSD_17DEC2026;
    borrowableAssets_PT_AUSD_17DEC2026__Stablecoins[0] = AaveV3MonadAssets.USDT0_UNDERLYING;
    borrowableAssets_PT_AUSD_17DEC2026__Stablecoins[1] = AaveV3MonadAssets.USDC_UNDERLYING;
    borrowableAssets_PT_AUSD_17DEC2026__Stablecoins[2] = AaveV3MonadAssets.GHO_UNDERLYING;
    borrowableAssets_PT_AUSD_17DEC2026__Stablecoins[3] = AaveV3MonadAssets.USDe_UNDERLYING;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 93_00,
      liqThreshold: 95_00,
      liqBonus: 2_44,
      label: 'PT_AUSD_17DEC2026__Stablecoins',
      isolated: true,
      collaterals: collateralAssets_PT_AUSD_17DEC2026__Stablecoins,
      borrowables: borrowableAssets_PT_AUSD_17DEC2026__Stablecoins
    });

    return eModeCreations;
  }
}
