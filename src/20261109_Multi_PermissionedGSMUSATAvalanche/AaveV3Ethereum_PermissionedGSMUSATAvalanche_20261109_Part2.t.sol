// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IAaveGhoCcipBridge} from 'aave-helpers/src/bridges/ccip/interfaces/IAaveGhoCcipBridge.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGhoDirectFacilitator} from 'src/interfaces/IGhoDirectFacilitator.sol';

import {AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1} from './AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.sol';
import {AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2} from './AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.sol';
import {PermissionedGSMUSATAvalancheSetup as Setup} from './setup/PermissionedGSMUSATAvalancheSetup.sol';

/**
 * @dev Test for AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol -vv
 *
 * Tests that execute the payload are skipped while DIRECT_FACILITATOR is unset;
 * `test_deploymentAddressesSet` fails until it is.
 */
contract AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2_Test is ProtocolV3TestBase {
  AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1 internal part1;
  AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2 internal proposal;
  // GhoDirectFacilitator registered for the Monad remote GSM (aave-proposals-v3 PR 1158)
  // https://etherscan.io/address/0x0cB7C2A2Ab38Aed3e6096631D7Dba3DaBf237134
  address internal constant MONAD_DIRECT_FACILITATOR = 0x0cB7C2A2Ab38Aed3e6096631D7Dba3DaBf237134;

  IUpgradeableLockReleaseTokenPool internal pool =
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL);

  modifier deployed() {
    if (proposal.DIRECT_FACILITATOR() == address(0)) {
      vm.skip(true, 'DIRECT_FACILITATOR pending deployment');
    }
    _;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 26378000);
    part1 = new AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1();
    proposal = new AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2();

    executePayload(vm, address(part1));
    vm.warp(block.timestamp + 1); // outbound bucket refill
  }

  function test_deploymentAddressesSet() public view {
    assertTrue(proposal.DIRECT_FACILITATOR() != address(0), 'DIRECT_FACILITATOR not set');
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  /// forge-config: default.isolate = true
  function test_defaultProposalExecution() public deployed {
    defaultTest(
      'AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_directFacilitatorDeployment() public deployed {
    IGhoDirectFacilitator facilitator = IGhoDirectFacilitator(proposal.DIRECT_FACILITATOR());
    assertTrue(facilitator.hasRole(bytes32(0), GovernanceV3Ethereum.EXECUTOR_LVL_1));
    assertTrue(facilitator.hasRole(facilitator.MINTER_ROLE(), GovernanceV3Ethereum.EXECUTOR_LVL_1));
    assertEq(
      address(facilitator).codehash,
      MONAD_DIRECT_FACILITATOR.codehash,
      'bytecode differs from the governance-registered Monad facilitator'
    );
  }

  function test_ccipBridgeIdentity() public view {
    IAaveGhoCcipBridge bridge = IAaveGhoCcipBridge(GhoEthereum.GHO_CCIP_BRIDGE);
    assertEq(bridge.GHO_TOKEN(), AaveV3EthereumAssets.GHO_UNDERLYING);
    assertEq(bridge.COLLECTOR(), address(AaveV3Ethereum.COLLECTOR));
    assertEq(bridge.ROUTER(), pool.getRouter());
    assertEq(pool.getToken(), AaveV3EthereumAssets.GHO_UNDERLYING);
  }

  /// @dev The fee is paid from the bridge's own LINK balance; the payload sends none
  function test_bridgeLinkCoversFee() public {
    IAaveGhoCcipBridge bridge = IAaveGhoCcipBridge(GhoEthereum.GHO_CCIP_BRIDGE);
    uint32 gasLimit = proposal.AVALANCHE_BRIDGE_GAS_LIMIT();
    vm.prank(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    bridge.setDestinationChain(
      CCIPChainSelectors.AVALANCHE,
      abi.encode(GhoAvalanche.GHO_CCIP_BRIDGE),
      bytes(''),
      gasLimit
    );

    uint256 fee = bridge.quoteBridge(
      CCIPChainSelectors.AVALANCHE,
      Setup.GHO_BRIDGE_AMOUNT,
      AaveV3EthereumAssets.LINK_UNDERLYING
    );
    uint256 linkBalance = IERC20(AaveV3EthereumAssets.LINK_UNDERLYING).balanceOf(address(bridge));
    emit log_named_decimal_uint('CCIP fee (LINK)', fee, 18);
    emit log_named_decimal_uint('bridge LINK balance', linkBalance, 18);
    assertGe(linkBalance, fee, 'bridge LINK balance below the CCIP fee');
  }

  function test_ccipBridgeDestinationChainSetUp() public deployed {
    IAaveGhoCcipBridge bridge = IAaveGhoCcipBridge(GhoEthereum.GHO_CCIP_BRIDGE);
    assertEq(
      bridge.getDestinationRemoteConfig(CCIPChainSelectors.AVALANCHE).destination,
      new bytes(0),
      'pre: Avalanche destination unset'
    );

    executePayload(vm, address(proposal));

    IAaveGhoCcipBridge.RemoteChainConfig memory config = bridge.getDestinationRemoteConfig(
      CCIPChainSelectors.AVALANCHE
    );
    assertEq(config.destination, abi.encode(GhoAvalanche.GHO_CCIP_BRIDGE));
    assertEq(config.extraArgsOverride, new bytes(0));
    assertEq(config.gasLimit, proposal.AVALANCHE_BRIDGE_GAS_LIMIT());
  }

  function test_bridge() public deployed {
    IGhoToken gho = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING);
    assertEq(gho.getFacilitator(proposal.DIRECT_FACILITATOR()).bucketCapacity, 0);
    uint256 poolGhoBefore = IERC20(address(gho)).balanceOf(GhoEthereum.GHO_CCIP_TOKEN_POOL);

    vm.expectEmit(false, true, true, true, GhoEthereum.GHO_CCIP_BRIDGE);
    emit IAaveGhoCcipBridge.BridgeMessageInitiated(
      bytes32(0),
      CCIPChainSelectors.AVALANCHE,
      GovernanceV3Ethereum.EXECUTOR_LVL_1,
      Setup.GHO_BRIDGE_AMOUNT
    );

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory facilitator = gho.getFacilitator(proposal.DIRECT_FACILITATOR());
    assertEq(facilitator.bucketCapacity, Setup.DIRECT_FACILITATOR_CAPACITY);
    assertEq(facilitator.bucketLevel, Setup.GHO_BRIDGE_AMOUNT);
    assertEq(facilitator.label, proposal.DIRECT_FACILITATOR_NAME());
    assertEq(
      IERC20(address(gho)).balanceOf(GhoEthereum.GHO_CCIP_TOKEN_POOL),
      poolGhoBefore + Setup.GHO_BRIDGE_AMOUNT,
      'GHO not locked in the token pool'
    );
    assertEq(IERC20(address(gho)).balanceOf(GovernanceV3Ethereum.EXECUTOR_LVL_1), 0);
    assertEq(
      IERC20(address(gho)).allowance(
        GovernanceV3Ethereum.EXECUTOR_LVL_1,
        GhoEthereum.GHO_CCIP_BRIDGE
      ),
      0
    );
  }

  function test_bridgeLaneRestored() public deployed {
    assertEq(
      pool.getCurrentOutboundRateLimiterState(CCIPChainSelectors.AVALANCHE).capacity,
      Setup.TEMP_BRIDGE_CAPACITY,
      'pre: Part 1 widened the outbound lane'
    );

    executePayload(vm, address(proposal));

    _assertDefault(pool.getCurrentOutboundRateLimiterState(CCIPChainSelectors.AVALANCHE));
    _assertDefault(pool.getCurrentInboundRateLimiterState(CCIPChainSelectors.AVALANCHE));
  }

  function test_otherLanesUntouched() public deployed {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.AVALANCHE,
      false
    );
    IRateLimiter.TokenBucket[] memory inboundBefore = new IRateLimiter.TokenBucket[](chains.length);
    IRateLimiter.TokenBucket[] memory outboundBefore = new IRateLimiter.TokenBucket[](
      chains.length
    );
    for (uint256 i = 0; i < chains.length; i++) {
      inboundBefore[i] = pool.getCurrentInboundRateLimiterState(chains[i].chainSelector);
      outboundBefore[i] = pool.getCurrentOutboundRateLimiterState(chains[i].chainSelector);
    }

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
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
