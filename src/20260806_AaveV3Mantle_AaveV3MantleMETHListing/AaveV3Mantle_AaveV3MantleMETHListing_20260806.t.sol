// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Mantle, AaveV3MantleAssets} from 'aave-address-book/AaveV3Mantle.sol';
import {GovernanceV3Mantle} from 'aave-address-book/GovernanceV3Mantle.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {Errors} from 'aave-v3-origin/contracts/protocol/libraries/helpers/Errors.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Mantle_AaveV3MantleMETHListing_20260806} from './AaveV3Mantle_AaveV3MantleMETHListing_20260806.sol';

/**
 * @dev Test for AaveV3Mantle_AaveV3MantleMETHListing_20260806
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260806_AaveV3Mantle_AaveV3MantleMETHListing/AaveV3Mantle_AaveV3MantleMETHListing_20260806.t.sol -vv
 */
contract AaveV3Mantle_AaveV3MantleMETHListing_20260806_Test is ProtocolV3TestBase {
  AaveV3Mantle_AaveV3MantleMETHListing_20260806 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mantle'), 98931031);
    proposal = new AaveV3Mantle_AaveV3MantleMETHListing_20260806();
    _mockMEthPriceFeed();
    deal(proposal.mETH(), GovernanceV3Mantle.EXECUTOR_LVL_1, proposal.mETH_SEED_AMOUNT());
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Mantle_AaveV3MantleMETHListing_20260806',
      AaveV3Mantle.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Mantle.POOL, address(proposal), updatedAssets);
  }

  function test_dustBinHasmETHFunds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3Mantle.POOL.getReserveAToken(proposal.mETH());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Mantle.DUST_BIN)),
      proposal.mETH_SEED_AMOUNT()
    );
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0xcDA86A272531e8640cD7F1a92c01839911B90bb0,
        assetSymbol: 'mETH',
        priceFeed: 0x0000000000000000000000000000000000000001,
        enabledToBorrow: EngineFlags.DISABLED,
        flashloanable: EngineFlags.ENABLED,
        ltv: 0,
        liqThreshold: 0,
        liqBonus: 0,
        reserveFactor: 20_00,
        supplyCap: 5_000,
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
    GovV3Helpers.executePayload(vm, address(proposal));
    uint8 eMode_METHCorrelated = _findEModeCategoryId('mETH Correlated');
    _assertEModeCollateralConfig({
      id: eMode_METHCorrelated,
      ltv: 93_00,
      liquidationThreshold: 95_00,
      liquidationBonus: 100_00 + 1_00,
      isolated: false
    });

    address[] memory collaterals_METHCorrelated = new address[](1);
    collaterals_METHCorrelated[0] = proposal.mETH();
    assertEq(
      AaveV3Mantle.POOL.getEModeCategoryCollateralBitmap(eMode_METHCorrelated),
      _toBitmap(collaterals_METHCorrelated)
    );

    address[] memory borrowables_METHCorrelated = new address[](1);
    borrowables_METHCorrelated[0] = AaveV3MantleAssets.WETH_UNDERLYING;
    assertEq(
      AaveV3Mantle.POOL.getEModeCategoryBorrowableBitmap(eMode_METHCorrelated),
      _toBitmap(borrowables_METHCorrelated)
    );
  }

  function test_eMode_METHCorrelated_supplyAndBorrow() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    _supplyAndBorrowInEMode('mETH Correlated', proposal.mETH(), AaveV3MantleAssets.WETH_UNDERLYING);
  }

  function test_mETHBorrowWithoutEModeReverts() public {
    GovV3Helpers.executePayload(vm, address(proposal));

    address user = makeAddr('borrowWithoutEModeUser');
    uint256 supplyAmount = 1_000 * 10 ** IERC20Metadata(proposal.mETH()).decimals();
    deal(proposal.mETH(), user, supplyAmount);

    vm.startPrank(user);

    IERC20(proposal.mETH()).approve(address(AaveV3Mantle.POOL), supplyAmount);
    AaveV3Mantle.POOL.supply(proposal.mETH(), supplyAmount, user, 0);

    // LTV is 0 outside the e-mode, so the borrow must revert
    vm.expectRevert(Errors.LtvValidationFailed.selector);
    AaveV3Mantle.POOL.borrow(AaveV3MantleAssets.WETH_UNDERLYING, 1, 2, 0, user);

    vm.stopPrank();
  }

  function _findEModeCategoryId(string memory label) internal view returns (uint8) {
    for (uint8 i = 1; i < 255; i++) {
      if (keccak256(bytes(AaveV3Mantle.POOL.getEModeCategoryLabel(i))) == keccak256(bytes(label))) {
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
    DataTypes.CollateralConfig memory cfg = AaveV3Mantle.POOL.getEModeCategoryCollateralConfig(id);
    assertEq(cfg.ltv, ltv);
    assertEq(cfg.liquidationThreshold, liquidationThreshold);
    assertEq(cfg.liquidationBonus, liquidationBonus);
    assertEq(AaveV3Mantle.POOL.getIsEModeCategoryIsolated(id), isolated);
  }

  function _toBitmap(address[] memory assets) internal view returns (uint128 bitmap) {
    for (uint256 i = 0; i < assets.length; i++) {
      bitmap |= uint128(1) << AaveV3Mantle.POOL.getReserveData(assets[i]).id;
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

    AaveV3Mantle.POOL.setUserEMode(eModeId);

    IERC20(collateral).approve(address(AaveV3Mantle.POOL), supplyAmount);
    AaveV3Mantle.POOL.supply(collateral, supplyAmount, user, 0);

    uint256 borrowAmount = 10 * 10 ** IERC20Metadata(borrowAsset).decimals();
    AaveV3Mantle.POOL.borrow(borrowAsset, borrowAmount, 2, 0, user);

    address vToken = AaveV3Mantle.POOL.getReserveVariableDebtToken(borrowAsset);
    assertApproxEqAbs(IERC20(vToken).balanceOf(user), borrowAmount, 1);

    IERC20(borrowAsset).approve(address(AaveV3Mantle.POOL), borrowAmount);
    AaveV3Mantle.POOL.repay(borrowAsset, borrowAmount, 2, user);
    AaveV3Mantle.POOL.withdraw(collateral, supplyAmount / 2, user);

    vm.stopPrank();
  }

  function _mockMEthPriceFeed() internal {
    vm.mockCall(
      proposal.mETH_PRICE_FEED(),
      abi.encodeWithSignature('latestAnswer()'),
      abi.encode(int256(4_600e8))
    );
    vm.mockCall(
      proposal.mETH_PRICE_FEED(),
      abi.encodeWithSignature('decimals()'),
      abi.encode(uint8(8))
    );
    vm.mockCall(
      proposal.mETH_PRICE_FEED(),
      abi.encodeWithSignature('description()'),
      abi.encode('Capped mETH / ETH / USD (mock)')
    );
  }
}
