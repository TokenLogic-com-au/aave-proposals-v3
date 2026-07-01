// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoInk} from 'aave-address-book/GhoInk.sol';
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
contract AaveV3Ink_RemoteGSMLaunchMonad_20260701 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Ink, accounting for the extra supply minted
    // on Ethereum and initially bridged to Monad in this proposal.
    // NOTE: this proposal does NOT normalize lane rate-limit config; GHO lane capacities are left
    // untouched (only the facilitator bucket capacity is bumped).
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoInk.GHO_TOKEN).getFacilitatorBucket(
      GhoInk.GHO_CCIP_TOKEN_POOL
    );

    IGhoToken(GhoInk.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoInk.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
