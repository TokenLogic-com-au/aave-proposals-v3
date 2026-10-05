// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Monad, AaveV3MonadAssets} from 'aave-address-book/AaveV3Monad.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD} from './AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD.sol';
import {IPendlePriceCapAdapter} from '../interfaces/IPendlePriceCapAdapter.sol';

// Monad only: move these two lines into the NatSpec block below, directly above the contract, before running.
// Needs a Foundry nightly that includes the fix for foundry-rs/foundry#17165.
// forge-config: default.networks.network = "monad"
// forge-config: default.hardfork = "monad:MonadTen"
/**
 * @dev Test for AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/YYYYMMDD_AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad/AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD.t.sol -vv
 */
contract AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD_Test is ProtocolV3TestBase {
  AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('monad'), 0);
    proposal = new AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD',
      AaveV3Monad.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Monad.POOL, address(proposal), updatedAssets);
  }

  function test_dustBinHasPT_ASSET_DDMMMYYYYFunds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3Monad.POOL.getReserveAToken(proposal.PT_ASSET_DDMMMYYYY());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Monad.DUST_BIN)),
      proposal.PT_ASSET_DDMMMYYYY_SEED_AMOUNT()
    );
  }

  function test_priceFeedReturnsSanePrice() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    assertEq(
      AaveV3Monad.ORACLE.getSourceOfAsset(proposal.PT_ASSET_DDMMMYYYY()),
      proposal.PT_ASSET_DDMMMYYYY_PRICE_FEED()
    );
    uint256 price = AaveV3Monad.ORACLE.getAssetPrice(proposal.PT_ASSET_DDMMMYYYY());
    uint256 underlyingPrice = AaveV3Monad.ORACLE.getAssetPrice(AaveV3MonadAssets.AUSD_UNDERLYING);
    assertGt(price, 0);
    assertLt(price, underlyingPrice);
    IPendlePriceCapAdapter adapter = IPendlePriceCapAdapter(
      proposal.PT_ASSET_DDMMMYYYY_PRICE_FEED()
    );
    assertEq(adapter.discountRatePerYear(), 0);
    assertEq(adapter.MAX_DISCOUNT_RATE_PER_YEAR(), 0);
    assertEq(adapter.MATURITY(), 0);
    assertEq(adapter.PENDLE_PRINCIPAL_TOKEN(), proposal.PT_ASSET_DDMMMYYYY());
    assertEq(adapter.ASSET_TO_USD_AGGREGATOR(), AaveV3MonadAssets.AUSD_ORACLE);
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0x0000000000000000000000000000000000000000,
        assetSymbol: 'PT-ASSET-DDMMMYYYY',
        priceFeed: 0x0000000000000000000000000000000000000000,
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
      }),
      decimals: 6
    });
  }

  function test_eModeConfiguration() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    uint8 eMode_PT_ASSET_DDMMMYYYY__Stablecoins = _findEModeCategoryId(
      'PT_ASSET_DDMMMYYYY__Stablecoins'
    );
    _assertEModeCollateralConfig({
      id: eMode_PT_ASSET_DDMMMYYYY__Stablecoins,
      ltv: 0,
      liquidationThreshold: 0,
      liquidationBonus: 100_00 + 0,
      isolated: false
    });

    address[] memory collaterals_PT_ASSET_DDMMMYYYY__Stablecoins = new address[](1);
    collaterals_PT_ASSET_DDMMMYYYY__Stablecoins[0] = proposal.PT_ASSET_DDMMMYYYY();
    assertEq(
      AaveV3Monad.POOL.getEModeCategoryCollateralBitmap(eMode_PT_ASSET_DDMMMYYYY__Stablecoins),
      _toBitmap(collaterals_PT_ASSET_DDMMMYYYY__Stablecoins)
    );

    address[] memory borrowables_PT_ASSET_DDMMMYYYY__Stablecoins = new address[](5);
    borrowables_PT_ASSET_DDMMMYYYY__Stablecoins[0] = AaveV3MonadAssets.USDT0_UNDERLYING;
    borrowables_PT_ASSET_DDMMMYYYY__Stablecoins[1] = AaveV3MonadAssets.USDC_UNDERLYING;
    borrowables_PT_ASSET_DDMMMYYYY__Stablecoins[2] = AaveV3MonadAssets.GHO_UNDERLYING;
    borrowables_PT_ASSET_DDMMMYYYY__Stablecoins[3] = AaveV3MonadAssets.USDe_UNDERLYING;
    borrowables_PT_ASSET_DDMMMYYYY__Stablecoins[4] = AaveV3MonadAssets.mUSD_UNDERLYING;
    assertEq(
      AaveV3Monad.POOL.getEModeCategoryBorrowableBitmap(eMode_PT_ASSET_DDMMMYYYY__Stablecoins),
      _toBitmap(borrowables_PT_ASSET_DDMMMYYYY__Stablecoins)
    );
  }

  function test_eMode_PT_ASSET_DDMMMYYYY__Stablecoins_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'PT_ASSET_DDMMMYYYY__Stablecoins',
      proposal.PT_ASSET_DDMMMYYYY(),
      AaveV3MonadAssets.USDT0_UNDERLYING
    );
  }

  function test_PT_ASSET_DDMMMYYYYBorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.PT_ASSET_DDMMMYYYY()).decimals();
    deal(proposal.PT_ASSET_DDMMMYYYY(), user, supplyAmount);

    vm.startPrank(user);

    IERC20(proposal.PT_ASSET_DDMMMYYYY()).approve(address(AaveV3Monad.POOL), supplyAmount);
    AaveV3Monad.POOL.supply(proposal.PT_ASSET_DDMMMYYYY(), supplyAmount, user, 0);

    // LTV is 0 outside the e-mode, so the borrow must revert
    vm.expectRevert(abi.encodeWithSelector(Errors.LtvValidationFailed.selector));
    AaveV3Monad.POOL.borrow(AaveV3MonadAssets.USDT0_UNDERLYING, 1, 2, 0, user);

    vm.stopPrank();
  }

  function _findEModeCategoryId(string memory label) internal view returns (uint8) {
    for (uint8 i = 1; i < 255; i++) {
      if (keccak256(bytes(AaveV3Monad.POOL.getEModeCategoryLabel(i))) == keccak256(bytes(label))) {
        return i;
      }
    }
    revert('eMode category not found');
  }

  function _assertEModeCollateralConfig(
    uint8 id,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus,
    bool isolated
  ) internal view {
    DataTypes.CollateralConfig memory cfg = AaveV3Monad.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(cfg.ltv, ltv);
    assertEq(cfg.liquidationThreshold, liquidationThreshold);
    assertEq(cfg.liquidationBonus, liquidationBonus);
    assertEq(AaveV3Monad.POOL.getIsEModeCategoryIsolated(id), isolated);
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3Monad.POOL.getReserveData(assets[i]).id;
    }
  }

  function _supplyAndBorrowInEMode(
    string memory label,
    address collateral,
    address borrowAsset
  ) internal {
    uint8 eModeId = _findEModeCategoryId(label);

    address user = makeAddr('eModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(collateral).decimals();
    deal(collateral, user, supplyAmount);

    vm.startPrank(user);

    AaveV3Monad.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3Monad.POOL), supplyAmount);
    AaveV3Monad.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3Monad.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3Monad.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1);

    IERC20(borrowAsset).approve(address(AaveV3Monad.POOL), borrowAmount);
    AaveV3Monad.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3Monad.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }
}
