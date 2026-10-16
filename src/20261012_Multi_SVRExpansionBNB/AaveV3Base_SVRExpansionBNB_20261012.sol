// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';

/**
 * @title SVR Expansion (BNB)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3Base_SVRExpansionBNB_20261012 is IProposalGenericExecutor {
  // https://basescan.org/address/0x4B09DAEAe857b93c9103392028294F0602C5fD5b
  address public constant STEWARD = 0x4B09DAEAe857b93c9103392028294F0602C5fD5b;

  function execute() external {
    AaveV3Base.ACL_MANAGER.removeAssetListingAdmin(STEWARD);
  }
}
