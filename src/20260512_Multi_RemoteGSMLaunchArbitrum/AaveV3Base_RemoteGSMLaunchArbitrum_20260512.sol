// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoBase} from 'aave-address-book/GhoBase.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

import {RemoteGSMLaunchArbitrumConstants} from './setup/RemoteGSMLaunchArbitrumConstants.sol';

/**
 * @title Remote GSM Launch: Arbitrum
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Base_RemoteGSMLaunchArbitrum_20260512 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Base, accounting for the extra capacity initially bridged
    // to Arbitrum in this proposal.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoBase.GHO_TOKEN)
      .getFacilitatorBucket(GhoBase.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoBase.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoBase.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchArbitrumConstants.GHO_BRIDGE_AMOUNT.toUint128()
    );

    // Normalize the Ethereum lane CCIP rate-limit config to canonical defaults.
    IUpgradeableBurnMintTokenPool(GhoBase.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchArbitrumConstants.DEFAULT_RATE_LIMITER_RATE
      })
    );
  }
}
