// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';

import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @title Remote GSM Launch: Monad
 * @author TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/TODO
 * - Discussion: https://governance.aave.com/t/TODO-arfc-launch-remotegsm-on-monad
 */
contract AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1 is IProposalGenericExecutor {
  function execute() external {
    // Increment bridge limit to accommodate the amount to bridge.
    uint256 currentBridgeLimit = IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL)
      .getBridgeLimit();
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      currentBridgeLimit + RemoteGSMLaunchMonadSetup.TEMP_BRIDGE_CAPACITY
    );

    // Temporarily increase the Ethereum -> Monad outbound capacity for the one-off 50M seed
    // bridge. The inbound (Monad -> Ethereum) direction is set to the standard config; it is not
    // widened here and is left at the value Part 2 restores the lane to.
    // TODO: this assumes the inbound direction already sits at DEFAULT_RATE_LIMITER_* on-chain; if
    // it does not, mirror the real pre-execution inbound config so this lane stays unchanged.
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.MONAD,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: uint128(RemoteGSMLaunchMonadSetup.TEMP_BRIDGE_CAPACITY),
        rate: uint128(RemoteGSMLaunchMonadSetup.TEMP_BRIDGE_CAPACITY) - 1 // Set rate to new capacity so it refills immediately
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchMonadSetup.DEFAULT_RATE_LIMITER_RATE
      })
    );
  }
}
