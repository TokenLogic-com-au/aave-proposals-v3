// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IAaveGhoCcipBridge} from 'aave-helpers/src/bridges/ccip/interfaces/IAaveGhoCcipBridge.sol';

import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IUpgradeableLockReleaseTokenPool} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2} from './AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.sol';

/**
 * @dev Test for AaveV3Ethereum_LaunchGHOOnPlasmaSetACIAsEmissionsManagerForRewards_20250930_Part2
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.t.sol -vv
 */
contract AaveV3Ethereum_LaunchGHOOnEthereumSetACIAsEmissionsManagerForRewards_20250930_Part2_Test is
  ProtocolV3TestBase
{
  /**
   * @dev Emitted when a new GHO transfer is issued
   * @param messageId The ID of the cross-chain message
   * @param destinationChainSelector The selector of the destination chain
   * @param from The address of sender on source chain
   * @param amount The total amount of GHO transferred
   */
  event BridgeMessageInitiated(
    bytes32 indexed messageId,
    uint64 indexed destinationChainSelector,
    address indexed from,
    uint256 amount
  );

  AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2 internal proposal;
  uint128 internal constant RATE_LIMIT_CAPACITY = 55_000_000 ether;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 24838165);
    proposal = new AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2();
  }

  function test_bridgeLimitRestore() public {
    // Mock the update from Part 1
    vm.startPrank(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      150_000_000 ether
    );

    IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.PLASMA,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RATE_LIMIT_CAPACITY,
        rate: RATE_LIMIT_CAPACITY - 1
      }),
      IRateLimiter.Config({isEnabled: true, capacity: 1_500_000 ether, rate: 300 ether})
    );
    vm.stopPrank();
    vm.warp(block.timestamp + 1);

    IRateLimiter.TokenBucket memory bucket = IUpgradeableBurnMintTokenPool(
      GhoEthereum.GHO_CCIP_TOKEN_POOL
    ).getCurrentOutboundRateLimiterState(CCIPChainSelectors.PLASMA);

    assertEq(bucket.capacity, RATE_LIMIT_CAPACITY);
    assertEq(bucket.rate, RATE_LIMIT_CAPACITY - 1);
    assertTrue(bucket.isEnabled);
    assertEq(bucket.tokens, RATE_LIMIT_CAPACITY);

    executePayload(vm, address(proposal));

    bucket = IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getCurrentOutboundRateLimiterState(CCIPChainSelectors.PLASMA);

    assertEq(bucket.capacity, proposal.NEW_DEFAULT_RATE_LIMITER_CAPACITY());
    assertEq(bucket.rate, proposal.NEW_DEFAULT_RATE_LIMITER_RATE());
    assertTrue(bucket.isEnabled);
    assertEq(bucket.tokens, proposal.NEW_DEFAULT_RATE_LIMITER_CAPACITY());
  }

  function test_bridge() public {
    vm.startPrank(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGhoToken.Facilitator memory facilitator = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING)
      .getFacilitator(GhoEthereum.GHO_DIRECT_FACILITATOR_PLASMA_GSMS);

    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      150_000_000 ether
    );

    IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.PLASMA,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RATE_LIMIT_CAPACITY,
        rate: RATE_LIMIT_CAPACITY - 1
      }),
      IRateLimiter.Config({isEnabled: true, capacity: 1_500_000 ether, rate: 300 ether})
    );
    vm.stopPrank();
    vm.warp(block.timestamp + 1);

    assertEq(facilitator.bucketCapacity, proposal.PLASMA_BRIDGE_AMOUNT());
    assertEq(facilitator.bucketLevel, proposal.PLASMA_BRIDGE_AMOUNT());

    uint256 fee = IAaveGhoCcipBridge(proposal.CCIP_BRIDGE()).quoteBridge(
      CCIPChainSelectors.PLASMA,
      proposal.PLASMA_BRIDGE_AMOUNT(),
      AaveV3EthereumAssets.LINK_UNDERLYING
    );

    uint256 feeBalance = IERC20(AaveV3EthereumAssets.LINK_UNDERLYING).balanceOf(
      proposal.CCIP_BRIDGE()
    );

    emit BridgeMessageInitiated(
      bytes32(0),
      CCIPChainSelectors.PLASMA,
      GovernanceV3Ethereum.EXECUTOR_LVL_1,
      proposal.PLASMA_BRIDGE_AMOUNT()
    );

    executePayload(vm, address(proposal));

    facilitator = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING).getFacilitator(
      GhoEthereum.GHO_DIRECT_FACILITATOR_PLASMA_GSMS
    );

    assertEq(facilitator.bucketCapacity, proposal.DIRECT_FACILITATOR_CAPACITY());
    assertEq(facilitator.bucketLevel, proposal.PLASMA_BRIDGE_AMOUNT() * 2);
    assertEq(
      IERC20(AaveV3EthereumAssets.LINK_UNDERLYING).balanceOf(proposal.CCIP_BRIDGE()),
      feeBalance - fee
    );
  }

  function test_tokenPoolLimits() public {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.ETHEREUM,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
          .getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        _getOldRateLimiterConfig()
      );
    }

    vm.startPrank(GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IGhoToken.Facilitator memory facilitator = IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING)
      .getFacilitator(GhoEthereum.GHO_DIRECT_FACILITATOR_PLASMA_GSMS);

    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      150_000_000 ether
    );

    IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.PLASMA,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RATE_LIMIT_CAPACITY,
        rate: RATE_LIMIT_CAPACITY - 1
      }),
      IRateLimiter.Config({isEnabled: true, capacity: 1_500_000 ether, rate: 300 ether})
    );
    vm.stopPrank();
    vm.warp(block.timestamp + 1);

    executePayload(vm, address(proposal));

    for (uint256 i = 0; i < chains.length; i++) {
      assertEq(
        IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
          .getCurrentInboundRateLimiterState(chains[i].chainSelector),
        _getRateLimiterConfig()
      );
      assertEq(
        IUpgradeableBurnMintTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
          .getCurrentOutboundRateLimiterState(chains[i].chainSelector),
        _getRateLimiterConfig()
      );
    }
  }

  function _getOldRateLimiterConfig() internal view virtual returns (IRateLimiter.Config memory) {
    return IRateLimiter.Config({isEnabled: true, capacity: 1_500_000e18, rate: 300e18});
  }

  function _getRateLimiterConfig() internal view virtual returns (IRateLimiter.Config memory) {
    return
      IRateLimiter.Config({
        isEnabled: true,
        capacity: proposal.NEW_DEFAULT_RATE_LIMITER_CAPACITY(),
        rate: proposal.NEW_DEFAULT_RATE_LIMITER_RATE()
      });
  }

  function assertEq(
    IRateLimiter.TokenBucket memory bucket,
    IRateLimiter.Config memory config
  ) internal view virtual {
    assertEq(bucket.isEnabled, config.isEnabled);
    assertEq(bucket.capacity, config.capacity);
    assertEq(bucket.rate, config.rate);
  }
}
