// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle, AaveV3MantleAssets} from 'aave-address-book/AaveV3Mantle.sol';
import {AaveV3PayloadMantle} from 'aave-helpers/src/v3-config-engine/AaveV3PayloadMantle.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

/**
 * @title Aave V3 Mantle – mETH Listing
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/arfc-onboard-mnt-meth-cmeth-as-collateral-assets-on-aave-v3-mantle-instance/21772
 */
contract AaveV3Mantle_AaveV3MantleMETHListing_20260806 is AaveV3PayloadMantle {
  using SafeERC20 for IERC20;

  // https://mantlescan.xyz/address/0xcDA86A272531e8640cD7F1a92c01839911B90bb0
  address public constant mETH = 0xcDA86A272531e8640cD7F1a92c01839911B90bb0;
  uint256 public constant mETH_SEED_AMOUNT = 0.05e18; // 0.05 mETH (~100 USD)
  // TODO: placeholder — replace with the Capped mETH / ETH / USD CAPO adapter once deployed
  address public constant mETH_PRICE_FEED = 0x0000000000000000000000000000000000000001;

  function _postExecute() internal override {
    IERC20(mETH).forceApprove(address(AaveV3Mantle.POOL), mETH_SEED_AMOUNT);
    AaveV3Mantle.POOL.supply(mETH, mETH_SEED_AMOUNT, address(AaveV3Mantle.DUST_BIN), 0);
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: mETH,
      assetSymbol: 'mETH',
      priceFeed: mETH_PRICE_FEED,
      enabledToBorrow: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 0,
      liqThreshold: 0,
      liqBonus: 0,
      reserveFactor: 20_00,
      supplyCap: 5_000,
      // borrowing is disabled; borrowCap 1 acts as a second guardrail in case it is ever enabled by mistake
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

    address[] memory collateralAssets_METHCorrelated = new address[](1);
    address[] memory borrowableAssets_METHCorrelated = new address[](1);

    collateralAssets_METHCorrelated[0] = mETH;
    borrowableAssets_METHCorrelated[0] = AaveV3MantleAssets.WETH_UNDERLYING;

    eModeCreations[0] = IAaveV3ConfigEngine.EModeCategoryCreation({
      ltv: 93_00,
      liqThreshold: 95_00,
      liqBonus: 1_00,
      label: 'mETH Correlated',
      isolated: false,
      collaterals: collateralAssets_METHCorrelated,
      borrowables: borrowableAssets_METHCorrelated
    });

    return eModeCreations;
  }
}
