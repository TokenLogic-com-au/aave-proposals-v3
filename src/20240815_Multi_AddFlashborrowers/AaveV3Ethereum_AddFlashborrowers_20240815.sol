// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
/**
 * @title Add Flashborrowers
 * @author Karpatkey_Tokenlogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Ethereum_AddFlashborrowers_20240815 is IProposalGenericExecutor {
  address public constant CIAN_PROTOCOL_FLASHLOAN_HELPER =
    0x49d9409111a6363d82C4371fFa43fAEA660C917B;

  function execute() external {
    AaveV3Ethereum.ACL_MANAGER.addFlashBorrower(CIAN_PROTOCOL_FLASHLOAN_HELPER);
  }
}
