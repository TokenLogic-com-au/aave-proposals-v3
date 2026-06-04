// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {RemoteGSMLaunchXLayerConstants} from './setup/RemoteGSMLaunchXLayerConstants.sol';

/**
 * @title Remote GSM Launch: X-Layer
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Arbitrum_RemoteGSMLaunchXLayer_20260526 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Arbitrum, accounting for the extra capacity initially bridged
    // to X-Layer in this proposal.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoArbitrum.GHO_TOKEN)
      .getFacilitatorBucket(GhoArbitrum.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoArbitrum.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchXLayerConstants.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
