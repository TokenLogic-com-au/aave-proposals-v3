// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {RemoteGSMLaunchMonadSetup} from './setup/RemoteGSMLaunchMonadSetup.sol';

/**
 * @title Remote GSM Launch: Monad
 * @author TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/0x24f105bd023c476a9b85fa87ff795bfeec769fa799ce6ada8e2724c9738049f6
 * - Discussion: https://governance.aave.com/t/arfc-deploy-aave-protocol-v3-7-on-monad/24943
 */
contract AaveV3Avalanche_RemoteGSMLaunchMonad_20260701 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Avalanche, accounting for the extra supply minted
    // on Ethereum and initially bridged to Monad in this proposal.
    // NOTE: this proposal does NOT normalize lane rate-limit config; GHO lane capacities are left
    // untouched (only the facilitator bucket capacity is bumped).
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoAvalanche.GHO_TOKEN)
      .getFacilitatorBucket(GhoAvalanche.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoAvalanche.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoAvalanche.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
