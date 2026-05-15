// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {IPool as IPool_CCIP} from 'src/interfaces/ccip/tokenPool/IPool.sol';
import {IRouter} from 'src/interfaces/ccip/IRouter.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {CCIPChainRouters} from '../helpers/gho-launch/constants/CCIPChainRouters.sol';
import {IAaveOracle} from 'aave-address-book/AaveV2.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IGsmFeeStrategy} from 'src/interfaces/IGsmFeeStrategy.sol';
import {IGsmSteward} from 'src/interfaces/IGsmSteward.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';

import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';
import {IOracleSwapFreezer} from './utils/IOracleSwapFreezer.sol';
import {IFixedPriceStrategy4626} from './utils/IFixedPriceStrategy4626.sol';

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

  // Captured immediately before the simulated CCIP mint in setUp so tests can assert deltas
  // (the Collector and the CCIP token pool facilitator both have non-zero state at the
  // fork block).
  uint256 internal collectorGhoBalanceBeforeCcipDelivery;
  uint128 internal ccipPoolFacilitatorBucketLevelBeforeCcipDelivery;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 462142700);
    part1 = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1();
    proposal = new AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2();

    // Run Part 1 so the GHO_CCIP_TOKEN_POOL facilitator bucket capacity is raised and the
    // Eth->Arb inbound rate limiter is widened, mirroring the real sequencing on-chain.
    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1); // let the inbound rate limiter refill to capacity

    collectorGhoBalanceBeforeCcipDelivery = IERC20(GhoArbitrum.GHO_TOKEN).balanceOf(
      address(AaveV3Arbitrum.COLLECTOR)
    );
    ccipPoolFacilitatorBucketLevelBeforeCcipDelivery = IGhoToken(GhoArbitrum.GHO_TOKEN)
      .getFacilitator(GhoArbitrum.GHO_CCIP_TOKEN_POOL)
      .bucketLevel;

    // Simulate CCIP delivery end-to-end: prank as the Eth->Arb OffRamp and call
    // `releaseOrMint` on the GHO CCIP token pool. The pool acts as a GHO facilitator, so
    // this routes through `IGhoToken.mint` and exercises the facilitator bucket check that
    // Part 1 just configured. If the bucket capacity were misconfigured, the mint would
    // revert here and every test that depends on the bridged funds would fail loudly, which
    // would not happen if we mocked the transfer using `vm.deal`.
    _simulateCcipDeliveryToCollector(proposal.BRIDGED_AMOUNT());
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

    // `setUp` executes Part 1 and simulates a CCIP delivery that mints BRIDGED_AMOUNT of
    // GHO to the Collector. This test is the exception: it asserts `execute()` reverts
    // when the Collector hasn't received the bridged GHO, so we zero the Collector's
    // GHO balance via `deal`. `deal` is appropriate here because we want behavior with no
    // funds — we're not trying to exercise the CCIP mint path.
    deal(GhoArbitrum.GHO_TOKEN, address(AaveV3Arbitrum.COLLECTOR), 0);

    // TODO: bare `vm.expectRevert()` will match the first revert encountered, which is
    // intended to be the GHO transfer (insufficient balance). Once concrete error selectors
    // are known, replace with `vm.expectRevert(<selector>)` to pin the source.
    vm.expectRevert();
    vm.prank(GovernanceV3Arbitrum.EXECUTOR_LVL_1);
    newProposal.execute();
  }

  function test_ccipDeliveryMintsToCollector() public view {
    // setUp ran Part 1 then simulated a CCIP delivery via releaseOrMint. Assert the
    // Collector and the GHO_CCIP_TOKEN_POOL facilitator both moved by BRIDGED_AMOUNT.
    // If Part 1's facilitator-capacity update is misconfigured (e.g. capacity below
    // BRIDGED_AMOUNT), setUp's `releaseOrMint` reverts and the whole suite fails at setUp.
    assertEq(
      IERC20(GhoArbitrum.GHO_TOKEN).balanceOf(address(AaveV3Arbitrum.COLLECTOR)) -
        collectorGhoBalanceBeforeCcipDelivery,
      proposal.BRIDGED_AMOUNT(),
      'Collector GHO balance should increase by exactly BRIDGED_AMOUNT'
    );

    IGhoToken.Facilitator memory facilitator = IGhoToken(GhoArbitrum.GHO_TOKEN).getFacilitator(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );
    assertEq(
      facilitator.bucketLevel - ccipPoolFacilitatorBucketLevelBeforeCcipDelivery,
      uint128(proposal.BRIDGED_AMOUNT()),
      'CCIP token pool facilitator bucketLevel should increase by exactly BRIDGED_AMOUNT'
    );
  }

  function test_bridgeLimitRestore() public {
    _skipIfNotReady();
    // setUp() already executes Part 1 and warps 1 second; the inbound rate limiter is
    // already widened by this point.

    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    // Before Part 2 execution, the limits should be larger than defaults.
    assertGt(
      bucket.capacity,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'pre-Part2 inbound capacity should be raised'
    );
    assertGt(
      bucket.rate,
      proposal.DEFAULT_RATE_LIMITER_RATE(),
      'pre-Part2 inbound rate should be raised'
    );
    assertTrue(bucket.isEnabled, 'pre-Part2 inbound rate limiter should be enabled');
    assertGt(
      bucket.tokens,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'pre-Part2 inbound tokens should exceed default capacity'
    );

    executePayload(vm, address(proposal));

    bucket = IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    // Limits are restored to defaults after Part 2 execution.
    assertEq(
      bucket.capacity,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'post-Part2 inbound capacity should be restored to default'
    );
    assertEq(
      bucket.rate,
      proposal.DEFAULT_RATE_LIMITER_RATE(),
      'post-Part2 inbound rate should be restored to default'
    );
    assertTrue(bucket.isEnabled, 'post-Part2 inbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'post-Part2 inbound tokens should equal default capacity'
    );

    // The proposal restores both inbound and outbound configs; assert outbound too.
    bucket = IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      proposal.DEFAULT_RATE_LIMITER_CAPACITY(),
      'post-Part2 outbound capacity should be restored to default'
    );
    assertEq(
      bucket.rate,
      proposal.DEFAULT_RATE_LIMITER_RATE(),
      'post-Part2 outbound rate should be restored to default'
    );
    assertTrue(bucket.isEnabled, 'post-Part2 outbound rate limiter should be enabled');
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
    assertEq(limit, proposal.GSM_USDT_RESERVE_LIMIT(), 'USDT GSM reserve limit not set');

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
      unfreezeUpperBound: 1.005e8,
      feeStrategy: proposal.GSM_USDT_FEE_STRATEGY()
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
    assertEq(limit, proposal.GSM_USDC_RESERVE_LIMIT(), 'USDC GSM reserve limit not set');

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
      unfreezeUpperBound: 1.005e8,
      feeStrategy: proposal.GSM_USDC_FEE_STRATEGY()
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

  function test_gsmIsOperational_USDT() public {
    _skipIfNotReady();
    _testGsmIsOperational(IGsm(proposal.GSM_USDT()), AaveV3ArbitrumAssets.USDT_STATA_TOKEN);
  }

  function test_gsmIsOperational_USDC() public {
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

  /**
   * @dev Simulates the destination-chain CCIP mint that delivers bridged GHO to the
   * Collector. Pranks as the Eth->Arb OffRamp registered on the Arbitrum CCIP router and
   * invokes `releaseOrMint` on the GHO token pool, which routes through `IGhoToken.mint`
   * and exercises the facilitator bucket capacity raised by Part 1.
   *
   * The pool is v1.5.1, which uses the struct-based `releaseOrMint(ReleaseOrMintInV1)`
   * signature (see `src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol`).
   */
  function _simulateCcipDeliveryToCollector(uint256 amount) internal {
    address offRamp = _findEthToArbOffRamp();
    require(offRamp != address(0), 'no Eth->Arb OffRamp on Arbitrum CCIP router');

    vm.prank(offRamp);
    IUpgradeableBurnMintTokenPool_1_5_1(GhoArbitrum.GHO_CCIP_TOKEN_POOL).releaseOrMint(
      IPool_CCIP.ReleaseOrMintInV1({
        originalSender: abi.encode(GovernanceV3Arbitrum.EXECUTOR_LVL_1),
        remoteChainSelector: CCIPChainSelectors.ETHEREUM,
        receiver: address(AaveV3Arbitrum.COLLECTOR),
        amount: amount,
        localToken: GhoArbitrum.GHO_TOKEN,
        // Informational on the destination side; using the real Eth pool keeps it realistic.
        sourcePoolAddress: abi.encode(GhoEthereum.GHO_CCIP_TOKEN_POOL),
        sourcePoolData: new bytes(0),
        offchainTokenData: new bytes(0)
      })
    );
  }

  function _findEthToArbOffRamp() internal view returns (address) {
    IRouter.OffRamp[] memory offRamps = IRouter(CCIPChainRouters.ARBITRUM).getOffRamps();
    for (uint256 i = 0; i < offRamps.length; i++) {
      if (offRamps[i].sourceChainSelector == CCIPChainSelectors.ETHEREUM) {
        return offRamps[i].offRamp;
      }
    }
    return address(0);
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
    assertEq(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)),
      false,
      'freezer should not have SWAP_FREEZER_ROLE before proposal'
    );

    (uint128 freezeLowerBound, ) = freezer.getFreezeBound();
    (uint128 unfreezeLowerBound, ) = freezer.getUnfreezeBound();

    // Price outside the price range — freezer cannot execute freeze without authorization.
    _mockAssetPrice(address(AaveV3Arbitrum.ORACLE), underlyingForOracle, freezeLowerBound - 1);

    (bool canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, false, 'checkUpkeep should report false before proposal');
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false, 'GSM should not be frozen before proposal');

    // Explicit "cannot perform the action": calling the privileged primitive as the
    // freezer reverts because it does not yet hold SWAP_FREEZER_ROLE.
    vm.prank(address(freezer));
    vm.expectRevert();
    gsm.setSwapFreeze(true);

    // Payload execution
    executePayload(vm, address(proposal));

    // Freezer is authorized now
    assertEq(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)),
      true,
      'freezer should hold SWAP_FREEZER_ROLE after proposal'
    );

    // Freezer freezes the GSM
    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(
      canPerformUpkeep,
      true,
      'checkUpkeep should report true after proposal with bad price'
    );
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), true, 'GSM should be frozen after freezer performs upkeep');

    // Price back to normal
    _mockAssetPrice(address(AaveV3Arbitrum.ORACLE), underlyingForOracle, unfreezeLowerBound + 1);

    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, true, 'checkUpkeep should report true with price back in band');
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false, 'GSM should be unfrozen after price recovers');
  }

  function _testGsmIsOperational(IGsm gsm, address underlying) internal {
    executePayload(vm, address(proposal));

    // NOTE: `deal(STATA, ...)` writes the balance slot directly but does NOT update the
    // ERC4626 accounting (`totalAssets`, `totalSupply`). For pure GSM-path arithmetic this
    // is usually fine, but once real GSMs are deployed verify that `sellAsset` / `buyAsset`
    // produce the expected GHO amounts. If not, switch to dealing the underlying USDT/USDC
    // and wrapping via `IERC4626.deposit(...)` to keep 4626 accounting consistent.
    deal(underlying, address(this), 1_000e6);

    IERC20(underlying).approve(address(gsm), 1_000e6);
    IERC20(GhoArbitrum.GHO_TOKEN).approve(address(gsm), 1_200 ether);

    uint256 amountUnderlying = 1_000e6;
    uint256 gsmBalanceBefore = IERC20(underlying).balanceOf(address(gsm));
    uint256 userUnderlyingBefore = IERC20(underlying).balanceOf(address(this));
    uint256 balanceGhoBefore = IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this));

    (, uint256 ghoBought) = gsm.sellAsset(amountUnderlying, address(this));

    assertEq(
      IERC20(underlying).balanceOf(address(gsm)),
      gsmBalanceBefore + amountUnderlying,
      'underlying balance in GSM after sellAsset is wrong'
    );
    assertEq(
      IERC20(underlying).balanceOf(address(this)),
      userUnderlyingBefore - amountUnderlying,
      'user underlying balance after sellAsset is wrong'
    );
    assertEq(
      IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this)),
      balanceGhoBefore + ghoBought,
      'GHO balance after sellAsset is wrong'
    );

    (, uint256 ghoSold) = gsm.buyAsset(500e6, address(this));

    assertEq(
      IERC20(underlying).balanceOf(address(gsm)),
      gsmBalanceBefore + amountUnderlying - 500e6,
      'underlying balance in GSM after buyAsset is wrong'
    );
    assertEq(
      IERC20(underlying).balanceOf(address(this)),
      userUnderlyingBefore - amountUnderlying + 500e6,
      'user underlying balance after buyAsset is wrong'
    );
    assertEq(
      IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(this)),
      balanceGhoBefore + ghoBought - ghoSold,
      'GHO balance after buyAsset is wrong'
    );
  }

  function _testUpdateExposureCap(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    uint128 oldExposureCap = gsm.getExposureCap();
    uint128 newExposureCap = oldExposureCap + 1;

    vm.prank(GhoArbitrum.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmExposureCap(address(gsm), newExposureCap);
    assertEq(gsm.getExposureCap(), newExposureCap, 'exposure cap not updated by GhoGsmSteward');
  }

  function _testUpdateBuySellFees(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    address feeStrategy = gsm.getFeeStrategy();
    uint256 buyFee = IGsmFeeStrategy(feeStrategy).getBuyFee(1e4);
    uint256 sellFee = IGsmFeeStrategy(feeStrategy).getSellFee(1e4);

    vm.prank(GhoArbitrum.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmBuySellFees(address(gsm), buyFee + 1, sellFee);
    address newStrategy = gsm.getFeeStrategy();
    uint256 newBuyFee = IGsmFeeStrategy(newStrategy).getBuyFee(1e4);
    assertEq(newBuyFee, buyFee + 1, 'buy fee not updated by GhoGsmSteward');
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
    assertFalse(
      gsm.hasRole(gsm.LIQUIDATOR_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1),
      'Executor should not have LIQUIDATOR_ROLE'
    );
    assertFalse(
      gsm.hasRole(gsm.TOKEN_RESCUER_ROLE(), GovernanceV3Arbitrum.EXECUTOR_LVL_1),
      'Executor should not have TOKEN_RESCUER_ROLE'
    );

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
    address feeStrategy;
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
    assertEq(gsm.getFeeStrategy(), config.feeStrategy, 'wrong fee strategy address');
    IGsmFeeStrategy feeStrategy = IGsmFeeStrategy(gsm.getFeeStrategy());
    assertEq(feeStrategy.getSellFee(10000), config.sellFee, 'wrong sell fee');
    assertEq(feeStrategy.getBuyFee(10000), config.buyFee, 'wrong buy fee');

    // Price Strategy
    IFixedPriceStrategy4626 priceStrategy = IFixedPriceStrategy4626(gsm.PRICE_STRATEGY());
    assertEq(
      IERC4626(underlying).previewMint(1e6) * 10 ** 12,
      priceStrategy.getAssetPriceInGho(1e6, true),
      'asset price in GHO does not match preview'
    );
    assertEq(
      IERC4626(underlying).previewWithdraw(1 ether) / 10 ** 12,
      priceStrategy.getGhoPriceInAsset(1 ether, false),
      'GHO price in asset does not match preview'
    );

    assertEq(
      gsm.getGhoTreasury(),
      address(AaveV3Arbitrum.COLLECTOR),
      'GhoTreasury should be AaveV3Arbitrum.COLLECTOR'
    );

    // Oracle freezer
    assertEq(freezer.getCanUnfreeze(), config.freezerCanUnfreeze, 'wrong freezer config');
    (uint256 lowerBound, uint256 upperBound) = freezer.getFreezeBound();
    assertEq(lowerBound, config.freezeLowerBound, 'wrong freeze lower bound');
    assertEq(upperBound, config.freezeUpperBound, 'wrong freeze upper bound');
    (lowerBound, upperBound) = freezer.getUnfreezeBound();
    assertEq(lowerBound, config.unfreezeLowerBound, 'wrong unfreeze lower bound');
    assertEq(upperBound, config.unfreezeUpperBound, 'wrong unfreeze upper bound');

    assertEq(
      freezer.ADDRESS_PROVIDER(),
      address(AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER),
      'freezer address provider mismatch'
    );
    assertEq(freezer.GSM(), address(gsm), 'freezer GSM mismatch');
  }
}
