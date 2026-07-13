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
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/0x24f105bd023c476a9b85fa87ff795bfeec769fa799ce6ada8e2724c9738049f6
 * - Discussion: https://governance.aave.com/t/arfc-deploy-aave-protocol-v3-7-on-monad/24943
 */
contract AaveV3Arbitrum_RemoteGSMLaunchMonad_20260701 is IProposalGenericExecutor {
  using SafeCast for uint256;

  function execute() external {
    // Increase bucket capacity to allow token movements to Arbitrum, accounting for the extra
    // supply minted on Ethereum and initially bridged to Monad in this proposal.
    (uint256 currentFacilitatorBucketCapacity, ) = IGhoToken(GhoArbitrum.GHO_TOKEN)
      .getFacilitatorBucket(GhoArbitrum.GHO_CCIP_TOKEN_POOL);

    IGhoToken(GhoArbitrum.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL,
      currentFacilitatorBucketCapacity.toUint128() +
        RemoteGSMLaunchMonadSetup.GHO_BRIDGE_AMOUNT.toUint128()
    );
  }
}
