// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ISafe
 * @author @safe-global/safe-protocol
 * @notice minimal interface for a Safe (Gnosis Safe) multisig, exposing the
 *         owner set and signature threshold used to assert the multisig setup
 * @dev Adapted from https://github.com/safe-global/safe-smart-account/blob/a2e19c6aa42a45ceec68057f3fa387f169c5b321/contracts/interfaces/IOwnerManager.sol
 */
interface ISafe {
  /**
   * @notice returns the number of required confirmations for a Safe transaction
   */
  function getThreshold() external view returns (uint256);

  /**
   * @notice returns the list of Safe owners
   */
  function getOwners() external view returns (address[] memory);
}
