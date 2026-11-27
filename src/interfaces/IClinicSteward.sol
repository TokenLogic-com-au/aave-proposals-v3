// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title IClinicSteward
 * @notice Interface of the ClinicSteward contract
 * @dev Adapted from https://github.com/aave-dao/aave-stewards/blob/7b93087c9e7b8e1fbe8bf98bb458b2a048bd1307/src/maintenance/interfaces/IClinicSteward.sol
 */
interface IClinicSteward {
  function availableBudget() external view returns (uint256);

  function setAvailableBudget(uint256 newAvailableBudget) external;
}
