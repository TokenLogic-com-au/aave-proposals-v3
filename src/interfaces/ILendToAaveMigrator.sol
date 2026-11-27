// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ILendToAaveMigrator
 * @author Aave
 * @notice Interface of the LendToAaveMigrator contract
 * @dev Adapted from https://github.com/aave-dao/lend-migrator-rescue/blob/cb6935113e3e2e72daacfe7743c9c77ac920407f/src/LendToAaveMigrator.sol
 */
interface ILendToAaveMigrator {
  event LendMigrated(address indexed sender, uint256 indexed amount);
  event AaveTokensRescued(address from, address indexed to, uint256 amount);

  error MigrationClosed();
  error ZeroAddress();

  function initialize() external;
  function migrationStarted() external view returns (bool);
  function migrationEnded() external view returns (bool);
  function migrateFromLEND(uint256) external;
}
