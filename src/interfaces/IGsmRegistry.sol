// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IGsmRegistry
 * @author Aave
 * @notice Interface of the GsmRegistry contract
 * @dev Adapted from https://github.com/aave/gho-core/blob/f368befef0fdabfab6a7934917184dcf90b11812/src/contracts/facilitators/gsm/misc/IGsmRegistry.sol
 */
interface IGsmRegistry {
  function addGsm(address gsmAddress) external;
  function removeGsm(address gsmAddress) external;
  function getGsmAtIndex(uint256 index) external returns (address);
  function getGsmListLength() external returns (uint256);
}
