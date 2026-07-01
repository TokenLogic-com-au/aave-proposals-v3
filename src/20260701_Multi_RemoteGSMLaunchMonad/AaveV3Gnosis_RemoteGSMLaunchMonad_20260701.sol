// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoGnosis} from 'aave-address-book/GhoGnosis.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @title Remote GSM Launch: Monad
 * @author TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/TODO
 * - Discussion: https://governance.aave.com/t/TODO-arfc-launch-remotegsm-on-monad
 */
contract AaveV3Gnosis_RemoteGSMLaunchMonad_20260701 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Gnosis, accounting for the extra supply minted
    // on Ethereum and initially bridged to Monad in this proposal.
    // NOTE: this proposal does NOT normalize lane rate-limit config; GHO lane capacities are left
    // untouched (only the facilitator bucket capacity is bumped).
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoGnosis.GHO_TOKEN)
      .getFacilitatorBucket(GhoGnosis.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoGnosis.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoGnosis.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
