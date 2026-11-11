// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {IDefaultInterestRateStrategyV2} from 'aave-v3-origin/contracts/interfaces/IDefaultInterestRateStrategyV2.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008} from '../20261008_AaveV3Arbitrum_AaveV3ArbitrumUSDGListing/AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008.sol';
import {AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014} from './AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014.sol';
import {IPriceCapAdapter} from '../interfaces/IPriceCapAdapter.sol';

/**
 * @dev Test for AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261014_AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing/AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014.t.sol -vv
 */
contract AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014_Test is ProtocolV3TestBase {
  string internal constant EMODE_LABEL = 'syrupUSDG__USDCn_USDT_GHO_USDG';

  AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008 internal usdgListing;
  AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 514767348);

    // the syrupUSDG eMode lists USDG as borrowable, so the USDG listing payload executes first
    usdgListing = new AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008();
    deal(usdgListing.USDG(), GovernanceV3Arbitrum.EXECUTOR_LVL_1, usdgListing.USDG_SEED_AMOUNT());
    GovV3Helpers.executePayload(vm, address(usdgListing));

    proposal = new AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014',
      AaveV3Arbitrum.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Arbitrum.POOL, address(proposal), updatedAssets);
  }

  function test_revertsIfUSDGListingNotExecuted() public {
    // fork a clean state where the USDG listing payload has not run yet
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 514767348);
    AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014 syrupListing = new AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014();

    vm.expectRevert(bytes('USDG_LISTING_NOT_EXECUTED'));
    syrupListing.execute();
  }

  function test_dustBinHasSyrupUSDGFunds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3Arbitrum.POOL.getReserveAToken(proposal.syrupUSDG());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Arbitrum.DUST_BIN)),
      proposal.syrupUSDG_SEED_AMOUNT(),
      'dust bin should hold at least the seeded asyrupUSDG amount'
    );
  }

  function test_liquidationProtocolFee() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    assertEq(
      AaveV3Arbitrum.AAVE_PROTOCOL_DATA_PROVIDER.getLiquidationProtocolFee(proposal.syrupUSDG()),
      10_00
    );
  }

  function test_priceFeed() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address adapterAddress = 0x0000000000000000000000000000000000000000;
    _validateAssetSourceOnOracle(
      AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER,
      proposal.syrupUSDG(),
      adapterAddress
    );
    assertEq(proposal.syrupUSDG_PRICE_FEED(), adapterAddress);

    IPriceCapAdapter adapter = IPriceCapAdapter(adapterAddress);
    assertEq(adapter.description(), 'Capped SyrupUSDG / USDG / USD');
    assertEq(
      address(adapter.BASE_TO_USD_AGGREGATOR()),
      0xf6bDD632625425cE368Bb19Af5A01C3C0344EB1D,
      'base feed should be the Capped USDG / USD adapter'
    );
    assertEq(
      adapter.RATIO_PROVIDER(),
      0x6b1aBf37cFB16deedD27D7C23168e7dF4feD8AFF,
      'ratio provider should be the Chainlink syrupUSDG / USDG exchange rate feed'
    );
    assertEq(adapter.decimals(), 8);

    uint256 price = AaveV3Arbitrum.ORACLE.getAssetPrice(proposal.syrupUSDG());
    assertGe(price, 1.005e8, 'syrupUSDG price is implausibly low');
    assertLe(price, 1.025e8, 'syrupUSDG price is implausibly high');
  }

  function test_rates() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _validateInterestRateStrategy(
      proposal.syrupUSDG(),
      AaveV3Arbitrum.POOL.getReserveData(proposal.syrupUSDG()).interestRateStrategyAddress,
      AaveV3Arbitrum.POOL.RESERVE_INTEREST_RATE_STRATEGY(),
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
        asset: 0xE1B0dC5A21b10f1634fBfbE9976fBA2Ee2e1c762,
        assetSymbol: 'syrupUSDG',
        priceFeed: 0x0000000000000000000000000000000000000000,
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
      }),
      decimals: 6
    });
  }

  function test_eModeConfiguration() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    uint8 eModeId = _findEModeCategoryId(EMODE_LABEL);
    _assertEModeCollateralConfig({
      id: eModeId,
      ltv: 90_00,
      liquidationThreshold: 92_00,
      liquidationBonus: 100_00 + 4_00,
      isolated: false
    });

    address[] memory collaterals = new address[](1);
    collaterals[0] = proposal.syrupUSDG();
    assertEq(AaveV3Arbitrum.POOL.getEModeCategoryCollateralBitmap(eModeId), _toBitmap(collaterals));

    address[] memory borrowables = new address[](4);
    borrowables[0] = AaveV3ArbitrumAssets.USDCn_UNDERLYING;
    borrowables[1] = AaveV3ArbitrumAssets.USDT_UNDERLYING;
    borrowables[2] = AaveV3ArbitrumAssets.GHO_UNDERLYING;
    borrowables[3] = proposal.USDG();
    assertEq(AaveV3Arbitrum.POOL.getEModeCategoryBorrowableBitmap(eModeId), _toBitmap(borrowables));
  }

  function test_existingEModesUnchanged() public {
    EModeSnapshot[] memory before_ = _snapshotAllEModes();
    assertEq(before_.length, 10, 'Arbitrum has ten eModes before the listing');

    GovV3Helpers.executePayload(vm, address(proposal));

    for (uint256 i = 0; i < before_.length; i++) {
      _assertEModeParamsAndCollateralUnchanged(before_[i]);
      assertEq(
        AaveV3Arbitrum.POOL.getEModeCategoryBorrowableBitmap(before_[i].id),
        before_[i].borrowableBitmap,
        'borrowable bitmap should not change'
      );
    }
    assertEq(_snapshotAllEModes().length, before_.length + 1, 'only one eMode should be created');
  }

  function test_eMode_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      EMODE_LABEL,
      proposal.syrupUSDG(),
      AaveV3ArbitrumAssets.USDCn_UNDERLYING
    );
  }

  function test_syrupUSDGBorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowSyrupUSDGUser');
    uint256 supplyAmount = 1_000 *
      10 ** IERC20Metadata(AaveV3ArbitrumAssets.USDCn_UNDERLYING).decimals();
    deal(AaveV3ArbitrumAssets.USDCn_UNDERLYING, user, supplyAmount);

    vm.startPrank(user);
    IERC20(AaveV3ArbitrumAssets.USDCn_UNDERLYING).approve(
      address(AaveV3Arbitrum.POOL),
      supplyAmount
    );
    AaveV3Arbitrum.POOL.supply(AaveV3ArbitrumAssets.USDCn_UNDERLYING, supplyAmount, user, 0);

    address syrupUSDG = proposal.syrupUSDG();
    vm.expectRevert(abi.encodeWithSelector(Errors.BorrowingNotEnabled.selector));
    AaveV3Arbitrum.POOL.borrow(syrupUSDG, 1, 2, 0, user);
    vm.stopPrank();
  }

  function test_syrupUSDGBorrowInEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowSyrupUSDGInEModeUser');
    address syrupUSDG = proposal.syrupUSDG();
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(syrupUSDG).decimals();
    deal(syrupUSDG, user, supplyAmount);

    vm.startPrank(user);
    AaveV3Arbitrum.POOL.setUserEMode(_findEModeCategoryId(EMODE_LABEL));
    IERC20(syrupUSDG).approve(address(AaveV3Arbitrum.POOL), supplyAmount);
    AaveV3Arbitrum.POOL.supply(syrupUSDG, supplyAmount, user, 0);

    vm.expectRevert(abi.encodeWithSelector(Errors.NotBorrowableInEMode.selector));
    AaveV3Arbitrum.POOL.borrow(syrupUSDG, 1, 2, 0, user);
    vm.stopPrank();
  }

  function test_syrupUSDGCollateralOutsideEModeHasNoBorrowPower() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.syrupUSDG()).decimals();
    deal(proposal.syrupUSDG(), user, supplyAmount);

    vm.startPrank(user);
    IERC20(proposal.syrupUSDG()).approve(address(AaveV3Arbitrum.POOL), supplyAmount);
    AaveV3Arbitrum.POOL.supply(proposal.syrupUSDG(), supplyAmount, user, 0);

    (, , uint256 availableBorrowsBase, , uint256 ltv, ) = AaveV3Arbitrum.POOL.getUserAccountData(
      user
    );
    assertEq(ltv, 0, 'ltv should be 0 outside the eMode');
    assertEq(availableBorrowsBase, 0, 'no borrow power outside the eMode');

    vm.expectRevert(abi.encodeWithSelector(Errors.LtvValidationFailed.selector));
    AaveV3Arbitrum.POOL.borrow(AaveV3ArbitrumAssets.USDCn_UNDERLYING, 1, 2, 0, user);
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
    snap.label = AaveV3Arbitrum.POOL.getEModeCategoryLabel(id);
    snap.collateralConfig = AaveV3Arbitrum.POOL.getEModeCategoryCollateralConfig(id);
    snap.isolated = AaveV3Arbitrum.POOL.getIsEModeCategoryIsolated(id);
    snap.collateralBitmap = AaveV3Arbitrum.POOL.getEModeCategoryCollateralBitmap(id);
    snap.borrowableBitmap = AaveV3Arbitrum.POOL.getEModeCategoryBorrowableBitmap(id);
  }

  function _snapshotAllEModes() internal view returns (EModeSnapshot[] memory snaps) {
    uint256 count;
    for (uint8 i = 1; i < 255; i++) {
      if (bytes(AaveV3Arbitrum.POOL.getEModeCategoryLabel(i)).length != 0) count++;
    }
    snaps = new EModeSnapshot[](count);
    uint256 index;
    for (uint8 i = 1; i < 255; i++) {
      if (bytes(AaveV3Arbitrum.POOL.getEModeCategoryLabel(i)).length != 0) {
        snaps[index++] = _snapshotEMode(i);
      }
    }
  }

  function _assertEModeParamsAndCollateralUnchanged(EModeSnapshot memory snap) internal view {
    assertEq(AaveV3Arbitrum.POOL.getEModeCategoryLabel(snap.id), snap.label);
    _assertEModeCollateralConfig({
      id: snap.id,
      ltv: snap.collateralConfig.ltv,
      liquidationThreshold: snap.collateralConfig.liquidationThreshold,
      liquidationBonus: snap.collateralConfig.liquidationBonus,
      isolated: snap.isolated
    });
    assertEq(AaveV3Arbitrum.POOL.getEModeCategoryCollateralBitmap(snap.id), snap.collateralBitmap);
  }

  function _findEModeCategoryId(string memory label) internal view returns (uint8) {
    for (uint8 i = 1; i < 255; i++) {
      if (
        keccak256(bytes(AaveV3Arbitrum.POOL.getEModeCategoryLabel(i))) == keccak256(bytes(label))
      ) {
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
    DataTypes.CollateralConfig memory cfg = AaveV3Arbitrum.POOL.getEModeCategoryCollateralConfig(
      id
    );
    assertEq(cfg.ltv, ltv);
    assertEq(cfg.liquidationThreshold, liquidationThreshold);
    assertEq(cfg.liquidationBonus, liquidationBonus);
    assertEq(AaveV3Arbitrum.POOL.getIsEModeCategoryIsolated(id), isolated);
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3Arbitrum.POOL.getReserveData(assets[i]).id;
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

    AaveV3Arbitrum.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3Arbitrum.POOL), supplyAmount);
    AaveV3Arbitrum.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3Arbitrum.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3Arbitrum.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1);

    IERC20(borrowAsset).approve(address(AaveV3Arbitrum.POOL), borrowAmount);
    AaveV3Arbitrum.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3Arbitrum.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }
}
