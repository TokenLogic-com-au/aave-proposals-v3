// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3PayloadArbitrum} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadArbitrum.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Onboard syrupUSDG to Aave V3 Arbitrum
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-arbitrum/25851
 */
contract AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014 is AaveV3PayloadArbitrum {
  using SafeERC20 for IERC20;

  // https://arbiscan.io/address/0x004B506865409877C9fA29bfb1ebA929984B9bbC
  address public constant USDG = 0x004B506865409877C9fA29bfb1ebA929984B9bbC;
  // https://arbiscan.io/address/0xE1B0dC5A21b10f1634fBfbE9976fBA2Ee2e1c762
  address public constant syrupUSDG = 0xE1B0dC5A21b10f1634fBfbE9976fBA2Ee2e1c762;
  uint256 public constant syrupUSDG_SEED_AMOUNT = 150e6;
  address public constant syrupUSDG_PRICE_FEED = 0x0000000000000000000000000000000000000000;

  function _preExecute() internal view override {
    require(
      AaveV3Arbitrum.POOL.getReserveData(USDG).aTokenAddress != address(0),
      'USDG_LISTING_NOT_EXECUTED'
    );
  }

  function _postExecute() internal override {
    IERC20(syrupUSDG).forceApprove(address(AaveV3Arbitrum.POOL), syrupUSDG_SEED_AMOUNT);
    AaveV3Arbitrum.POOL.supply(
      syrupUSDG,
      syrupUSDG_SEED_AMOUNT,
      address(AaveV3Arbitrum.DUST_BIN),
      0
    );
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
      supplyCap: 10_000_000,
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

    address[] memory collateralAssets_SyrupUSDG__USDCn_USDT_GHO_USDG = new address[](1);
    address[] memory borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG = new address[](4);

    collateralAssets_SyrupUSDG__USDCn_USDT_GHO_USDG[0] = syrupUSDG;
    borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG[0] = AaveV3ArbitrumAssets.USDCn_UNDERLYING;
    borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG[1] = AaveV3ArbitrumAssets.USDT_UNDERLYING;
    borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG[2] = AaveV3ArbitrumAssets.GHO_UNDERLYING;
    borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG[3] = USDG;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 90_00,
      liqThreshold: 92_00,
      liqBonus: 4_00,
      label: 'syrupUSDG__USDCn_USDT_GHO_USDG',
      isolated: false,
      collaterals: collateralAssets_SyrupUSDG__USDCn_USDT_GHO_USDG,
      borrowables: borrowableAssets_SyrupUSDG__USDCn_USDT_GHO_USDG
    });

    return eModeCreations;
  }
}
