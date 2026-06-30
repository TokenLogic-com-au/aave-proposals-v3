// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle, AaveV3MantleAssets} from 'aave-address-book/AaveV3Mantle.sol';
import {GovernanceV3Mantle} from 'aave-address-book/GovernanceV3Mantle.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {EModeConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/EModeConfiguration.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611} from './AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611.sol';

/**
 * @dev Test for AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260611_AaveV3Mantle_MantleXAUtListingAndEModeExpansion/AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611.t.sol -vv
 */
contract AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611_Test is ProtocolV3TestBase {
  uint8 internal constant XAUT_STABLECOINS_EMODE_ID = 6;
  uint8 internal constant WETH_STABLECOINS_EMODE_ID = 7;
  uint8 internal constant WMNT_STABLECOINS_EMODE_ID = 8;

  AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mantle'), 96533222);
    proposal = new AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611();
    _mockXAUtPriceFeed();
    deal(proposal.XAUt(), GovernanceV3Mantle.EXECUTOR_LVL_1, proposal.XAUt_SEED_AMOUNT());
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611',
      AaveV3Mantle.POOL,
      address(proposal),
      false,
      false
    );
  }

  function test_dustBinHasXAUtFunds() public {
    executePayload(vm, address(proposal));
    address aXAUt = AaveV3Mantle.POOL.getReserveAToken(proposal.XAUt());
    assertGe(IERC20(aXAUt).balanceOf(AaveV3Mantle.DUST_BIN), proposal.XAUt_SEED_AMOUNT());
  }

  function test_wethAndWmntCollateralUpdates() public {
    executePayload(vm, address(proposal));

    ReserveConfig[] memory configs = _getReservesConfigs(AaveV3Mantle.POOL);
    ReserveConfig memory wethConfig = _findReserveConfig(
      configs,
      AaveV3MantleAssets.WETH_UNDERLYING
    );
    ReserveConfig memory wmntConfig = _findReserveConfig(
      configs,
      AaveV3MantleAssets.WMNT_UNDERLYING
    );

    assertEq(wethConfig.ltv, 78_00);
    assertEq(wethConfig.liquidationThreshold, 80_00);
    assertEq(wmntConfig.ltv, 0);
    assertEq(wmntConfig.liquidationThreshold, 45_00);
  }

  function test_eModeCategoriesCreated() public {
    executePayload(vm, address(proposal));

    _assertEModeCategory(
      XAUT_STABLECOINS_EMODE_ID,
      70_00,
      75_00,
      106_00,
      'XAUt Stablecoins',
      proposal.XAUt()
    );
    _assertEModeCategory(
      WETH_STABLECOINS_EMODE_ID,
      80_50,
      83_00,
      105_50,
      'WETH Stablecoins',
      AaveV3MantleAssets.WETH_UNDERLYING
    );
    _assertEModeCategory(
      WMNT_STABLECOINS_EMODE_ID,
      40_00,
      45_00,
      110_00,
      'WMNT Stablecoins',
      AaveV3MantleAssets.WMNT_UNDERLYING
    );
  }

  function test_xautEModeBorrowFlow() public {
    executePayload(vm, address(proposal));

    address user = makeAddr('xautStaker');
    uint256 supplyAmount = 10e6; // 10 XAUt
    deal(proposal.XAUt(), user, supplyAmount);

    vm.startPrank(user);
    IERC20(proposal.XAUt()).approve(address(AaveV3Mantle.POOL), supplyAmount);
    AaveV3Mantle.POOL.supply(proposal.XAUt(), supplyAmount, user, 0);
    AaveV3Mantle.POOL.setUserEMode(XAUT_STABLECOINS_EMODE_ID);
    AaveV3Mantle.POOL.setUserUseReserveAsCollateral(proposal.XAUt(), true);
    AaveV3Mantle.POOL.borrow(AaveV3MantleAssets.USDT0_UNDERLYING, 100e6, 2, 0, user);
    vm.stopPrank();

    assertEq(IERC20(AaveV3MantleAssets.USDT0_UNDERLYING).balanceOf(user), 100e6);
  }

  function _assertEModeCategory(
    uint8 categoryId,
    uint16 expectedLtv,
    uint16 expectedLiqThreshold,
    uint16 expectedLiqBonus,
    string memory expectedLabel,
    address expectedCollateral
  ) internal view {
    DataTypes.CollateralConfig memory config = AaveV3Mantle.POOL.getEModeCategoryCollateralConfig(
      categoryId
    );
    assertEq(config.ltv, expectedLtv);
    assertEq(config.liquidationThreshold, expectedLiqThreshold);
    assertEq(config.liquidationBonus, expectedLiqBonus);
    assertEq(AaveV3Mantle.POOL.getEModeCategoryLabel(categoryId), expectedLabel);

    uint128 collateralBitmap = AaveV3Mantle.POOL.getEModeCategoryCollateralBitmap(categoryId);
    uint128 borrowableBitmap = AaveV3Mantle.POOL.getEModeCategoryBorrowableBitmap(categoryId);

    assertTrue(
      EModeConfiguration.isReserveEnabledOnBitmap(
        collateralBitmap,
        AaveV3Mantle.POOL.getReserveData(expectedCollateral).id
      )
    );
    assertTrue(
      EModeConfiguration.isReserveEnabledOnBitmap(
        borrowableBitmap,
        AaveV3Mantle.POOL.getReserveData(AaveV3MantleAssets.USDT0_UNDERLYING).id
      )
    );
    assertTrue(
      EModeConfiguration.isReserveEnabledOnBitmap(
        borrowableBitmap,
        AaveV3Mantle.POOL.getReserveData(AaveV3MantleAssets.USDC_UNDERLYING).id
      )
    );
    assertTrue(
      EModeConfiguration.isReserveEnabledOnBitmap(
        borrowableBitmap,
        AaveV3Mantle.POOL.getReserveData(AaveV3MantleAssets.GHO_UNDERLYING).id
      )
    );
  }

  function _mockXAUtPriceFeed() internal {
    vm.mockCall(
      proposal.XAUt_PRICE_FEED(),
      abi.encodeWithSignature('latestAnswer()'),
      abi.encode(int256(3_000e8))
    );
    vm.mockCall(
      proposal.XAUt_PRICE_FEED(),
      abi.encodeWithSignature('decimals()'),
      abi.encode(uint8(8))
    );
    vm.mockCall(
      proposal.XAUt_PRICE_FEED(),
      abi.encodeWithSignature('description()'),
      abi.encode('XAUt / USD (mock)')
    );
  }
}
