// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title IStkGhoMigrator
 * @notice Interface of the StkGhoMigrator contract
 * @dev Adapted from https://github.com/aave-dao/gho-origin/blob/2af44932a8a632fd74b44adb4c92a4b51700e25a/src/contracts/misc/interfaces/IStkGhoMigrator.sol
 */
interface IStkGhoMigrator {
  event StkGhoMigrated(address indexed user, uint256 amount);

  function claimHelperRole() external;
  function setClaimHelperPendingAdmin(address newPendingAdmin) external;
  function pause() external;
  function unpause() external;
  function migrate() external;
  function owner() external view returns (address);
  function pendingOwner() external view returns (address);
  function guardian() external view returns (address);
  function paused() external view returns (bool);
  function STKGHO() external view returns (address);
  function SGHO() external view returns (address);
  function GHO() external view returns (address);
  function CLAIM_HELPER_ROLE() external view returns (uint256);
}
