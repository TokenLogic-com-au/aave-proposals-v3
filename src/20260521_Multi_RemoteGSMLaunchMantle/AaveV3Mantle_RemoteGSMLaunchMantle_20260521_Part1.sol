// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoMantle} from 'aave-address-book/GhoMantle.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';

import {RemoteGSMLaunchMantleConstants} from './setup/RemoteGSMLaunchMantleConstants.sol';

/**
 * @title Remote GSM Launch: Mantle
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow minting the bridged GHO on Mantle.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoMantle.GHO_TOKEN)
      .getFacilitatorBucket(GhoMantle.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoMantle.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoMantle.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMantleConstants.GHO_BRIDGE_AMOUNT.toUint128()
    );

    // Temporarily increase the maximum bridge limit (inbound capacity; counterpart to Ethereum / Part 1 step)
    IUpgradeableBurnMintTokenPool(GhoMantle.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_CAPACITY,
        rate: RemoteGSMLaunchMantleConstants.DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: RemoteGSMLaunchMantleConstants.TEMP_BRIDGE_CAPACITY,
        rate: RemoteGSMLaunchMantleConstants.TEMP_BRIDGE_CAPACITY - 1 // Set rate to capacity so it fills to limit right away (-1 because they cannot be the same)
      })
    );
  }
}
