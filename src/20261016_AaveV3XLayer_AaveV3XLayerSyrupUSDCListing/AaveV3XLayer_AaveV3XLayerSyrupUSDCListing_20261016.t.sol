// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3XLayer, AaveV3XLayerAssets} from 'aave-address-book/AaveV3XLayer.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016} from './AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016.sol';
import {IPriceCapAdapter} from '../interfaces/IPriceCapAdapter.sol';

/**
 * @dev Test for AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261016_AaveV3XLayer_AaveV3XLayerSyrupUSDCListing/AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016.t.sol -vv
 */
contract AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016_Test is ProtocolV3TestBase {
  AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('xlayer'), 73147962);
    proposal = new AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016',
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

  function test_dustBinHasSyrupUSDCFunds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3XLayer.POOL.getReserveAToken(proposal.syrupUSDC());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3XLayer.DUST_BIN)),
      proposal.syrupUSDC_SEED_AMOUNT(),
      'dust bin should hold at least the seeded asyrupUSDC amount'
    );
  }

  function test_liquidationProtocolFee() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    assertEq(
      AaveV3XLayer.AAVE_PROTOCOL_DATA_PROVIDER.getLiquidationProtocolFee(proposal.syrupUSDC()),
      10_00
    );
  }

  function test_priceFeed() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address adapterAddress = 0x0000000000000000000000000000000000000000;
    _validateAssetSourceOnOracle(
      AaveV3XLayer.POOL_ADDRESSES_PROVIDER,
      proposal.syrupUSDC(),
      adapterAddress
    );
    assertEq(proposal.syrupUSDC_PRICE_FEED(), adapterAddress);

    IPriceCapAdapter adapter = IPriceCapAdapter(adapterAddress);
    assertEq(
      address(adapter.BASE_TO_USD_AGGREGATOR()),
      0x26AD1207EAA39F74FAC725599ce1c431C80eF6cC,
      'base feed should be the Capped USDC / USD adapter'
    );
    assertEq(
      adapter.RATIO_PROVIDER(),
      0x04c00259887Cc94764DF190c8D3663c765618204,
      'ratio provider should be the Chainlink syrupUSDC / USDC exchange rate feed'
    );
    assertEq(adapter.decimals(), 8);

    uint256 price = AaveV3XLayer.ORACLE.getAssetPrice(proposal.syrupUSDC());
    assertGe(price, 1.15e8, 'syrupUSDC price is implausibly low');
    assertLe(price, 1.25e8, 'syrupUSDC price is implausibly high');
  }

  function test_rates() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address strategy = AaveV3XLayer.POOL.RESERVE_INTEREST_RATE_STRATEGY();
    _validateInterestRateStrategy(
      proposal.syrupUSDC(),
      AaveV3XLayer.POOL.getReserveData(proposal.syrupUSDC()).interestRateStrategyAddress,
      strategy,
      IDefaultInterestRateStrategyV2.InterestRateDataRay({
        optimalUsageRatio: 0.45e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.1e27,
        variableRateSlope2: 3e27
      })
    );
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0x0000000000000000000000000000000000000000,
        assetSymbol: 'syrupUSDC',
        priceFeed: 0x0000000000000000000000000000000000000000,
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
      }),
      decimals: 6
    });
  }

  function test_eModeConfiguration() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    uint8 eMode_SyrupUSDC__Stablecoins = _findEModeCategoryId('syrupUSDC__Stablecoins');
    _assertEModeCollateralConfig({
      id: eMode_SyrupUSDC__Stablecoins,
      ltv: 90_00,
      liquidationThreshold: 92_00,
      liquidationBonus: 100_00 + 4_00,
      isolated: false
    });

    address[] memory collaterals_SyrupUSDC__Stablecoins = new address[](1);
    collaterals_SyrupUSDC__Stablecoins[0] = proposal.syrupUSDC();
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(eMode_SyrupUSDC__Stablecoins),
      _toBitmap(collaterals_SyrupUSDC__Stablecoins)
    );

    address[] memory borrowables_SyrupUSDC__Stablecoins = new address[](4);
    borrowables_SyrupUSDC__Stablecoins[0] = AaveV3XLayerAssets.USDT_UNDERLYING;
    borrowables_SyrupUSDC__Stablecoins[1] = AaveV3XLayerAssets.USDG_UNDERLYING;
    borrowables_SyrupUSDC__Stablecoins[2] = AaveV3XLayerAssets.USDC_UNDERLYING;
    borrowables_SyrupUSDC__Stablecoins[3] = AaveV3XLayerAssets.GHO_UNDERLYING;
    assertEq(
      AaveV3XLayer.POOL.getEModeCategoryBorrowableBitmap(eMode_SyrupUSDC__Stablecoins),
      _toBitmap(borrowables_SyrupUSDC__Stablecoins)
    );
  }

  function test_existingEModesUnchanged() public {
    EModeSnapshot[] memory before_ = _snapshotAllEModes();
    assertGe(before_.length, 8, 'X Layer has at least eight eModes before the listing');

    GovV3Helpers.executePayload(vm, address(proposal));

    for (uint256 i = 0; i < before_.length; i++) {
      _assertEModeParamsAndCollateralUnchanged(before_[i]);
      assertEq(
        AaveV3XLayer.POOL.getEModeCategoryBorrowableBitmap(before_[i].id),
        before_[i].borrowableBitmap,
        'borrowable bitmap should not change'
      );
    }
  }

  function test_eMode_SyrupUSDC__Stablecoins_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'syrupUSDC__Stablecoins',
      proposal.syrupUSDC(),
      AaveV3XLayerAssets.USDT_UNDERLYING
    );
  }

  function test_syrupUSDCBorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address syrupUSDC = proposal.syrupUSDC();
    address user = makeAddr('borrowSyrupUSDCUser');
    uint256 supplyAmount = 1_000 *
      10 ** IERC20Metadata(AaveV3XLayerAssets.USDC_UNDERLYING).decimals();
    deal(AaveV3XLayerAssets.USDC_UNDERLYING, user, supplyAmount);

    vm.startPrank(user);
    IERC20(AaveV3XLayerAssets.USDC_UNDERLYING).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(AaveV3XLayerAssets.USDC_UNDERLYING, supplyAmount, user, 0);

    vm.expectRevert(abi.encodeWithSelector(Errors.BorrowingNotEnabled.selector));
    AaveV3XLayer.POOL.borrow(syrupUSDC, 1, 2, 0, user);
    vm.stopPrank();
  }

  function test_syrupUSDCBorrowInEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address syrupUSDC = proposal.syrupUSDC();
    address user = makeAddr('borrowSyrupUSDCInEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(syrupUSDC).decimals();
    deal(syrupUSDC, user, supplyAmount);

    vm.startPrank(user);
    AaveV3XLayer.POOL.setUserEMode(_findEModeCategoryId('syrupUSDC__Stablecoins'));
    IERC20(syrupUSDC).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(syrupUSDC, supplyAmount, user, 0);

    vm.expectRevert(abi.encodeWithSelector(Errors.NotBorrowableInEMode.selector));
    AaveV3XLayer.POOL.borrow(syrupUSDC, 1, 2, 0, user);
    vm.stopPrank();
  }

  function test_syrupUSDCCollateralOutsideEModeHasNoBorrowPower() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.syrupUSDC()).decimals();
    deal(proposal.syrupUSDC(), user, supplyAmount);

    vm.startPrank(user);
    IERC20(proposal.syrupUSDC()).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(proposal.syrupUSDC(), supplyAmount, user, 0);

    (, , uint256 availableBorrowsBase, , uint256 ltv, ) = AaveV3XLayer.POOL.getUserAccountData(
      user
    );
    assertEq(ltv, 0, 'ltv should be 0 outside the eMode');
    assertEq(availableBorrowsBase, 0, 'no borrow power outside the eMode');

    vm.expectRevert(abi.encodeWithSelector(Errors.LtvValidationFailed.selector));
    AaveV3XLayer.POOL.borrow(AaveV3XLayerAssets.USDT_UNDERLYING, 1, 2, 0, user);
    vm.stopPrank();
  }

  struct EModeSnapshot {
    uint8 id;
    string label;
    DataTypes.CollateralConfig collateralConfig;
    bool isolated;
    uint128 collateralBitmap;
    uint128 borrowableBitmap;
  }

  function _snapshotEMode(uint8 id) internal view returns (EModeSnapshot memory snap) {
    snap.id = id;
    snap.label = AaveV3XLayer.POOL.getEModeCategoryLabel(id);
    snap.collateralConfig = AaveV3XLayer.POOL.getEModeCategoryCollateralConfig(id);
    snap.isolated = AaveV3XLayer.POOL.getIsEModeCategoryIsolated(id);
    snap.collateralBitmap = AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(id);
    snap.borrowableBitmap = AaveV3XLayer.POOL.getEModeCategoryBorrowableBitmap(id);
  }

  function _snapshotAllEModes() internal view returns (EModeSnapshot[] memory snaps) {
    uint256 count;
    for (uint8 i = 1; i < 255; i++) {
      if (bytes(AaveV3XLayer.POOL.getEModeCategoryLabel(i)).length != 0) count++;
    }
    snaps = new EModeSnapshot[](count);
    uint256 index;
    for (uint8 i = 1; i < 255; i++) {
      if (bytes(AaveV3XLayer.POOL.getEModeCategoryLabel(i)).length != 0) {
        snaps[index++] = _snapshotEMode(i);
      }
    }
  }

  function _assertEModeParamsAndCollateralUnchanged(EModeSnapshot memory snap) internal view {
    assertEq(AaveV3XLayer.POOL.getEModeCategoryLabel(snap.id), snap.label);
    _assertEModeCollateralConfig({
      id: snap.id,
      ltv: snap.collateralConfig.ltv,
      liquidationThreshold: snap.collateralConfig.liquidationThreshold,
      liquidationBonus: snap.collateralConfig.liquidationBonus,
      isolated: snap.isolated
    });
    assertEq(AaveV3XLayer.POOL.getEModeCategoryCollateralBitmap(snap.id), snap.collateralBitmap);
  }

  function _findEModeCategoryId(string memory label) internal view returns (uint8) {
    for (uint8 i = 1; i < 255; i++) {
      if (keccak256(bytes(AaveV3XLayer.POOL.getEModeCategoryLabel(i))) == keccak256(bytes(label))) {
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
    DataTypes.CollateralConfig memory cfg = AaveV3XLayer.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(cfg.ltv, ltv);
    assertEq(cfg.liquidationThreshold, liquidationThreshold);
    assertEq(cfg.liquidationBonus, liquidationBonus);
    assertEq(AaveV3XLayer.POOL.getIsEModeCategoryIsolated(id), isolated);
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3XLayer.POOL.getReserveData(assets[i]).id;
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

    AaveV3XLayer.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3XLayer.POOL), supplyAmount);
    AaveV3XLayer.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3XLayer.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3XLayer.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1);

    IERC20(borrowAsset).approve(address(AaveV3XLayer.POOL), borrowAmount);
    AaveV3XLayer.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3XLayer.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }
}
