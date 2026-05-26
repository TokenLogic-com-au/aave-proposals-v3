// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {AaveV3XLayer} from 'aave-address-book/AaveV3XLayer.sol';
import {GovernanceV3XLayer} from 'aave-address-book/GovernanceV3XLayer.sol';
import {GhoXLayer} from 'aave-address-book/GhoXLayer.sol';
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
import {IOracleSwapFreezer} from 'src/interfaces/IOracleSwapFreezer.sol';
import {IFixedPriceStrategy4626} from 'src/interfaces/IFixedPriceStrategy4626.sol';

import {AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part1} from './AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part1.sol';
import {AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2} from './AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2.sol';

import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @dev Test for AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260526_Multi_RemoteGSMLaunchXLayer/AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2.t.sol -vv
 *
 * Note: many tests are gated with `vm.skip(...)` on address(0) placeholders until
 * the GSM/Reserve/Steward/Registry/FeeStrategy/Freezer contracts are deployed on X-Layer,
 * and until the Eth->XLayer CCIP OffRamp + stata-token addresses are known.
 */
contract AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2_Test is ProtocolV3TestBase {
  // TODO: Eth->XLayer CCIP v1.5 OffRamp on the X-Layer router at the pinned block.
  // Resolve via `IRouter(CCIPChainRouters.XLAYER).getOffRamps()` or by checking
  // `isOffRamp(CCIPChainSelectors.ETHEREUM, candidate)` for each candidate.
  // While 0, the CCIP delivery simulation in setUp is skipped and every test that
  // depends on bridged GHO landing in the Collector also skips via `_skipIfNotReady`.
  address internal constant CCIP_ETH_OFFRAMP = address(0);

  // TODO: stataUSDT / stataUSDC underlying tokens on X-Layer. Add to AaveV3XLayerAssets
  // address book once available; for now placeholder so the test compiles. The GSM
  // operational + price-strategy tests skip via `_skipIfNotReady` while these are 0.
  address internal constant STATA_USDT = address(0);
  address internal constant STATA_USDC = address(0);

  AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part1 internal part1;
  AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2 internal proposal;

  // Captured immediately before the simulated CCIP mint in setUp so tests can assert deltas
  // (the Collector and the CCIP token pool facilitator both have non-zero state at the
  // fork block).
  uint256 internal collectorGhoBalanceBeforeCcipDelivery;
  uint128 internal ccipPoolFacilitatorBucketLevelBeforeCcipDelivery;

  function setUp() public {
    // TODO: pick a current X-Layer block number to pin the fork.
    vm.createSelectFork(vm.rpcUrl('xlayer'));
    part1 = new AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part1();
    proposal = new AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2();

    // Run Part 1 so the GHO_CCIP_TOKEN_POOL facilitator bucket capacity is raised and the
    // Eth->XLayer inbound rate limiter is widened, mirroring the real sequencing on-chain.
    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1); // let the inbound rate limiter refill to capacity

    collectorGhoBalanceBeforeCcipDelivery = IERC20(GhoXLayer.GHO_TOKEN).balanceOf(
      address(AaveV3XLayer.COLLECTOR)
    );
    ccipPoolFacilitatorBucketLevelBeforeCcipDelivery = IGhoToken(GhoXLayer.GHO_TOKEN)
      .getFacilitator(GhoXLayer.GHO_CCIP_TOKEN_POOL)
      .bucketLevel;

    // Simulate CCIP delivery end-to-end only when the OffRamp address is known.
    // While CCIP_ETH_OFFRAMP is address(0), skip the simulation; tests that depend
    // on the bridged GHO will also skip via _skipIfNotReady so setUp never reverts.
    if (CCIP_ETH_OFFRAMP != address(0)) {
      _simulateCcipDeliveryToCollector(RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT);
    }
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    _skipIfNotReady();
    defaultTest(
      'AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2',
      AaveV3XLayer.POOL,
      address(proposal)
    );
  }

  function test_executionFailsNoFunds() public {
    _skipIfNotReady();
    AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2 newProposal = new AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part2();

    // `setUp` executes Part 1 and simulates a CCIP delivery that mints BRIDGED_AMOUNT of
    // GHO to the Collector. This test is the exception: it asserts `execute()` reverts
    // when the Collector hasn't received the bridged GHO, so we zero the Collector's
    // GHO balance via `deal`. `deal` is appropriate here because we want behavior with no
    // funds — we're not trying to exercise the CCIP mint path.
    deal(GhoXLayer.GHO_TOKEN, address(AaveV3XLayer.COLLECTOR), 0);

    // TODO: bare `vm.expectRevert()` will match the first revert encountered, which is
    // intended to be the GHO transfer (insufficient balance). Once concrete error selectors
    // are known, replace with `vm.expectRevert(<selector>)` to pin the source.
    vm.expectRevert();
    vm.prank(GovernanceV3XLayer.EXECUTOR_LVL_1);
    newProposal.execute();
  }

  function test_ccipOffRampIsRegistered() public view {
    if (CCIP_ETH_OFFRAMP == address(0)) return;
    // Guard: if CCIP rotates the Eth -> XLayer OffRamp at a future block, this test
    // fails with a clear signal before the more-opaque `releaseOrMint` revert in setUp
    // shows up elsewhere in the suite.
    assertTrue(
      IRouter(CCIPChainRouters.XLAYER).isOffRamp(CCIPChainSelectors.ETHEREUM, CCIP_ETH_OFFRAMP),
      'CCIP_ETH_OFFRAMP is no longer a registered Eth->XLayer OffRamp on X-Layer CCIP router'
    );
  }

  function test_ccipDeliveryMintsToCollector() public view {
    if (CCIP_ETH_OFFRAMP == address(0)) return;
    // setUp ran Part 1 then simulated a CCIP delivery via releaseOrMint. Assert the
    // Collector and the GHO_CCIP_TOKEN_POOL facilitator both moved by BRIDGED_AMOUNT.
    assertEq(
      IERC20(GhoXLayer.GHO_TOKEN).balanceOf(address(AaveV3XLayer.COLLECTOR)) -
        collectorGhoBalanceBeforeCcipDelivery,
      RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT,
      'Collector GHO balance should increase by exactly BRIDGED_AMOUNT'
    );

    IGhoToken.Facilitator memory facilitator = IGhoToken(GhoXLayer.GHO_TOKEN).getFacilitator(
      GhoXLayer.GHO_CCIP_TOKEN_POOL
    );
    assertEq(
      facilitator.bucketLevel - ccipPoolFacilitatorBucketLevelBeforeCcipDelivery,
      uint128(RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT),
      'CCIP token pool facilitator bucketLevel should increase by exactly BRIDGED_AMOUNT'
    );
  }

  function test_bridgeLimitRestore() public {
    _skipIfNotReady();

    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoXLayer.GHO_CCIP_TOKEN_POOL
    ).getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    // Before Part 2 execution, the limits should be larger than defaults.
    assertGt(
      bucket.capacity,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'pre-Part2 inbound capacity should be raised'
    );
    assertGt(
      bucket.rate,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE,
      'pre-Part2 inbound rate should be raised'
    );
    assertTrue(bucket.isEnabled, 'pre-Part2 inbound rate limiter should be enabled');
    assertGt(
      bucket.tokens,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'pre-Part2 inbound tokens should exceed default capacity'
    );

    executePayload(vm, address(proposal));

    bucket = IUpgradeableBurnMintTokenPool(GhoXLayer.GHO_CCIP_TOKEN_POOL)
      .getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-Part2 inbound capacity should be restored to default'
    );
    assertEq(
      bucket.rate,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE,
      'post-Part2 inbound rate should be restored to default'
    );
    assertTrue(bucket.isEnabled, 'post-Part2 inbound rate limiter should be enabled');
    assertEq(
      bucket.tokens,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-Part2 inbound tokens should equal default capacity'
    );

    bucket = IUpgradeableBurnMintTokenPool(GhoXLayer.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.ETHEREUM);

    assertEq(
      bucket.capacity,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
      'post-Part2 outbound capacity should be restored to default'
    );
    assertEq(
      bucket.rate,
      RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE,
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
    assertEq(
      limit,
      RemoteGSMLaunchXLayerConstants.GSM_USDT_RESERVE_LIMIT,
      'USDT GSM reserve limit not set'
    );

    GsmConfig memory gsmConfig = GsmConfig({
      sellFee: 0, // 0%
      buyFee: 0.001e4, // 0.1%
      exposureCap: RemoteGSMLaunchXLayerConstants.GSM_USDT_INITIAL_EXPOSURE_CAP,
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
      STATA_USDT,
      IOracleSwapFreezer(proposal.USDT_ORACLE_SWAP_FREEZER()),
      gsmConfig
    );
  }

  function test_checkGsmConfig_USDC() public {
    _skipIfNotReady();
    executePayload(vm, address(proposal));

    uint256 limit = IGhoReserve(address(proposal.GHO_RESERVE())).getLimit(proposal.GSM_USDC());
    assertEq(
      limit,
      RemoteGSMLaunchXLayerConstants.GSM_USDC_RESERVE_LIMIT,
      'USDC GSM reserve limit not set'
    );

    GsmConfig memory gsmConfig = GsmConfig({
      sellFee: 0, // 0%
      buyFee: 0.001e4, // 0.1%
      exposureCap: RemoteGSMLaunchXLayerConstants.GSM_USDC_INITIAL_EXPOSURE_CAP,
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
      STATA_USDC,
      IOracleSwapFreezer(proposal.USDC_ORACLE_SWAP_FREEZER()),
      gsmConfig
    );
  }

  function test_oracleSwapFreezer_USDT() public {
    _skipIfNotReady();
    _testOracleSwapFreezer(
      IGsm(proposal.GSM_USDT()),
      IOracleSwapFreezer(proposal.USDT_ORACLE_SWAP_FREEZER()),
      // TODO: replace with the X-Layer USDT underlying once the stata mapping is final.
      address(0)
    );
  }

  function test_oracleSwapFreezer_USDC() public {
    _skipIfNotReady();
    _testOracleSwapFreezer(
      IGsm(proposal.GSM_USDC()),
      IOracleSwapFreezer(proposal.USDC_ORACLE_SWAP_FREEZER()),
      // TODO: replace with the X-Layer USDC underlying once the stata mapping is final.
      address(0)
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
    _testGsmIsOperational(IGsm(proposal.GSM_USDT()), STATA_USDT);
  }

  function test_gsmIsOperational_USDC() public {
    _skipIfNotReady();
    _testGsmIsOperational(IGsm(proposal.GSM_USDC()), STATA_USDC);
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
   * Collector. Pranks as the Eth->XLayer OffRamp registered on the X-Layer CCIP router and
   * invokes `releaseOrMint` on the GHO token pool, which routes through `IGhoToken.mint`
   * and exercises the facilitator bucket capacity raised by Part 1.
   */
  function _simulateCcipDeliveryToCollector(uint256 amount) internal {
    vm.prank(CCIP_ETH_OFFRAMP);
    IUpgradeableBurnMintTokenPool_1_5_1(GhoXLayer.GHO_CCIP_TOKEN_POOL).releaseOrMint(
      IPool_CCIP.ReleaseOrMintInV1({
        originalSender: abi.encode(GovernanceV3XLayer.EXECUTOR_LVL_1),
        remoteChainSelector: CCIPChainSelectors.ETHEREUM,
        receiver: address(AaveV3XLayer.COLLECTOR),
        amount: amount,
        localToken: GhoXLayer.GHO_TOKEN,
        sourcePoolAddress: abi.encode(GhoEthereum.GHO_CCIP_TOKEN_POOL),
        sourcePoolData: new bytes(0),
        offchainTokenData: new bytes(0)
      })
    );
  }

  // TODO: remove this after placeholders are gone
  function _skipIfNotReady() internal {
    vm.skip(
      CCIP_ETH_OFFRAMP == address(0) ||
        STATA_USDT == address(0) ||
        STATA_USDC == address(0) ||
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
    assertEq(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)),
      false,
      'freezer should not have SWAP_FREEZER_ROLE before proposal'
    );

    (uint128 freezeLowerBound, ) = freezer.getFreezeBound();
    (uint128 unfreezeLowerBound, ) = freezer.getUnfreezeBound();

    _mockAssetPrice(address(AaveV3XLayer.ORACLE), underlyingForOracle, freezeLowerBound - 1);

    (bool canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, false, 'checkUpkeep should report false before proposal');
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false, 'GSM should not be frozen before proposal');

    vm.prank(address(freezer));
    vm.expectRevert();
    gsm.setSwapFreeze(true);

    executePayload(vm, address(proposal));

    assertEq(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), address(freezer)),
      true,
      'freezer should hold SWAP_FREEZER_ROLE after proposal'
    );

    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(
      canPerformUpkeep,
      true,
      'checkUpkeep should report true after proposal with bad price'
    );
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), true, 'GSM should be frozen after freezer performs upkeep');

    _mockAssetPrice(address(AaveV3XLayer.ORACLE), underlyingForOracle, unfreezeLowerBound + 1);

    (canPerformUpkeep, ) = freezer.checkUpkeep(bytes(''));
    assertEq(canPerformUpkeep, true, 'checkUpkeep should report true with price back in band');
    freezer.performUpkeep(bytes(''));
    assertEq(gsm.getIsFrozen(), false, 'GSM should be unfrozen after price recovers');
  }

  function _testGsmIsOperational(IGsm gsm, address underlying) internal {
    executePayload(vm, address(proposal));

    // NOTE: `deal(STATA, true)` writes the balance slot directly *and* updates the
    // ERC4626 accounting (`totalAssets`, `totalSupply`). For pure GSM-path arithmetic this
    // is not strictly required, but once real GSMs are deployed verify that `sellAsset` / `buyAsset`
    // produce the expected GHO amounts. If not, switch to dealing the underlying USDT/USDC
    // and wrapping via `IERC4626.deposit(...)` to keep 4626 accounting consistent.
    deal(underlying, address(this), 1_000e6, true);

    IERC20(underlying).approve(address(gsm), 1_000e6);
    IERC20(GhoXLayer.GHO_TOKEN).approve(address(gsm), 1_200 ether);

    uint256 amountUnderlying = 1_000e6;
    uint256 gsmBalanceBefore = IERC20(underlying).balanceOf(address(gsm));
    uint256 userUnderlyingBefore = IERC20(underlying).balanceOf(address(this));
    uint256 balanceGhoBefore = IGhoToken(GhoXLayer.GHO_TOKEN).balanceOf(address(this));

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
      IGhoToken(GhoXLayer.GHO_TOKEN).balanceOf(address(this)),
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
      IGhoToken(GhoXLayer.GHO_TOKEN).balanceOf(address(this)),
      balanceGhoBefore + ghoBought - ghoSold,
      'GHO balance after buyAsset is wrong'
    );
  }

  function _testUpdateExposureCap(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    uint128 oldExposureCap = gsm.getExposureCap();
    uint128 newExposureCap = oldExposureCap + 1;

    vm.prank(GhoXLayer.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmExposureCap(address(gsm), newExposureCap);
    assertEq(gsm.getExposureCap(), newExposureCap, 'exposure cap not updated by GhoGsmSteward');
  }

  function _testUpdateBuySellFees(IGsm gsm) internal {
    executePayload(vm, address(proposal));

    address feeStrategy = gsm.getFeeStrategy();
    uint256 buyFee = IGsmFeeStrategy(feeStrategy).getBuyFee(1e4);
    uint256 sellFee = IGsmFeeStrategy(feeStrategy).getSellFee(1e4);

    vm.prank(GhoXLayer.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmBuySellFees(address(gsm), buyFee + 1, sellFee);
    address newStrategy = gsm.getFeeStrategy();
    uint256 newBuyFee = IGsmFeeStrategy(newStrategy).getBuyFee(1e4);
    assertEq(newBuyFee, buyFee + 1, 'buy fee not updated by GhoGsmSteward');
  }

  function _checkRolesConfig(IGsm gsm) internal view {
    // DAO permissions
    assertTrue(gsm.hasRole(bytes32(0), GovernanceV3XLayer.EXECUTOR_LVL_1), 'Executor is not admin');
    assertTrue(
      gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), GovernanceV3XLayer.EXECUTOR_LVL_1),
      'Executor is not swap freezer'
    );
    assertTrue(
      gsm.hasRole(gsm.CONFIGURATOR_ROLE(), GovernanceV3XLayer.EXECUTOR_LVL_1),
      'Executor is not configurator'
    );
    assertFalse(
      gsm.hasRole(gsm.LIQUIDATOR_ROLE(), GovernanceV3XLayer.EXECUTOR_LVL_1),
      'Executor should not have LIQUIDATOR_ROLE'
    );
    assertFalse(
      gsm.hasRole(gsm.TOKEN_RESCUER_ROLE(), GovernanceV3XLayer.EXECUTOR_LVL_1),
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
        GhoXLayer.RISK_COUNCIL
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

    assertEq(gsm.getFeeStrategy(), config.feeStrategy, 'wrong fee strategy address');
    IGsmFeeStrategy feeStrategy = IGsmFeeStrategy(gsm.getFeeStrategy());
    assertEq(feeStrategy.getSellFee(10000), config.sellFee, 'wrong sell fee');
    assertEq(feeStrategy.getBuyFee(10000), config.buyFee, 'wrong buy fee');

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
      address(AaveV3XLayer.COLLECTOR),
      'GhoTreasury should be AaveV3XLayer.COLLECTOR'
    );

    assertEq(freezer.getCanUnfreeze(), config.freezerCanUnfreeze, 'wrong freezer config');
    (uint256 lowerBound, uint256 upperBound) = freezer.getFreezeBound();
    assertEq(lowerBound, config.freezeLowerBound, 'wrong freeze lower bound');
    assertEq(upperBound, config.freezeUpperBound, 'wrong freeze upper bound');
    (lowerBound, upperBound) = freezer.getUnfreezeBound();
    assertEq(lowerBound, config.unfreezeLowerBound, 'wrong unfreeze lower bound');
    assertEq(upperBound, config.unfreezeUpperBound, 'wrong unfreeze upper bound');

    assertEq(
      freezer.ADDRESS_PROVIDER(),
      address(AaveV3XLayer.POOL_ADDRESSES_PROVIDER),
      'freezer address provider mismatch'
    );
    assertEq(freezer.GSM(), address(gsm), 'freezer GSM mismatch');
  }
}
