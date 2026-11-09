// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from 'forge-std/console.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';
import {IExecutor} from 'aave-address-book/governance-v3/IExecutor.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {GovernanceV3Avalanche} from 'aave-address-book/GovernanceV3Avalanche.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {IGsmSteward} from 'src/interfaces/IGsmSteward.sol';
import {IPermissionedGsm} from 'src/interfaces/IPermissionedGsm.sol';

import {AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1} from './AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.sol';
import {AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2} from './AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.sol';
import {PermissionedGSMUSATAvalancheSetup as Setup} from './setup/PermissionedGSMUSATAvalancheSetup.sol';
import {AvalancheCcipDelivery} from './setup/AvalancheCcipDelivery.sol';

/**
 * @dev Test for AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol -vv
 *
 * Tests that execute the payload are skipped while any pending address is unset;
 * `test_deploymentAddressesSet` fails until all are.
 */
contract AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2_Test is
  ProtocolV3TestBase,
  AvalancheCcipDelivery
{
  uint256 internal constant FORK_BLOCK = 99859000;
  uint256 internal constant SWAP_AMOUNT = 1_000e6;

  AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1 internal part1;
  AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2 internal proposal;
  IUpgradeableBurnMintTokenPool internal pool =
    IUpgradeableBurnMintTokenPool(GhoAvalanche.GHO_CCIP_TOKEN_POOL);
  IPermissionedGsm internal gsm;
  uint256 internal preDeliveryState;

  modifier deployed() {
    if (_missingAddresses().length != 0) {
      vm.skip(true, 'GSM suite pending deployment');
    }
    _;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), FORK_BLOCK);
    part1 = new AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1();
    proposal = new AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2();
    gsm = proposal.GSM_USAT();

    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1); // inbound bucket refill
    preDeliveryState = vm.snapshotState();
    _deliverToAvalancheCollector(Setup.GHO_BRIDGE_AMOUNT);
  }

  function test_deploymentAddressesSet() public view {
    string[] memory missing = _missingAddresses();
    for (uint256 i = 0; i < missing.length; i++) {
      console.log('pending deployment:', missing[i]);
    }
    assertEq(missing.length, 0, 'deployment addresses not set');
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  /// forge-config: default.isolate = true
  function test_defaultProposalExecution() public deployed {
    defaultTest(
      'AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2',
      AaveV3Avalanche.POOL,
      address(proposal)
    );
  }

  /// @dev Part 2 reverts while the bridged GHO has not reached the Collector
  function test_executionFailsNoFunds() public deployed {
    vm.revertToState(preDeliveryState);
    assertLt(
      IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(address(AaveV3Avalanche.COLLECTOR)),
      Setup.GHO_BRIDGE_AMOUNT
    );

    vm.prank(address(GovernanceV3Avalanche.PAYLOADS_CONTROLLER));
    vm.expectRevert();
    IExecutor(GovernanceV3Avalanche.EXECUTOR_LVL_1).executeTransaction(
      address(proposal),
      0,
      'execute()',
      '',
      true
    );
  }

  function test_reserveFunded() public deployed {
    address reserve = address(proposal.GHO_RESERVE());
    uint256 collectorBefore = IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(
      address(AaveV3Avalanche.COLLECTOR)
    );
    uint256 reserveBefore = IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(reserve);

    executePayload(vm, address(proposal));

    assertEq(
      IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(address(AaveV3Avalanche.COLLECTOR)),
      collectorBefore - Setup.GHO_BRIDGE_AMOUNT
    );
    assertEq(
      IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(reserve),
      reserveBefore + Setup.GHO_BRIDGE_AMOUNT
    );
  }

  function test_gsmConfig() public deployed {
    executePayload(vm, address(proposal));

    assertEq(gsm.getGhoReserve(), address(proposal.GHO_RESERVE()));
    assertTrue(proposal.GHO_RESERVE().isEntity(address(gsm)));
    assertEq(proposal.GHO_RESERVE().getLimit(address(gsm)), Setup.GSM_RESERVE_LIMIT);
    assertEq(gsm.getExposureCap(), Setup.GSM_EXPOSURE_CAP);
    assertEq(gsm.getFeeStrategy(), address(0), 'fees are 0/0, no strategy');
    assertEq(gsm.GHO_TOKEN(), GhoAvalanche.GHO_TOKEN);
    assertFalse(gsm.getIsFrozen());
    assertFalse(gsm.getIsSeized());
    assertFalse(gsm.getIsBuyAccessOpen());
    assertFalse(gsm.getIsSellAccessOpen());
  }

  function test_roles() public deployed {
    executePayload(vm, address(proposal));

    IAccessControl reserve = IAccessControl(address(proposal.GHO_RESERVE()));
    assertTrue(
      reserve.hasRole(proposal.GHO_RESERVE().LIMIT_MANAGER_ROLE(), GhoAvalanche.RISK_COUNCIL)
    );

    assertTrue(gsm.hasRole(gsm.CONFIGURATOR_ROLE(), proposal.GHO_GSM_STEWARD()));
    assertTrue(gsm.hasRole(gsm.SWAP_FREEZER_ROLE(), GovernanceV3Avalanche.EXECUTOR_LVL_1));
    assertTrue(gsm.hasRole(gsm.SWAP_ACCESS_MANAGER_ROLE(), GovernanceV3Avalanche.EXECUTOR_LVL_1));
    assertTrue(gsm.hasRole(gsm.SWAP_ACCESS_MANAGER_ROLE(), GhoAvalanche.RISK_COUNCIL));

    address[2] memory swappers = [proposal.APPROVED_DAO_SAFE(), proposal.APPROVED_COUNTERPARTY()];
    for (uint256 i = 0; i < swappers.length; i++) {
      assertTrue(gsm.hasRole(gsm.BUY_ASSET_ROLE(), swappers[i]));
      assertTrue(gsm.hasRole(gsm.SELL_ASSET_ROLE(), swappers[i]));
    }
  }

  /// @dev The GSM is deployed already pointing at the reserve with the 20M cap; the payload does not set them
  function test_deploymentState() public deployed {
    assertEq(gsm.getGhoReserve(), address(proposal.GHO_RESERVE()));
    assertEq(gsm.getExposureCap(), Setup.GSM_EXPOSURE_CAP);
    assertEq(gsm.getFeeStrategy(), address(0));
    assertTrue(gsm.hasRole(bytes32(0), GovernanceV3Avalanche.EXECUTOR_LVL_1));
    assertTrue(
      IAccessControl(address(proposal.GHO_RESERVE())).hasRole(
        bytes32(0),
        GovernanceV3Avalanche.EXECUTOR_LVL_1
      )
    );
  }

  /// @dev With no fee strategy, the steward cannot set fees; governance must call updateFeeStrategy first
  function test_stewardCannotSetFeesWithoutStrategy() public deployed {
    executePayload(vm, address(proposal));

    vm.prank(GhoAvalanche.RISK_COUNCIL);
    vm.expectRevert(bytes('FIXED_FEE_STRATEGY_NOT_FOUND'));
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmBuySellFees(address(gsm), 10, 0);
  }

  function test_permissionedSwap() public deployed {
    executePayload(vm, address(proposal));

    address safe = proposal.APPROVED_DAO_SAFE();
    IERC20 underlying = IERC20(gsm.UNDERLYING_ASSET());
    deal(address(underlying), safe, SWAP_AMOUNT);

    vm.startPrank(safe);
    underlying.approve(address(gsm), SWAP_AMOUNT);
    (, uint256 ghoBought) = gsm.sellAsset(SWAP_AMOUNT, safe);
    assertEq(IERC20(GhoAvalanche.GHO_TOKEN).balanceOf(safe), ghoBought);
    assertEq(proposal.GHO_RESERVE().getUsed(address(gsm)), ghoBought);

    IERC20(GhoAvalanche.GHO_TOKEN).approve(address(gsm), ghoBought);
    (uint256 assetBought, ) = gsm.buyAsset(SWAP_AMOUNT, safe);
    vm.stopPrank();

    assertEq(assetBought, SWAP_AMOUNT, 'fees are 0/0, round trip is lossless');
    assertEq(underlying.balanceOf(safe), SWAP_AMOUNT);
    assertEq(proposal.GHO_RESERVE().getUsed(address(gsm)), 0);
  }

  function test_unapprovedCallerCannotSwap() public deployed {
    executePayload(vm, address(proposal));

    // Fund the GSM so buyAsset has liquidity, and the stranger with both tokens, so only the role check can revert
    address safe = proposal.APPROVED_DAO_SAFE();
    deal(gsm.UNDERLYING_ASSET(), safe, SWAP_AMOUNT);
    vm.startPrank(safe);
    IERC20(gsm.UNDERLYING_ASSET()).approve(address(gsm), SWAP_AMOUNT);
    (, uint256 ghoAmount) = gsm.sellAsset(SWAP_AMOUNT, safe);
    vm.stopPrank();

    address stranger = makeAddr('stranger');
    deal(gsm.UNDERLYING_ASSET(), stranger, SWAP_AMOUNT);
    deal(GhoAvalanche.GHO_TOKEN, stranger, ghoAmount);

    vm.startPrank(stranger);
    IERC20(gsm.UNDERLYING_ASSET()).approve(address(gsm), SWAP_AMOUNT);
    IERC20(GhoAvalanche.GHO_TOKEN).approve(address(gsm), ghoAmount);
    vm.expectRevert(
      abi.encodeWithSelector(
        IAccessControl.AccessControlUnauthorizedAccount.selector,
        stranger,
        gsm.SELL_ASSET_ROLE()
      )
    );
    gsm.sellAsset(SWAP_AMOUNT, stranger);
    vm.expectRevert(
      abi.encodeWithSelector(
        IAccessControl.AccessControlUnauthorizedAccount.selector,
        stranger,
        gsm.BUY_ASSET_ROLE()
      )
    );
    gsm.buyAsset(SWAP_AMOUNT, stranger);
    vm.stopPrank();
  }

  function test_riskCouncilManagesAccess() public deployed {
    executePayload(vm, address(proposal));

    address newCounterparty = makeAddr('newCounterparty');
    vm.startPrank(GhoAvalanche.RISK_COUNCIL);
    gsm.grantRole(gsm.SELL_ASSET_ROLE(), newCounterparty);
    gsm.revokeRole(gsm.BUY_ASSET_ROLE(), proposal.APPROVED_COUNTERPARTY());
    gsm.setBuyAccessOpen(true);
    gsm.setSellAccessOpen(true);
    vm.stopPrank();

    assertTrue(gsm.hasRole(gsm.SELL_ASSET_ROLE(), newCounterparty));
    assertFalse(gsm.hasRole(gsm.BUY_ASSET_ROLE(), proposal.APPROVED_COUNTERPARTY()));
    assertTrue(gsm.getIsBuyAccessOpen());
    assertTrue(gsm.getIsSellAccessOpen());
  }

  function test_stewardUpdatesExposureCap() public deployed {
    executePayload(vm, address(proposal));

    uint128 newCap = Setup.GSM_EXPOSURE_CAP * 2;
    vm.prank(GhoAvalanche.RISK_COUNCIL);
    IGsmSteward(proposal.GHO_GSM_STEWARD()).updateGsmExposureCap(address(gsm), newCap);
    assertEq(gsm.getExposureCap(), newCap);
  }

  function test_bridgeLaneRestored() public deployed {
    assertEq(
      pool.getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM).capacity,
      Setup.TEMP_BRIDGE_CAPACITY,
      'pre: Part 1 widened the inbound lane'
    );

    executePayload(vm, address(proposal));

    _assertDefault(pool.getCurrentInboundRateLimiterState(CCIPChainSelectors.ETHEREUM));
    _assertDefault(pool.getCurrentOutboundRateLimiterState(CCIPChainSelectors.ETHEREUM));
  }

  function test_otherLanesUntouched() public deployed {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.ETHEREUM,
      false
    );
    IRateLimiter.TokenBucket[] memory inboundBefore = new IRateLimiter.TokenBucket[](chains.length);
    IRateLimiter.TokenBucket[] memory outboundBefore = new IRateLimiter.TokenBucket[](
      chains.length
    );
    for (uint256 i = 0; i < chains.length; i++) {
      if (chains[i].chainSelector == CCIPChainSelectors.AVALANCHE) continue;
      inboundBefore[i] = pool.getCurrentInboundRateLimiterState(chains[i].chainSelector);
      outboundBefore[i] = pool.getCurrentOutboundRateLimiterState(chains[i].chainSelector);
    }

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
      if (chains[i].chainSelector == CCIPChainSelectors.AVALANCHE) continue;
      _assertSameConfig(
        pool.getCurrentInboundRateLimiterState(chains[i].chainSelector),
        inboundBefore[i]
      );
      _assertSameConfig(
        pool.getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        outboundBefore[i]
      );
    }
  }

  function _missingAddresses() internal view returns (string[] memory) {
    string[4] memory names = [
      'GHO_RESERVE',
      'GHO_GSM_STEWARD',
      'GSM_USAT',
      'APPROVED_COUNTERPARTY'
    ];
    address[4] memory values = [
      address(proposal.GHO_RESERVE()),
      proposal.GHO_GSM_STEWARD(),
      address(proposal.GSM_USAT()),
      proposal.APPROVED_COUNTERPARTY()
    ];
    uint256 count;
    for (uint256 i = 0; i < values.length; i++) {
      if (values[i] == address(0)) count++;
    }
    string[] memory missing = new string[](count);
    count = 0;
    for (uint256 i = 0; i < values.length; i++) {
      if (values[i] == address(0)) missing[count++] = names[i];
    }
    return missing;
  }

  function _assertDefault(IRateLimiter.TokenBucket memory bucket) internal pure {
    assertTrue(bucket.isEnabled);
    assertEq(bucket.capacity, Setup.DEFAULT_RATE_LIMITER_CAPACITY);
    assertEq(bucket.rate, Setup.DEFAULT_LIMITER_RATE);
  }

  function _assertSameConfig(
    IRateLimiter.TokenBucket memory a,
    IRateLimiter.TokenBucket memory b
  ) internal pure {
    assertEq(a.capacity, b.capacity, 'capacity changed');
    assertEq(a.rate, b.rate, 'rate changed');
    assertEq(a.isEnabled, b.isEnabled, 'isEnabled changed');
  }
}
