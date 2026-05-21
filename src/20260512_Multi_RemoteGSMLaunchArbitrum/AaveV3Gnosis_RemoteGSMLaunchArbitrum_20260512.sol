// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoGnosis} from 'aave-address-book/GhoGnosis.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

import {RemoteGSMLaunchArbitrumConstants} from './setup/RemoteGSMLaunchArbitrumConstants.sol';

/**
 * @title Remote GSM Launch: Arbitrum
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Gnosis_RemoteGSMLaunchArbitrum_20260512 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Gnosis, accounting for the extra capacity initially bridged
    // to Arbitrum in this proposal.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoGnosis.GHO_TOKEN)
      .getFacilitatorBucket(GhoGnosis.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoGnosis.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoGnosis.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchArbitrumConstants.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
