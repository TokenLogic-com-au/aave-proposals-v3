// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IAaveOracle} from 'aave-address-book/AaveV2.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmFeeStrategy} from 'src/interfaces/IGsmFeeStrategy.sol';
import {IGsmSteward} from 'src/interfaces/IGsmSteward.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';

import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';

/**
 * @dev Test for AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260512_Multi_RemoteGSMLaunchArbitrum/AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2.t.sol -vv
 *
 * Note: many tests are gated with `vm.skip(...)` on address(0) placeholders until
 * the GSM/Reserve/Steward/Registry/FeeStrategy/Freezer contracts are deployed on Arbitrum.
 */
contract AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1 internal part1;
  AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 462142700);
    part1 = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1();
    proposal = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2();

    // Simulate the bridged GHO arriving at the Collector via CCIP before Part 2 runs.
    deal(GhoArbitrum.GHO_TOKEN, address(AaveV3Arbitrum.COLLECTOR), proposal.BRIDGED_AMOUNT());
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    _skipIfNotReady();
    defaultTest(
      'AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2',
      AaveV3Arbitrum.POOL,
      address(proposal)
    );
  }

  function test_executionFailsNoFunds() public {
    _skipIfNotReady();
    AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2 newProposal = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2();
    // Reset the Collector's balance so the bridged-amount transfer reverts.
    deal(GhoArbitrum.GHO_TOKEN, address(AaveV3Arbitrum.COLLECTOR), 0);

    vm.expectRevert();
    vm.prank(GovernanceV3Arbitrum.EXECUTOR_LVL_1);
    newProposal.execute();
  }

  function test_bridgeLimitRestore() public {
    _skipIfNotReady();
    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1);

    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    // Before Part 2 execution, the limits should be larger than defaults.
    assertGt(bucket.capacity, proposal.DEFAULT_RATE_LIMITER_CAPACITY());
    assertGt(bucket.rate, proposal.DEFAULT_RATE_LIMITER_RATE());
    assertTrue(bucket.isEnabled);
    assertGt(bucket.tokens, proposal.DEFAULT_RATE_LIMITER_CAPACITY());

    executePayload(vm, address(proposal));

    bucket = IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    // Limits are restored to defaults after Part 2 execution.
    assertEq(bucket.capacity, proposal.DEFAULT_RATE_LIMITER_CAPACITY());
    assertEq(bucket.rate, proposal.DEFAULT_RATE_LIMITER_RATE());
    assertTrue(bucket.isEnabled);
    assertEq(bucket.tokens, proposal.DEFAULT_RATE_LIMITER_CAPACITY());
  }

  function test_bothGsmsRegisteredAsEntities() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));

    assertTrue(
      IGhoReserve(address(proposal.GHO_RESERVE())).isEntity(proposal.GSM_USDT()),
      'USDT GSM not registered as entity'
    );
    assertTrue(
      IGhoReserve(address(proposal.GHO_RESERVE())).isEntity(proposal.GSM_USDC()),
      'USDC GSM not registered as entity'
    );
  }

  function test_checkGsmConfig_USDT() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));

    uint256 limit = IGhoReserve(address(proposal.GHO_RESERVE())).getLimit(proposal.GSM_USDT());
    assertEq(limit, proposal.GSM_USDT_RESERVE_LIMIT());

    GsmConfig memory gsmConfig = GsmConfig({
      sellFee: 0, // 0%
      buyFee: 0.001e4, // 0.1%
      exposureCap: proposal.GSM_USDT_INITIAL_EXPOSURE_CAP(),
      isFrozen: false,
      isSeized: false,
      freezerCanUnfreeze: true,
      freezeLowerBound: 0.99e8,
      freezeUpperBound: 1.01e8,
      unfreezeLowerBound: 0.995e8,
      unfreezeUpperBound: 1.005e8
    });
    _checkGsmConfig(
      IGsm(proposal.GSM_USDT()),
      AaveV3ArbitrumAssets.USDT_STATA_TOKEN,
      IOracleSwapFreezer(proposal.USDT_ORACLE_SWAP_FREEZER()),
      gsmConfig
    );
  }

  function test_checkGsmConfig_USDC() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));

    uint256 limit = IGhoReserve(address(proposal.GHO_RESERVE())).getLimit(proposal.GSM_USDC());
    assertEq(limit, proposal.GSM_USDC_RESERVE_LIMIT());

    GsmConfig memory gsmConfig = GsmConfig({
      sellFee: 0, // 0%
      buyFee: 0.001e4, // 0.1%
      exposureCap: proposal.GSM_USDC_INITIAL_EXPOSURE_CAP(),
      isFrozen: false,
      isSeized: false,
      freezerCanUnfreeze: true,
      freezeLowerBound: 0.99e8,
      freezeUpperBound: 1.01e8,
      unfreezeLowerBound: 0.995e8,
      unfreezeUpperBound: 1.005e8
    });
    _checkGsmConfig(
      IGsm(proposal.GSM_USDC()),
      AaveV3ArbitrumAssets.USDC_STATA_TOKEN,
      IOracleSwapFreezer(proposal.USDC_ORACLE_SWAP_FREEZER()),
      gsmConfig
    );
  }

  function test_oracleSwapFreezer_USDT() public {
    _skipIfNotReady();
    _testOracleSwapFreezer(
      IGsm(proposal.GSM_USDT()),
      IOracleSwapFreezer(proposal.USDT_ORACLE_SWAP_FREEZER()),
      AaveV3ArbitrumAssets.USDT_UNDERLYING
    );
  }

  function test_oracleSwapFreezer_USDC() public {
    _skipIfNotReady();
    _testOracleSwapFreezer(
      IGsm(proposal.GSM_USDC()),
      IOracleSwapFreezer(proposal.USDC_ORACLE_SWAP_FREEZER()),
      AaveV3ArbitrumAssets.USDC_UNDERLYING
    );
  }

  function test_checkRoles_USDT() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));
    _checkRolesConfig(IGsm(proposal.GSM_USDT()));
  }

  function test_checkRoles_USDC() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));
    _checkRolesConfig(IGsm(proposal.GSM_USDC()));
  }

  function test_gsmUsdtIsOperational() public {
    _skipIfNotReady();
    _testGsmIsOperational(IGsm(proposal.GSM_USDT()), AaveV3ArbitrumAssets.USDT_STATA_TOKEN);
  }

  function test_gsmUsdcIsOperational() public {
    _skipIfNotReady();
    _testGsmIsOperational(IGsm(proposal.GSM_USDC()), AaveV3ArbitrumAssets.USDC_STATA_TOKEN);
  }

  function test_ghoGsmSteward_updateExposureCap_USDT() public {
    _skipIfNotReady();
    _testUpdateExposureCap(IGsm(proposal.GSM_USDT()));
  }

  function test_ghoGsmSteward_updateExposureCap_USDC() public {
    _skipIfNotReady();
    _testUpdateExposureCap(IGsm(proposal.GSM_USDC()));
  }

  function test_ghoGsmSteward_updateGsmBuySellFees_USDT() public {
    _skipIfNotReady();
    _testUpdateBuySellFees(IGsm(proposal.GSM_USDT()));
  }

  function test_ghoGsmSteward_updateGsmBuySellFees_USDC() public {
    _skipIfNotReady();
    _testUpdateBuySellFees(IGsm(proposal.GSM_USDC()));
  }

  // TODO: remove this after placeholders are gone
  function _skipIfNotReady() internal {
    vm.skip(
      address(proposal.GHO_RESERVE()) == address(0) ||
        proposal.GSM_USDT() == address(0) ||
        proposal.GSM_USDC() == address(0) ||
        proposal.USDT_ORACLE_SWAP_FREEZER() == address(0) ||
        proposal.USDC_ORACLE_SWAP_FREEZER() == address(0) ||
        proposal.GSM_USDT_FEE_STRATEGY() == address(0) ||
        proposal.GSM_USDC_FEE_STRATEGY() == address(0) ||
        proposal.GSM_REGISTRY() == address(0) ||
        proposal.GHO_GSM_STEWARD() == address(0)
    );
  }

  function _testOracleSwapFreezer(
    IGsm gsm,
    IOracleSwapFreezer freezer,
    address underlyingForOracle
  ) internal {
    // OracleSwapFreezer is not authorized before execution
    assertEq(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)), false);

    (uint128 freezeLowerBound, ) = freezer.getFreezeBound();
    (uint128 unfreezeLowerBound, ) = freezer.getUnfreezeBound();

    // Price outside the price range — freezer cannot execute freeze without authorization.
    _mockAssetPrice(address(AaveV3Arbitrum.ORACLE), underlyingForOracle, freezeLowerBound - 1);

    (bool canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, false);
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false);

    // Payload execution
    executePayload(vm, address(proposal));

    // Freezer is authorized now
    assertEq(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)), true);

    // Freezer freezes the GSM
    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, true);
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), true);

    // Price back to normal
    _mockAssetPrice(address(AaveV3Arbitrum.ORACLE), underlyingForOracle, unfreezeLowerBound + 1);

    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, true);
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false);
  }

  function _testGsmIsOperational(IGsm gsm, address underlying) internal {
    executePayload(vm, address(proposal));

    deal(underlying, address(this), 1_000e6);

    IERC20(underlying).approve(address(gsm), 1_000e6);
    IERC20(GhoArbitrum.GHO_TOKEN).approve(address(gsm), 1_200 ether);

    uint256 amountUnderlying = 1_000e6;
    uint256 balanceBeforeUnderlying = IERC20(underlying).balanceOf(address(gsm));
    uint256 balanceGhoBefore = IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this));

    (, uint256 ghoBought) = gsm.sellAsset(amountUnderlying, address(this));

    assertEq(
      IERC20(underlying).balanceOf(address(gsm)),
      balanceBeforeUnderlying + amountUnderlying,
      'underlying balance after sellAsset not equal'
    );
    assertEq(
      IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this)),
      balanceGhoBefore + ghoBought,
      'GHO balance after sellAsset not equal'
    );

    (, uint256 ghoSold) = gsm.buyAsset(500e6, address(this));

    assertEq(
      IERC20(underlying).balanceOf(address(gsm)),
      balanceBeforeUnderlying + amountUnderlying - 500e6,
      'underlying balance after buyAsset not equal'
    );
    assertEq(
      IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this)),
      balanceGhoBefore + ghoBought - ghoSold,
      'GHO balance after buyAsset not equal'
    );
  }

  function _testUpdateExposureCap(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    uint128 oldExposureCap = gsm.getExposureCap();
    uint128 newExposureCap = oldExposureCap + 1;

    vm.startPrank(GhoArbitrum.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmExposureCap(address(gsm), newExposureCap);
    assertEq(gsm.getExposureCap(), newExposureCap);
  }

  function _testUpdateBuySellFees(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    address feeStrategy = gsm.getFeeStrategy();
    uint256 buyFee = IGsmFeeStrategy(feeStrategy).getBuyFee(1e4);
    uint256 sellFee = IGsmFeeStrategy(feeStrategy).getSellFee(1e4);

    vm.startPrank(GhoArbitrum.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmBuySellFees(address(gsm), buyFee + 1, sellFee);
    address newStrategy = gsm.getFeeStrategy();
    uint256 newBuyFee = IGsmFeeStrategy(newStrategy).getBuyFee(1e4);
    assertEq(newBuyFee, buyFee + 1);
  }

  function _checkRolesConfig(IGsm gsm) internal view {
    // DAO permissions
    assertTrue(
      gsm.hasRole(bytes32(0), GovernanceV3Arbitrum.EXECUTOR_LVL_1),
      'Executor is not admin'
    );
    assertTrue(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1),
      'Executor is not swap freezer'
    );
    assertTrue(
      gsm.hasRole(gsm.CONFIGURATOR_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1),
      'Executor is not configurator'
    );
    // No need to be liquidator or token rescuer at the beginning
    assertFalse(gsm.hasRole(gsm.LIQUIDATOR_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1));
    assertFalse(gsm.hasRole(gsm.TOKEN_RESCUER_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1));

    // GHO Steward
    assertTrue(
      gsm.hasRole(gsm.CONFIGURATOR_ROLE(), proposal.GHO_GSM_STEWARD()),
      'Gho Steward not configured'
    );

    // Risk Council can update draw limit
    assertTrue(
      IGhoReserve(address(proposal.GHO_RESERVE())).hasRole(
        IGhoReserve(address(proposal.GHO_RESERVE())).LIMIT_MANAGER_ROLE(),
        GhoArbitrum.RISK_COUNCIL
      ),
      'Limit manager role not granted to RiskCouncil'
    );
  }

  function _mockAssetPrice(address priceOracle, address asset, uint256 price) internal {
    vm.mockCall(
      priceOracle,
      abi.encodeWithSelector(IAaveOracle.getAssetPrice.selector, asset),
      abi.encode(price)
    );
  }

  struct GsmConfig {
    uint256 sellFee;
    uint256 buyFee;
    uint256 exposureCap;
    bool isFrozen;
    bool isSeized;
    bool freezerCanUnfreeze;
    uint256 freezeLowerBound;
    uint256 freezeUpperBound;
    uint256 unfreezeLowerBound;
    uint256 unfreezeUpperBound;
  }

  function _checkGsmConfig(
    IGsm gsm,
    address underlying,
    IOracleSwapFreezer freezer,
    GsmConfig memory config
  ) internal view {
    assertEq(gsm.UNDERLYING_ASSET(), underlying, 'wrong underlying asset');
    assertEq(gsm.getAvailableUnderlyingExposure(), config.exposureCap, 'wrong exposure cap');
    assertEq(gsm.getIsFrozen(), config.isFrozen, 'wrong freeze state');
    assertEq(gsm.getIsSeized(), config.isSeized, 'wrong seized state');

    // Fee Strategy
    IGsmFeeStrategy feeStrategy = IGsmFeeStrategy(gsm.getFeeStrategy());
    assertEq(feeStrategy.getSellFee(10000), config.sellFee, 'wrong sell fee');
    assertEq(feeStrategy.getBuyFee(10000), config.buyFee, 'wrong buy fee');

    // Price Strategy
    IFixedPriceStrategy4626 priceStrategy = IFixedPriceStrategy4626(gsm.PRICE_STRATEGY());
    assertEq(
      IERC4626(underlying).previewMint(1e6) * 10 ** 12,
      priceStrategy.getAssetPriceInGho(1e6, true)
    );
    assertEq(
      IERC4626(underlying).previewWithdraw(1 ether) / 10 ** 12,
      priceStrategy.getGhoPriceInAsset(1 ether, false)
    );

    assertEq(gsm.getGhoTreasury(), address(AaveV3Arbitrum.COLLECTOR));

    // Oracle freezer
    assertEq(freezer.getCanUnfreeze(), config.freezerCanUnfreeze, 'wrong freezer config');
    (uint256 lowerBound, uint256 upperBound) = freezer.getFreezeBound();
    assertEq(lowerBound, config.freezeLowerBound, 'wrong freeze lower bound');
    assertEq(upperBound, config.freezeUpperBound, 'wrong freeze upper bound');
    (lowerBound, upperBound) = freezer.getUnfreezeBound();
    assertEq(lowerBound, config.unfreezeLowerBound, 'wrong unfreeze lower bound');
    assertEq(upperBound, config.unfreezeUpperBound, 'wrong unfreeze upper bound');

    assertEq(freezer.ADDRESS_PROVIDER(), address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER));
    assertEq(freezer.GSM(), address(gsm));
  }
}

interface IOracleSwapFreezer {
  function ADDRESS_PROVIDER() external view returns (address);
  function GSM() external view returns (address);
  function getCanUnfreeze() external view returns (bool);
  function getFreezeBound() external view returns (uint128, uint128);
  function getUnfreezeBound() external view returns (uint128, uint128);
  function checkUpkeep(bytes calldata) external view returns (bool, bytes memory);
  function performUpkeep(bytes calldata) external;
}

interface IFixedPriceStrategy4626 {
  function getAssetPriceInGho(uint256 assetAmount, bool roundUp) external view returns (uint256);
  function getGhoPriceInAsset(uint256 ghoAmount, bool roundUp) external view returns (uint256);
}
