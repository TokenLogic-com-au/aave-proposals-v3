// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {IPriceOracleGetter} from 'aave-v3-origin/contracts/interfaces/IPriceOracleGetter.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV4EthereumAssets, AaveV4EthereumHubs, AaveV4EthereumTokenizationSpokes} from 'aave-address-book/AaveV4Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IAaveCLRobotOperator} from 'src/interfaces/IAaveCLRobotOperator.sol';
import {IFixedPriceStrategy4626} from 'src/interfaces/IFixedPriceStrategy4626.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmFeeStrategy} from 'src/interfaces/IGsmFeeStrategy.sol';
import {IGsmRegistry} from 'src/interfaces/IGsmRegistry.sol';
import {IGsmSteward} from 'src/interfaces/IGsmSteward.sol';
import {IOracleSwapFreezer} from 'src/interfaces/IOracleSwapFreezer.sol';

import {AaveV3Ethereum_MainnetGSMMigration_20261022} from './AaveV3Ethereum_MainnetGSMMigration_20261022.sol';
import {AaveV4Ethereum_MainnetGSMMigration_20261022} from './AaveV4Ethereum_MainnetGSMMigration_20261022.sol';

/**
 * @dev Test for AaveV3Ethereum_MainnetGSMMigration_20261022
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261022_Multi_MainnetGSMMigration/AaveV3Ethereum_MainnetGSMMigration_20261022.t.sol -vv
 */
