// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @title Remote GSM Launch: Monad
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Arbitrum_RemoteGSMLaunchMonad_20260701 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Arbitrum, accounting for the extra
    // supply minted on Ethereum and initially bridged to Monad in this proposal.
    // NOTE: unlike the Arbitrum RemoteGSM launch, this proposal does NOT normalize the lane
    // rate-limit config here. GHO lane capacities are left untouched on Arbitrum; only the
    // facilitator bucket capacity is bumped to cover the newly minted 50M GHO.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoArbitrum.GHO_TOKEN)
      .getFacilitatorBucket(GhoArbitrum.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoArbitrum.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
