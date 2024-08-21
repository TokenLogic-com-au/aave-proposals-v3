// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
/**
 * @title Add Flash Borrowers
 * @author Karpatkey_Tokenlogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Arbitrum_AddFlashBorrowers_20240821 is IProposalGenericExecutor {
  address public constant CIAN_FLASH_LOAN_HELPER = 0x49d9409111a6363d82C4371fFa43fAEA660C917B;

  function execute() external {
    AaveV3Arbitrum.ACL_MANAGER.addFlashBorrower(CIAN_FLASH_LOAN_HELPER);
  }
}
