// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';

import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @title Remote GSM Launch: X-Layer
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Ethereum_RemoteGSMLaunchXLayer_20260526_Part1 is IProposalGenericExecutor {
  function execute() external {
    // Increment bridge limit to accommodate the amount to bridge.
    uint256 currentBridgeLimit = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getBridgeLimit();
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      currentBridgeLimit + RemoteGSMLaunchXLayerConstants.TEMP_BRIDGE_CAPACITY
    );

    // Temporarily increase the maximum bridge limit (outbound capacity)
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.XLAYER,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: uint128(RemoteGSMLaunchXLayerConstants.TEMP_BRIDGE_CAPACITY),
        rate: uint128(RemoteGSMLaunchXLayerConstants.TEMP_BRIDGE_CAPACITY) - 1 // Set rate to new capacity so it refills immediately
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE
      })
    );
  }
}
