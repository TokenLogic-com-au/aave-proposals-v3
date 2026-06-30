// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle, AaveV3MantleAssets} from 'aave-address-book/AaveV3Mantle.sol';
import {AaveV3PayloadMantle} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadMantle.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Aave V3 Mantle – XAUt Listing, WMNT/WETH eMode Expansion and Isolation Removal
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-aave-v3-mantle-collateral-enablement-emode-expansion-and-isolation-updates-usdt0-usde-eth-xaut/24153
 */
contract AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611 is AaveV3PayloadMantle {
  using SafeERC20 for IERC20;

  // https://mantlescan.xyz/address/0x6199CCd9273A1E0e41e2cC18d9dAcd1E9382F58E
  address public constant XAUt = 0x6199CCd9273A1E0e41e2cC18d9dAcd1E9382F58E;
  // TODO: replace with Chainlink XAU/USD on Mantle once deployed
  address public constant XAUt_PRICE_FEED = 0x0000000000000000000000000000000000000001;
  uint256 public constant XAUt_SEED_AMOUNT = 10 ** 6;

  function _postExecute() internal override {
    IERC20(XAUt).forceApprove(address(AaveV3Mantle.POOL), XAUt_SEED_AMOUNT);
    AaveV3Mantle.POOL.supply(XAUt, XAUt_SEED_AMOUNT, AaveV3Mantle.DUST_BIN, 0);
  }

  function collateralsUpdates()
    public
    pure
    override
    returns (IAaveV3ConfigEngine.CollateralUpdate[] memory)
  {
    IAaveV3ConfigEngine.CollateralUpdate[]
      memory collateralUpdate = new IAaveV3ConfigEngine.CollateralUpdate[](2);

    collateralUpdate[0] = IAaveV3ConfigEngine.CollateralUpdate({
      asset: AaveV3MantleAssets.WETH_UNDERLYING,
      ltv: 78_00,
      liqThreshold: 80_00,
      liqBonus: 5_50,
      liqProtocolFee: 10_00
    });
    collateralUpdate[1] = IAaveV3ConfigEngine.CollateralUpdate({
      asset: AaveV3MantleAssets.WMNT_UNDERLYING,
      ltv: 0,
      liqThreshold: 45_00,
      liqBonus: 10_00,
      liqProtocolFee: 10_00
    });

    return collateralUpdate;
  }

  function newListingsCustom()
    public
    pure
    override
    returns (IAaveV3ConfigEngine.ListingWithCustomImpl[] memory)
  {
    IAaveV3ConfigEngine.ListingWithCustomImpl[]
      memory listings = new IAaveV3ConfigEngine.ListingWithCustomImpl[](1);

    listings[0] = IAaveV3ConfigEngine.ListingWithCustomImpl({
      base: IAaveV3ConfigEngine.Listing({
        asset: XAUt,
        assetSymbol: 'XAUt',
        priceFeed: XAUt_PRICE_FEED,
        rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
          optimalUsageRatio: 45_00,
          baseVariableBorrowRate: 0,
          variableRateSlope1: 10_00,
          variableRateSlope2: 300_00
        }),
        enabledToBorrow: EngineFlags.DISABLED,
        flashloanable: EngineFlags.ENABLED,
        ltv: 0,
        liqThreshold: 0,
        liqBonus: 0,
        reserveFactor: 20_00,
        supplyCap: 4_000,
        borrowCap: 1,
        liqProtocolFee: 10_00
      }),
      implementations: IAaveV3ConfigEngine.TokenImplementations({
        aToken: 0xD7ab0676222c0235e09a06640c422bf97CCC2Bc5,
        vToken: 0x604174a3bA9228F3c7823d2E1aAA17A90E06C160
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
      memory eModeCreations = new IAaveV3ConfigEngine.EModeCategoryCreation[](3);

    address[] memory borrowableAssets_Stablecoins = new address[](3);
    borrowableAssets_Stablecoins[0] = AaveV3MantleAssets.USDT0_UNDERLYING;
    borrowableAssets_Stablecoins[1] = AaveV3MantleAssets.USDC_UNDERLYING;
    borrowableAssets_Stablecoins[2] = AaveV3MantleAssets.GHO_UNDERLYING;

    address[] memory collateralAssets_XAUtStablecoins = new address[](1);
    collateralAssets_XAUtStablecoins[0] = XAUt;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 70_00,
      liqThreshold: 75_00,
      liqBonus: 6_00,
      label: 'XAUt Stablecoins',
      collaterals: collateralAssets_XAUtStablecoins,
      borrowables: borrowableAssets_Stablecoins,
      isolated: false
    });

    address[] memory collateralAssets_WETHStablecoins = new address[](1);
    collateralAssets_WETHStablecoins[0] = AaveV3MantleAssets.WETH_UNDERLYING;

    eModeCreations[1] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 80_50,
      liqThreshold: 83_00,
      liqBonus: 5_50,
      label: 'WETH Stablecoins',
      collaterals: collateralAssets_WETHStablecoins,
      borrowables: borrowableAssets_Stablecoins,
      isolated: false
    });

    address[] memory collateralAssets_WMNTStablecoins = new address[](1);
    collateralAssets_WMNTStablecoins[0] = AaveV3MantleAssets.WMNT_UNDERLYING;

    eModeCreations[2] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 40_00,
      liqThreshold: 45_00,
      liqBonus: 10_00,
      label: 'WMNT Stablecoins',
      collaterals: collateralAssets_WMNTStablecoins,
      borrowables: borrowableAssets_Stablecoins,
      isolated: false
    });

    return eModeCreations;
  }
}
