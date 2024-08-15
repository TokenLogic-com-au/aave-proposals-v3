// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
/**
 * @title Add Flashborrowers
 * @author Karpatkey_Tokenlogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Optimism_AddFlashborrowers_20240815 is IProposalGenericExecutor {
  address public constant CIAN_PROTOCOL_FLASHLOAN_HELPER =
    0x49d9409111a6363d82C4371fFa43fAEA660C917B;

  function execute() external {
    AaveV3Optimism.ACL_MANAGER.addFlashBorrower(CIAN_PROTOCOL_FLASHLOAN_HELPER);
  }
}
