// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IAaveGhoCcipBridge} from 'aave-helpers/src/bridges/ccip/interfaces/IAaveGhoCcipBridge.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGhoDirectFacilitator} from 'src/interfaces/IGhoDirectFacilitator.sol';

/**
 * @title Remote GSM Launch: Arbitrum
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  // GhoDirectFacilitator Constants
  // TODO: deployed Arbitrum-specific GhoDirectFacilitator on Ethereum
  address public constant DIRECT_FACILITATOR = address(0);
  string public constant DIRECT_FACILITATOR_NAME = 'GhoDirectFacilitator Arbitrum';
  uint128 public constant DIRECT_FACILITATOR_CAPACITY = 50_000_000 ether;

  // TODO: confirm whether to reuse Plasma's AaveGhoCcipBridge (0x7F2f96fcdC3A29Be75938d2aC3D92E7006919fe6)
  // or use a different bridge for Arbitrum
  address public constant CCIP_BRIDGE = address(0);

  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 300 ether;
  uint256 public constant ARBITRUM_BRIDGE_AMOUNT = 50_000_000 ether;

  function execute() external {
    IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING).addFacilitator(
      DIRECT_FACILITATOR,
      DIRECT_FACILITATOR_NAME,
      DIRECT_FACILITATOR_CAPACITY
    );

    IGhoDirectFacilitator(DIRECT_FACILITATOR).mint(address(this), ARBITRUM_BRIDGE_AMOUNT);

    IERC20(AaveV3EthereumAssets.GHO_UNDERLYING).approve(CCIP_BRIDGE, ARBITRUM_BRIDGE_AMOUNT);

    // Bridge already has LINK to bridge, no need to send for fee
    IAaveGhoCcipBridge(CCIP_BRIDGE).send(
      CCIPChainSelectors.ARBITRUM,
      ARBITRUM_BRIDGE_AMOUNT,
      AaveV3EthereumAssets.LINK_UNDERLYING
    );

    // Restore bridge limit
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ARBITRUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: DEFAULT_RATE_LIMITER_CAPACITY,
        rate: DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: DEFAULT_RATE_LIMITER_CAPACITY,
        rate: DEFAULT_RATE_LIMITER_RATE
      })
    );
  }
}
