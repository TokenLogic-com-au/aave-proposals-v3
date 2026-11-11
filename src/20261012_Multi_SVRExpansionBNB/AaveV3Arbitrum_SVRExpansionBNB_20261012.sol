// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

/**
 * @title SVR Expansion (BNB)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3Arbitrum_SVRExpansionBNB_20261012 is IProposalGenericExecutor {
  // https://arbiscan.io/address/0x94E54D858e9293964b4ACd6f8938c831827a31F4
  address public constant SVR_ORACLE_STEWARD = 0x94E54D858e9293964b4ACd6f8938c831827a31F4;

  function execute() external {
    AaveV3Arbitrum.ACL_MANAGER.removeAssetListingAdmin(SVR_ORACLE_STEWARD);
  }
}
