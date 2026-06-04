// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoXLayer} from 'aave-address-book/GhoXLayer.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';

import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @title Remote GSM Launch: X-Layer
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3XLayer_RemoteGSMLaunchXLayer_20260526_Part1 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow minting the bridged GHO on X-Layer.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoXLayer.GHO_TOKEN)
      .getFacilitatorBucket(GhoXLayer.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoXLayer.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoXLayer.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT.toUint128()
    );

    // Temporarily increase the maximum bridge limit (inbound capacity; counterpart to Ethereum / Part 1 step)
    IUpgradeableBurnMintTokenPool(GhoXLayer.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchXLayerConstants.DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchXLayerConstants.TEMP_BRIDGE_CAPACITY,
        rate: RemoteGSMLaunchXLayerConstants.TEMP_BRIDGE_CAPACITY - 1 // Set rate to capacity so it fills to limit right away (-1 because they cannot be the same)
      })
    );
  }
}