contract AaveV3Ethereum_MainnetGSMMigration_20261022_Test is ProtocolV3TestBase {
  using SafeERC20 for IERC20;

  struct GsmConfig {
    uint256 sellFee;
    uint256 buyFee;
    uint256 exposureCap;
    uint256 reserveLimit;
    bool freezerCanUnfreeze;
    uint256 freezeLowerBound;
    uint256 freezeUpperBound;
    uint256 unfreezeLowerBound;
    uint256 unfreezeUpperBound;
  }

  // LINK left in the cancelled USDC keeper (funded at registration and never spent)
  uint256 internal constant KEEPER_REMAINING_LINK = 80 ether;

  AaveV4Ethereum_MainnetGSMMigration_20261022 internal v4Proposal;
  AaveV3Ethereum_MainnetGSMMigration_20261022 internal proposal;

  IGhoReserve internal constant GHO_RESERVE = IGhoReserve(GhoEthereum.GHO_RESERVE);
  IERC20 internal constant GHO = IERC20(GhoEthereum.GHO_TOKEN);
  address internal constant COLLECTOR = address(AaveV3Ethereum.COLLECTOR);
  address internal constant EXECUTOR = GovernanceV3Ethereum.EXECUTOR_LVL_1;
  address internal constant WA_CORE_USDC =
    address(AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 26494707);
    v4Proposal = new AaveV4Ethereum_MainnetGSMMigration_20261022();
    proposal = new AaveV3Ethereum_MainnetGSMMigration_20261022();

    executePayload(vm, address(v4Proposal));
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_MainnetGSMMigration_20261022',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Ethereum.POOL, address(proposal), updatedAssets);
  }

  /// --- Seize old USDC GSM ---

  function test_oldUsdcGsmFeesDistributedToTreasury() public {
    uint256 fees = IGsm(GhoEthereum.GSM_USDC).getAccruedFees();
    assertGt(fees, 0, 'no USDC GSM fees to distribute');
    assertEq(GHO.balanceOf(GhoEthereum.GSM_USDC), fees, 'USDC GSM GHO balance != fees');

    uint256 collectorGhoBefore = GHO.balanceOf(COLLECTOR);
    uint256 usedBefore = GHO_RESERVE.getUsed(GhoEthereum.GSM_USDC);

    executePayload(vm, address(proposal));

    assertEq(IGsm(GhoEthereum.GSM_USDC).getAccruedFees(), 0, 'USDC GSM fees not distributed');
    assertEq(GHO.balanceOf(GhoEthereum.GSM_USDC), 0, 'USDC GSM still holds GHO');

    // Collector receives the fees and pays the USDC GSM used GHO. Any unbooked yield is drawn from
    // the reserve as fees and restored again by burnAfterSeize, so it nets out.
    assertEq(
      GHO.balanceOf(COLLECTOR),
      collectorGhoBefore + fees - usedBefore,
      'unexpected collector GHO balance'
    );
  }

  function test_oldUsdcGsmSeized() public {
    assertFalse(IGsm(GhoEthereum.GSM_USDC).getIsSeized(), 'USDC GSM seized before');

    executePayload(vm, address(proposal));

    _assertSeized(GhoEthereum.GSM_USDC);
  }

  /// --- Grant access to new GSMs ---

  function test_newGsmRegisteredInGhoReserve() public {
    assertFalse(GHO_RESERVE.isEntity(proposal.NEW_GSM_USDC()), 'USDC GSM entity before');

    executePayload(vm, address(proposal));

    assertTrue(GHO_RESERVE.isEntity(proposal.NEW_GSM_USDC()), 'USDC GSM not an entity');
    assertEq(
      GHO_RESERVE.getLimit(proposal.NEW_GSM_USDC()),
      proposal.RESERVE_LIMIT_GSM_USDC(),
      'wrong USDC GSM limit'
    );
  }

  function test_newGsmInRegistry() public {
    assertFalse(_isInRegistry(proposal.NEW_GSM_USDC()), 'USDC GSM in registry before');

    executePayload(vm, address(proposal));

    assertTrue(_isInRegistry(proposal.NEW_GSM_USDC()), 'USDC GSM not in registry');
  }

  function test_newGsmRoles_USDC() public {
    _assertNewGsmRoles(IGsm(proposal.NEW_GSM_USDC()), proposal.NEW_USDC_ORACLE_SWAP_FREEZER());
  }

  function test_newGsmConfig_USDC() public {
    executePayload(vm, address(proposal));

    _checkGsmConfig(
      IGsm(proposal.NEW_GSM_USDC()),
      WA_CORE_USDC,
      IOracleSwapFreezer(proposal.NEW_USDC_ORACLE_SWAP_FREEZER()),
      GsmConfig({
        sellFee: 0, // 0.00%
        buyFee: 0.0015e4, // 0.15%
        exposureCap: proposal.EXPOSURE_CAP_GSM_USDC(),
        reserveLimit: proposal.RESERVE_LIMIT_GSM_USDC(),
        freezerCanUnfreeze: true,
        freezeLowerBound: 0.99e8,
        freezeUpperBound: 1.01e8,
        unfreezeLowerBound: 0.995e8,
        unfreezeUpperBound: 1.005e8
      })
    );
  }

  /// --- New GSM underlying ---

  function test_newGsmUnderlyingIsCoreUsdcTokenizationSpoke() public view {
    assertEq(
      IGsm(proposal.NEW_GSM_USDC()).UNDERLYING_ASSET(),
      address(AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE),
      'GSM underlying is not the Core USDC TokenizationSpoke'
    );
  }

  function test_coreUsdcTokenizationSpokeAssetIsUsdc() public view {
    assertEq(
      AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE.asset(),
      AaveV4EthereumAssets.USDC_UNDERLYING,
      'spoke asset is not USDC'
    );
  }

  function test_coreUsdcTokenizationSpokeHubIsCoreHub() public view {
    assertEq(
      AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE.hub(),
      address(AaveV4EthereumHubs.CORE_HUB),
      'spoke hub is not the Core Hub'
    );
    assertEq(
      AaveV4EthereumTokenizationSpokes.CORE_USDC_TOKENIZATION_SPOKE.assetId(),
      AaveV4EthereumHubs.CORE_HUB.getAssetId(AaveV4EthereumAssets.USDC_UNDERLYING),
      'spoke asset id is not USDC on the Core Hub'
    );
  }

  /// --- Update fee strategies ---

  function test_newGsmReusesOldFeeStrategy() public {
    address usdcFeeStrategy = IGsm(GhoEthereum.GSM_USDC).getFeeStrategy();
    assertEq(IGsm(proposal.NEW_GSM_USDC()).getFeeStrategy(), address(0), 'USDC fee set before');

    executePayload(vm, address(proposal));

    assertEq(
      IGsm(proposal.NEW_GSM_USDC()).getFeeStrategy(),
      usdcFeeStrategy,
      'wrong USDC fee strategy'
    );
  }

  /// --- Burn after seize ---

  function test_oldUsdcGsmUsedGhoRestored() public {
    assertGt(GHO_RESERVE.getUsed(GhoEthereum.GSM_USDC), 0, 'USDC GSM used is zero before');

    executePayload(vm, address(proposal));

    assertEq(GHO_RESERVE.getUsed(GhoEthereum.GSM_USDC), 0, 'USDC GSM used not restored');
  }

  function test_ghoSupplyUnchangedAndReserveRestored() public {
    uint256 ghoSupplyBefore = GHO.totalSupply();
    uint256 reserveBalanceBefore = GHO.balanceOf(address(GHO_RESERVE));
    uint256 usedUsdc = GHO_RESERVE.getUsed(GhoEthereum.GSM_USDC);

    executePayload(vm, address(proposal));

    assertEq(GHO.totalSupply(), ghoSupplyBefore, 'GHO supply changed');
    // Only the USDC GSM used GHO returns to the reserve
    assertEq(
      GHO.balanceOf(address(GHO_RESERVE)),
      reserveBalanceBefore + usedUsdc,
      'unexpected GhoReserve GHO balance'
    );
  }

  function test_executorHoldsNoTokensAfterExecution() public {
    executePayload(vm, address(proposal));

    assertEq(GHO.balanceOf(EXECUTOR), 0, 'executor holds GHO');
    assertEq(
      IERC20(AaveV3EthereumAssets.LINK_UNDERLYING).balanceOf(EXECUTOR),
      0,
      'executor holds LINK'
    );
  }

  /// --- New OracleSwapFreezer ---

  function test_oracleSwapFreezers_USDC() public {
    _assertOracleSwapFreezer(
      IGsm(proposal.NEW_GSM_USDC()),
      IOracleSwapFreezer(proposal.NEW_USDC_ORACLE_SWAP_FREEZER()),
      AaveV3EthereumAssets.USDC_UNDERLYING
    );
  }

  /// --- Revoke access of old USDC GSM ---

  function test_oldUsdcGsmRemovedFromGhoReserve() public {
    assertTrue(GHO_RESERVE.isEntity(GhoEthereum.GSM_USDC), 'USDC GSM not an entity before');
    uint256 totalEntitiesBefore = GHO_RESERVE.totalEntities();

    executePayload(vm, address(proposal));

    assertFalse(GHO_RESERVE.isEntity(GhoEthereum.GSM_USDC), 'USDC GSM still an entity');
    assertEq(GHO_RESERVE.getLimit(GhoEthereum.GSM_USDC), 0, 'USDC GSM limit not zero');
    // old USDC GSM removed, new USDC GSM added
    assertEq(GHO_RESERVE.totalEntities(), totalEntitiesBefore, 'wrong total entities');
  }

  function test_oldUsdcGsmRemovedFromRegistry() public {
    assertTrue(_isInRegistry(GhoEthereum.GSM_USDC), 'USDC GSM not in registry before');
    uint256 lengthBefore = IGsmRegistry(GhoEthereum.GSM_REGISTRY).getGsmListLength();

    executePayload(vm, address(proposal));

    assertFalse(_isInRegistry(GhoEthereum.GSM_USDC), 'USDC GSM still in registry');
    // old USDC GSM removed, new USDC GSM added
    assertEq(
      IGsmRegistry(GhoEthereum.GSM_REGISTRY).getGsmListLength(),
      lengthBefore,
      'wrong registry length'
    );
  }

  function test_oldUsdcGsmRolesRevoked() public {
    _assertOldGsmRolesRevoked(GhoEthereum.GSM_USDC, GhoEthereum.GSM_USDC_ORACLE_SWAP_FREEZER);
  }

  /// --- Old USDT GSM untouched ---

  function test_oldUsdtGsmUntouched() public {
    IGsm gsm = IGsm(GhoEthereum.GSM_USDT);
    IERC20 stataUsdt = IERC20(AaveV3EthereumAssets.USDT_STATA_TOKEN);
    uint256 exposureCapBefore = gsm.getExposureCap();
    uint256 exposureBefore = gsm.getAvailableLiquidity();
    uint256 stataBefore = stataUsdt.balanceOf(address(gsm));
    uint256 usedBefore = GHO_RESERVE.getUsed(address(gsm));
    uint256 limitBefore = GHO_RESERVE.getLimit(address(gsm));
    uint256 feesBefore = gsm.getAccruedFees();
    address feeStrategyBefore = gsm.getFeeStrategy();
    assertGt(exposureBefore, 0, 'USDT GSM empty before');

    executePayload(vm, address(proposal));

    assertFalse(gsm.getIsSeized(), 'USDT GSM seized');
    assertFalse(gsm.getIsFrozen(), 'USDT GSM frozen');
    assertEq(gsm.getExposureCap(), exposureCapBefore, 'USDT GSM exposure cap changed');
    assertEq(gsm.getAvailableLiquidity(), exposureBefore, 'USDT GSM exposure changed');
    assertEq(stataUsdt.balanceOf(address(gsm)), stataBefore, 'stataUSDT moved');
    assertEq(gsm.getAccruedFees(), feesBefore, 'USDT GSM fees changed');
    assertEq(gsm.getFeeStrategy(), feeStrategyBefore, 'USDT GSM fee strategy changed');
    assertTrue(GHO_RESERVE.isEntity(address(gsm)), 'USDT GSM removed from reserve');
    assertEq(GHO_RESERVE.getUsed(address(gsm)), usedBefore, 'USDT GSM used changed');
    assertEq(GHO_RESERVE.getLimit(address(gsm)), limitBefore, 'USDT GSM limit changed');
    assertTrue(_isInRegistry(address(gsm)), 'USDT GSM removed from registry');
  }

  function test_oldUsdtGsmRolesKept() public {
    IGsm gsm = IGsm(GhoEthereum.GSM_USDT);
    bytes32 swapFreezerRole = proposal.SWAP_FREEZER_ROLE();
    bytes32 configuratorRole = proposal.CONFIGURATOR_ROLE();

    executePayload(vm, address(proposal));

    assertTrue(
      gsm.hasRole(swapFreezerRole, GhoEthereum.GSM_USDT_ORACLE_SWAP_FREEZER),
      'freezer role revoked'
    );
    assertTrue(gsm.hasRole(swapFreezerRole, EXECUTOR), 'executor freezer role revoked');
    assertTrue(gsm.hasRole(configuratorRole, GhoEthereum.GHO_GSM_STEWARD), 'steward role revoked');
    assertTrue(gsm.hasRole(configuratorRole, EXECUTOR), 'executor configurator role revoked');
    assertFalse(gsm.hasRole(proposal.LIQUIDATOR_ROLE(), EXECUTOR), 'executor is liquidator');
  }

  function test_oldUsdcOracleSwapFreezerKeeperLinkWithdrawn() public {
    IAaveCLRobotOperator operator = IAaveCLRobotOperator(MiscEthereum.AAVE_CL_ROBOT_OPERATOR);
    IERC20 link = IERC20(AaveV3EthereumAssets.LINK_UNDERLYING);
    assertEq(
      _keeperIdOf(GhoEthereum.GSM_USDC_ORACLE_SWAP_FREEZER),
      proposal.EXISTING_ORACLE_SWAP_FREEZER_USDC(),
      'wrong existing USDC keeper id'
    );
    uint256 collectorLinkBefore = link.balanceOf(COLLECTOR);

    executePayload(vm, address(proposal));

    assertEq(
      link.balanceOf(COLLECTOR),
      collectorLinkBefore + KEEPER_REMAINING_LINK,
      'keeper LINK not withdrawn to the collector'
    );

    operator.withdrawLink(proposal.EXISTING_ORACLE_SWAP_FREEZER_USDC());
    assertEq(
      link.balanceOf(COLLECTOR),
      collectorLinkBefore + KEEPER_REMAINING_LINK,
      'keeper still holds LINK'
    );
  }

  /// --- Post-execution behaviour ---

  function test_oldUsdcGsmUnusable() public {
    executePayload(vm, address(proposal));

    vm.expectRevert(bytes('GSM_SEIZED'));
    IGsm(GhoEthereum.GSM_USDC).buyAsset(1e6, address(this));
    vm.expectRevert(bytes('GSM_SEIZED'));
    IGsm(GhoEthereum.GSM_USDC).sellAsset(1e6, address(this));
  }

  function test_newGsmOperational_USDC() public {
    _assertNewGsmOperational(
      IGsm(proposal.NEW_GSM_USDC()),
      AaveV3EthereumAssets.USDC_UNDERLYING,
      100_000e6
    );
  }

  function test_ghoGsmStewardCanUpdateExposureCap_USDC() public {
    _assertStewardCanUpdateExposureCap(IGsm(proposal.NEW_GSM_USDC()));
  }

  function test_ghoGsmStewardCanUpdateFees_USDC() public {
    _assertStewardCanUpdateFees(IGsm(proposal.NEW_GSM_USDC()));
  }

  /// --- Helpers ---

  function _assertSeized(address gsm) internal view {
    assertTrue(IGsm(gsm).getIsSeized(), 'GSM not seized');
    assertEq(IGsm(gsm).getExposureCap(), 0, 'seized GSM exposure cap not zero');
    assertEq(IGsm(gsm).getAvailableLiquidity(), 0, 'seized GSM exposure not zero');
    assertEq(
      IERC20(IGsm(gsm).UNDERLYING_ASSET()).balanceOf(gsm),
      0,
      'seized GSM still holds underlying'
    );
  }

  function _assertNewGsmRoles(IGsm gsm, address freezer) internal {
    assertFalse(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), freezer), 'freezer role before');
    assertFalse(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), EXECUTOR), 'executor freezer role before');
    assertFalse(
      gsm.hasRole(gsm.CONFIGURATOR_ROLE(), GhoEthereum.GHO_GSM_STEWARD),
      'steward role before'
    );

    executePayload(vm, address(proposal));

    assertTrue(gsm.hasRole(bytes32(0), EXECUTOR), 'executor is not admin');
    assertTrue(gsm.hasRole(gsm.CONFIGURATOR_ROLE(), EXECUTOR), 'executor is not configurator');
    assertTrue(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), EXECUTOR), 'executor is not swap freezer');
    assertTrue(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), freezer), 'freezer is not swap freezer');
    assertTrue(
      gsm.hasRole(gsm.CONFIGURATOR_ROLE(), GhoEthereum.GHO_GSM_STEWARD),
      'steward is not configurator'
    );
    assertFalse(gsm.hasRole(gsm.LIQUIDATOR_ROLE(), EXECUTOR), 'executor is liquidator');
    assertFalse(gsm.hasRole(gsm.TOKEN_RESCUER_ROLE(), EXECUTOR), 'executor is token rescuer');
  }

  function _checkGsmConfig(
    IGsm gsm,
    address underlying,
    IOracleSwapFreezer freezer,
    GsmConfig memory config
  ) internal view {
    assertEq(gsm.UNDERLYING_ASSET(), underlying, 'wrong underlying asset');
    assertEq(gsm.GHO_TOKEN(), address(GHO), 'wrong GHO token');
    assertEq(gsm.getGhoReserve(), address(GHO_RESERVE), 'wrong GHO reserve');
    assertEq(gsm.getGhoTreasury(), COLLECTOR, 'wrong GHO treasury');
    assertEq(gsm.getExposureCap(), config.exposureCap, 'wrong exposure cap');
    assertEq(GHO_RESERVE.getLimit(address(gsm)), config.reserveLimit, 'wrong reserve limit');
    assertFalse(gsm.getIsFrozen(), 'GSM frozen');
    assertFalse(gsm.getIsSeized(), 'GSM seized');

    IGsmFeeStrategy feeStrategy = IGsmFeeStrategy(gsm.getFeeStrategy());
    assertEq(feeStrategy.getSellFee(1e4), config.sellFee, 'wrong sell fee');
    assertEq(feeStrategy.getBuyFee(1e4), config.buyFee, 'wrong buy fee');

    // Price Strategy: 1:1 against the ERC-4626 share value
    IFixedPriceStrategy4626 priceStrategy = IFixedPriceStrategy4626(gsm.PRICE_STRATEGY());
    assertEq(
      priceStrategy.getAssetPriceInGho(1e6, true),
      IERC4626(underlying).previewMint(1e6) * 1e12,
      'wrong asset price in GHO (round up)'
    );
    assertEq(
      priceStrategy.getAssetPriceInGho(1e6, false),
      IERC4626(underlying).convertToAssets(1e6) * 1e12,
      'wrong asset price in GHO (round down)'
    );
    assertEq(
      priceStrategy.getGhoPriceInAsset(1 ether, true),
      IERC4626(underlying).previewWithdraw(1e6),
      'wrong GHO price in asset (round up)'
    );
    assertEq(
      priceStrategy.getGhoPriceInAsset(1 ether, false),
      IERC4626(underlying).convertToShares(1e6),
      'wrong GHO price in asset (round down)'
    );

    assertEq(freezer.GSM(), address(gsm), 'wrong freezer GSM');
    assertEq(
      freezer.ADDRESS_PROVIDER(),
      address(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER),
      'wrong freezer address provider'
    );
    assertEq(freezer.getCanUnfreeze(), config.freezerCanUnfreeze, 'wrong freezer unfreeze flag');
    (uint256 lowerBound, uint256 upperBound) = freezer.getFreezeBound();
    assertEq(lowerBound, config.freezeLowerBound, 'wrong freeze lower bound');
    assertEq(upperBound, config.freezeUpperBound, 'wrong freeze upper bound');
    (lowerBound, upperBound) = freezer.getUnfreezeBound();
    assertEq(lowerBound, config.unfreezeLowerBound, 'wrong unfreeze lower bound');
    assertEq(upperBound, config.unfreezeUpperBound, 'wrong unfreeze upper bound');
  }

  function _assertOracleSwapFreezer(
    IGsm gsm,
    IOracleSwapFreezer freezer,
    address oracleAsset
  ) internal {
    (uint128 freezeLowerBound, ) = freezer.getFreezeBound();
    (uint128 unfreezeLowerBound, ) = freezer.getUnfreezeBound();
    _mockAssetPrice(oracleAsset, freezeLowerBound - 1);

    (bool canPerformUpkeep, ) = freezer.checkUpkeep('');
    assertFalse(canPerformUpkeep, 'freezer can act before execution');

    executePayload(vm, address(proposal));

    (canPerformUpkeep, ) = freezer.checkUpkeep('');
    assertTrue(canPerformUpkeep, 'freezer cannot freeze on depeg');
    freezer.performUpkeep('');
    assertTrue(gsm.getIsFrozen(), 'GSM not frozen on depeg');

    _mockAssetPrice(oracleAsset, unfreezeLowerBound + 1);
    (canPerformUpkeep, ) = freezer.checkUpkeep('');
    assertTrue(canPerformUpkeep, 'freezer cannot unfreeze on repeg');
    freezer.performUpkeep('');
    assertFalse(gsm.getIsFrozen(), 'GSM not unfrozen on repeg');
  }

  function _assertOldGsmRolesRevoked(address gsm, address oldFreezer) internal {
    bytes32 swapFreezerRole = proposal.SWAP_FREEZER_ROLE();
    bytes32 configuratorRole = proposal.CONFIGURATOR_ROLE();
    assertTrue(IGsm(gsm).hasRole(swapFreezerRole, oldFreezer), 'freezer role missing before');
    assertTrue(IGsm(gsm).hasRole(swapFreezerRole, EXECUTOR), 'executor freezer missing before');
    assertTrue(
      IGsm(gsm).hasRole(configuratorRole, GhoEthereum.GHO_GSM_STEWARD),
      'steward role missing before'
    );

    executePayload(vm, address(proposal));

    assertFalse(IGsm(gsm).hasRole(swapFreezerRole, oldFreezer), 'freezer role not revoked');
    assertFalse(IGsm(gsm).hasRole(swapFreezerRole, EXECUTOR), 'executor freezer not revoked');
    assertFalse(
      IGsm(gsm).hasRole(proposal.LIQUIDATOR_ROLE(), EXECUTOR),
      'executor liquidator not revoked'
    );
    assertFalse(
      IGsm(gsm).hasRole(configuratorRole, GhoEthereum.GHO_GSM_STEWARD),
      'steward role not revoked'
    );
  }

  function _assertNewGsmOperational(IGsm gsm, address asset, uint256 assetAmount) internal {
    executePayload(vm, address(proposal));

    address share = gsm.UNDERLYING_ASSET();
    deal(asset, address(this), assetAmount);
    IERC20(asset).forceApprove(share, assetAmount);
    uint256 shares = IERC4626(share).deposit(assetAmount, address(this));

    uint256 gsmSharesBefore = IERC20(share).balanceOf(address(gsm));
    uint256 usedBefore = GHO_RESERVE.getUsed(address(gsm));

    // Sell: shares in, GHO out at the share value minus the sell fee
    uint256 grossGho = IERC4626(share).previewRedeem(shares) * 1e12;
    uint256 sellFee = IGsmFeeStrategy(gsm.getFeeStrategy()).getSellFee(grossGho);
    IERC20(share).forceApprove(address(gsm), shares);
    (uint256 sharesSold, uint256 ghoBought) = gsm.sellAsset(shares, address(this));
    assertEq(sharesSold, shares, 'not all shares sold');
    assertEq(ghoBought, grossGho - sellFee, 'wrong GHO bought');
    assertEq(GHO.balanceOf(address(this)), ghoBought, 'GHO not received');
    assertEq(IERC20(share).balanceOf(address(gsm)), gsmSharesBefore + shares, 'shares not in GSM');
    assertEq(GHO_RESERVE.getUsed(address(gsm)), usedBefore + grossGho, 'GSM used not increased');

    uint256 sharesToBuy = shares / 2;
    (, uint256 ghoNeeded, , uint256 fee) = gsm.getGhoAmountForBuyAsset(sharesToBuy);
    assertGt(fee, 0, 'no buy fee charged');
    GHO.approve(address(gsm), ghoNeeded);
    (uint256 sharesBought, uint256 ghoSold) = gsm.buyAsset(sharesToBuy, address(this));
    assertEq(sharesBought, sharesToBuy, 'wrong shares bought');
    assertEq(ghoSold, ghoNeeded, 'wrong GHO sold');
    assertEq(IERC20(share).balanceOf(address(this)), sharesToBuy, 'shares not received');
    assertEq(GHO.balanceOf(address(this)), ghoBought - ghoSold, 'GHO not paid');
  }

  function _assertStewardCanUpdateExposureCap(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    uint128 newExposureCap = gsm.getExposureCap() + 1;
    vm.prank(GhoEthereum.RISK_COUNCIL);
    IGsmSteward(GhoEthereum.GHO_GSM_STEWARD).updateGsmExposureCap(address(gsm), newExposureCap);
    assertEq(gsm.getExposureCap(), newExposureCap, 'steward could not update exposure cap');
  }

  function _assertStewardCanUpdateFees(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    IGsmFeeStrategy feeStrategy = IGsmFeeStrategy(gsm.getFeeStrategy());
    uint256 buyFee = feeStrategy.getBuyFee(1e4);
    uint256 sellFee = feeStrategy.getSellFee(1e4);

    vm.prank(GhoEthereum.RISK_COUNCIL);
    IGsmSteward(GhoEthereum.GHO_GSM_STEWARD).updateGsmBuySellFees(
      address(gsm),
      buyFee + 1,
      sellFee
    );
    assertEq(
      IGsmFeeStrategy(gsm.getFeeStrategy()).getBuyFee(1e4),
      buyFee + 1,
      'steward could not update fees'
    );
  }

  function _isInRegistry(address gsm) internal returns (bool) {
    IGsmRegistry registry = IGsmRegistry(GhoEthereum.GSM_REGISTRY);
    uint256 length = registry.getGsmListLength();
    for (uint256 i; i < length; ++i) {
      if (registry.getGsmAtIndex(i) == gsm) return true;
    }
    return false;
  }

  /// @dev returns the active robot operator keeper id of an upkeep contract, 0 if none
  function _keeperIdOf(address upkeep) internal view returns (uint256) {
    IAaveCLRobotOperator operator = IAaveCLRobotOperator(MiscEthereum.AAVE_CL_ROBOT_OPERATOR);
    uint256[] memory ids = operator.getKeepersList();
    for (uint256 i; i < ids.length; ++i) {
      if (operator.getKeeperInfo(ids[i]).upkeep == upkeep) return ids[i];
    }
    return 0;
  }

  function _mockAssetPrice(address asset, uint256 price) internal {
    vm.mockCall(
      address(AaveV3Ethereum.ORACLE),
      abi.encodeWithSelector(IPriceOracleGetter.getAssetPrice.selector, asset),
      abi.encode(price)
    );
  }
}
