// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovernanceV3Plasma} from 'aave-address-book/GovernanceV3Plasma.sol';
import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022} from './AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022.sol';
import {IPendlePriceCapAdapter} from '../interfaces/IPendlePriceCapAdapter.sol';

/**
 * @dev Test for AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261022_AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma/AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022.t.sol -vv
 */
contract AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022_Test is ProtocolV3TestBase {
  struct EModeSnapshot {
    string label;
    DataTypes.CollateralConfig collateralConfig;
    bool isolated;
    uint128 collateralBitmap;
    uint128 borrowableBitmap;
  }

  AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('plasma'), 35734145);
    proposal = new AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022();
  }

  function test_executorIsPrefunded() public view {
    assertGe(
      IERC20(proposal.PT_sUSDE_28JAN2027()).balanceOf(GovernanceV3Plasma.EXECUTOR_LVL_1),
      proposal.PT_sUSDE_28JAN2027_SEED_AMOUNT(),
      'executor should hold the seed amount before execution'
    );
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022',
      AaveV3Plasma.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Plasma.POOL, address(proposal), updatedAssets);
  }

  function test_dustBinHasPT_sUSDE_28JAN2027Funds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3Plasma.POOL.getReserveAToken(proposal.PT_sUSDE_28JAN2027());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Plasma.DUST_BIN)),
      proposal.PT_sUSDE_28JAN2027_SEED_AMOUNT(),
      'DustBin should hold at least the seed amount'
    );
  }

  /**
   * @dev PENDING ORACLE: the price feed, the discount rates and the price band below are
   * placeholders until the adapter is deployed and LlamaRisk sets the final rates
   */
  function test_pendingOracle_priceFeedWiring() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    assertEq(
      AaveV3Plasma.ORACLE.getSourceOfAsset(proposal.PT_sUSDE_28JAN2027()),
      proposal.PT_sUSDE_28JAN2027_PRICE_FEED(),
      'PT-sUSDe should be priced by the configured linear discount oracle'
    );
    uint256 price = AaveV3Plasma.ORACLE.getAssetPrice(proposal.PT_sUSDE_28JAN2027());
    assertGt(price, 0.97e8, 'PT-sUSDe price should be within a sane discount band');
    assertLt(price, 1e8, 'PT-sUSDe should price below par (1 USD) before maturity');

    IPendlePriceCapAdapter adapter = IPendlePriceCapAdapter(
      proposal.PT_sUSDE_28JAN2027_PRICE_FEED()
    );
    assertEq(adapter.discountRatePerYear(), 0.0437e18, 'initial discount rate placeholder');
    assertEq(adapter.MAX_DISCOUNT_RATE_PER_YEAR(), 0.1227e18, 'max discount rate placeholder');
    assertEq(adapter.MATURITY(), 1801094400, 'maturity should be 28 January 2027 UTC');
    assertEq(
      adapter.PENDLE_PRINCIPAL_TOKEN(),
      proposal.PT_sUSDE_28JAN2027(),
      'oracle should price the listed PT'
    );
    assertEq(
      adapter.ASSET_TO_USD_AGGREGATOR(),
      AaveV3PlasmaAssets.USDT0_ORACLE,
      'underlying aggregator should be the Capped USDT0/USD feed'
    );
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0x257561233419039BeC3a28be717d14B4f490883D,
        assetSymbol: 'PT-sUSDE-28JAN2027',
        priceFeed: 0x0000000000000000000000000000000000000000,
        enabledToBorrow: EngineFlags.DISABLED,
        flashloanable: EngineFlags.DISABLED,
        ltv: 0,
        liqThreshold: 0,
        liqBonus: 0,
        reserveFactor: 45_00,
        supplyCap: 150_000_000,
        borrowCap: 1,
        liqProtocolFee: 10_00,
        rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
          optimalUsageRatio: 45_00,
          baseVariableBorrowRate: 0,
          variableRateSlope1: 10_00,
          variableRateSlope2: 300_00
        })
      }),
      decimals: 18
    });
  }

  function test_eModeConfiguration() public {
    EModeSnapshot[] memory before_ = _snapshotEModes();

    GovV3Helpers.executePayload(vm, address(proposal));
    uint8 eMode_SUSDe_PT_sUSDe_28JAN2027__Stablecoins = _findEModeCategoryId(
      'sUSDe_PT_sUSDe_28JAN2027__Stablecoins'
    );
    _assertEModeCollateralConfig({
      id: eMode_SUSDe_PT_sUSDe_28JAN2027__Stablecoins,
      ltv: 87_71,
      liquidationThreshold: 89_71,
      liquidationBonus: 100_00 + 4_87,
      isolated: true
    });

    address[] memory collaterals_SUSDe_PT_sUSDe_28JAN2027__Stablecoins = new address[](2);
    collaterals_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[0] = AaveV3PlasmaAssets.sUSDe_UNDERLYING;
    collaterals_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[1] = proposal.PT_sUSDE_28JAN2027();
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryCollateralBitmap(
        eMode_SUSDe_PT_sUSDe_28JAN2027__Stablecoins
      ),
      _toBitmap(collaterals_SUSDe_PT_sUSDe_28JAN2027__Stablecoins)
    );

    address[] memory borrowables_SUSDe_PT_sUSDe_28JAN2027__Stablecoins = new address[](3);
    borrowables_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[0] = AaveV3PlasmaAssets.USDT0_UNDERLYING;
    borrowables_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[1] = AaveV3PlasmaAssets.USDe_UNDERLYING;
    borrowables_SUSDe_PT_sUSDe_28JAN2027__Stablecoins[2] = AaveV3PlasmaAssets.GHO_UNDERLYING;
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryBorrowableBitmap(
        eMode_SUSDe_PT_sUSDe_28JAN2027__Stablecoins
      ),
      _toBitmap(borrowables_SUSDe_PT_sUSDe_28JAN2027__Stablecoins)
    );

    uint8 eMode_SUSDe_PT_sUSDe_28JAN2027__USDe = _findEModeCategoryId(
      'sUSDe_PT_sUSDe_28JAN2027__USDe'
    );
    _assertEModeCollateralConfig({
      id: eMode_SUSDe_PT_sUSDe_28JAN2027__USDe,
      ltv: 90_35,
      liquidationThreshold: 92_35,
      liquidationBonus: 100_00 + 1_87,
      isolated: true
    });

    address[] memory collaterals_SUSDe_PT_sUSDe_28JAN2027__USDe = new address[](2);
    collaterals_SUSDe_PT_sUSDe_28JAN2027__USDe[0] = AaveV3PlasmaAssets.sUSDe_UNDERLYING;
    collaterals_SUSDe_PT_sUSDe_28JAN2027__USDe[1] = proposal.PT_sUSDE_28JAN2027();
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryCollateralBitmap(eMode_SUSDe_PT_sUSDe_28JAN2027__USDe),
      _toBitmap(collaterals_SUSDe_PT_sUSDe_28JAN2027__USDe)
    );

    address[] memory borrowables_SUSDe_PT_sUSDe_28JAN2027__USDe = new address[](1);
    borrowables_SUSDe_PT_sUSDe_28JAN2027__USDe[0] = AaveV3PlasmaAssets.USDe_UNDERLYING;
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryBorrowableBitmap(eMode_SUSDe_PT_sUSDe_28JAN2027__USDe),
      _toBitmap(borrowables_SUSDe_PT_sUSDe_28JAN2027__USDe)
    );

    for (uint8 i = 0; i < before_.length; i++) {
      _assertEModeUnchanged(i + 1, before_[i]);
    }
  }

  function test_eMode_SUSDe_PT_sUSDe_28JAN2027__Stablecoins_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'sUSDe_PT_sUSDe_28JAN2027__Stablecoins',
      AaveV3PlasmaAssets.sUSDe_UNDERLYING,
      AaveV3PlasmaAssets.USDT0_UNDERLYING
    );
  }

  function test_eMode_SUSDe_PT_sUSDe_28JAN2027__USDe_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'sUSDe_PT_sUSDe_28JAN2027__USDe',
      AaveV3PlasmaAssets.sUSDe_UNDERLYING,
      AaveV3PlasmaAssets.USDe_UNDERLYING
    );
  }

  function test_eMode_PT_sUSDe_28JAN2027__Stablecoins_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'sUSDe_PT_sUSDe_28JAN2027__Stablecoins',
      proposal.PT_sUSDE_28JAN2027(),
      AaveV3PlasmaAssets.USDT0_UNDERLYING
    );
  }

  function test_eMode_PT_sUSDe_28JAN2027__USDe_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode(
      'sUSDe_PT_sUSDe_28JAN2027__USDe',
      proposal.PT_sUSDE_28JAN2027(),
      AaveV3PlasmaAssets.USDe_UNDERLYING
    );
  }

  function test_PT_sUSDE_28JAN2027BorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.PT_sUSDE_28JAN2027()).decimals();
    deal(proposal.PT_sUSDE_28JAN2027(), user, supplyAmount);

    vm.startPrank(user);

    IERC20(proposal.PT_sUSDE_28JAN2027()).approve(address(AaveV3Plasma.POOL), supplyAmount);
    AaveV3Plasma.POOL.supply(proposal.PT_sUSDE_28JAN2027(), supplyAmount, user, 0);

    // LTV is 0 outside the e-mode, so the borrow must revert
    vm.expectRevert(abi.encodeWithSelector(Errors.LtvValidationFailed.selector));
    AaveV3Plasma.POOL.borrow(AaveV3PlasmaAssets.USDT0_UNDERLYING, 1, 2, 0, user);

    vm.stopPrank();
  }

  function _snapshotEModes() internal view returns (EModeSnapshot[] memory snaps) {
    uint8 count;
    while (bytes(AaveV3Plasma.POOL.getEModeCategoryLabel(count + 1)).length != 0) count++;
    snaps = new EModeSnapshot[](count);
    for (uint8 i = 0; i < count; i++) {
      uint8 id = i + 1;
      snaps[i] = EModeSnapshot({
        label: AaveV3Plasma.POOL.getEModeCategoryLabel(id),
        collateralConfig: AaveV3Plasma.POOL.getEModeCategoryCollateralConfig(id),
        isolated: AaveV3Plasma.POOL.getIsEModeCategoryIsolated(id),
        collateralBitmap: AaveV3Plasma.POOL.getEModeCategoryCollateralBitmap(id),
        borrowableBitmap: AaveV3Plasma.POOL.getEModeCategoryBorrowableBitmap(id)
      });
    }
  }

  function _assertEModeUnchanged(uint8 id, EModeSnapshot memory snap) internal view {
    DataTypes.CollateralConfig memory cfg = AaveV3Plasma.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(AaveV3Plasma.POOL.getEModeCategoryLabel(id), snap.label, 'existing eMode label');
    assertEq(cfg.ltv, snap.collateralConfig.ltv, 'existing eMode ltv changed');
    assertEq(
      cfg.liquidationThreshold,
      snap.collateralConfig.liquidationThreshold,
      'existing eMode liquidation threshold changed'
    );
    assertEq(
      cfg.liquidationBonus,
      snap.collateralConfig.liquidationBonus,
      'existing eMode liquidation bonus changed'
    );
    assertEq(AaveV3Plasma.POOL.getIsEModeCategoryIsolated(id), snap.isolated, 'isolated changed');
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryCollateralBitmap(id),
      snap.collateralBitmap,
      'existing eMode collateral bitmap changed'
    );
    assertEq(
      AaveV3Plasma.POOL.getEModeCategoryBorrowableBitmap(id),
      snap.borrowableBitmap,
      'existing eMode borrowable bitmap changed'
    );
  }

  function _findEModeCategoryId(string memory label) internal view returns (uint8) {
    for (uint8 i = 1; i < 255; i++) {
      if (keccak256(bytes(AaveV3Plasma.POOL.getEModeCategoryLabel(i))) == keccak256(bytes(label))) {
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
    DataTypes.CollateralConfig memory cfg = AaveV3Plasma.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(cfg.ltv, ltv);
    assertEq(cfg.liquidationThreshold, liquidationThreshold);
    assertEq(cfg.liquidationBonus, liquidationBonus);
    assertEq(AaveV3Plasma.POOL.getIsEModeCategoryIsolated(id), isolated);
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3Plasma.POOL.getReserveData(assets[i]).id;
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

    AaveV3Plasma.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3Plasma.POOL), supplyAmount);
    AaveV3Plasma.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3Plasma.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3Plasma.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1);

    IERC20(borrowAsset).approve(address(AaveV3Plasma.POOL), borrowAmount);
    AaveV3Plasma.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3Plasma.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }
}
