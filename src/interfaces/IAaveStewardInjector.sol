// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IAaveStewardInjector
 * @author BGD Labs
 * @notice Interface of the AaveStewardInjectorBase contract
 * @dev Adapted from https://github.com/aave-dao/aave-v3-risk-stewards/blob/e9f89fd7678553f8084f4ba6f311a6089ce107bd/src/contracts/AaveStewardInjectorBase.sol
 * @dev Adapted from https://github.com/aave-dao/aave-v3-risk-stewards/blob/e9f89fd7678553f8084f4ba6f311a6089ce107bd/src/contracts/AaveStewardInjectorEMode.sol
 */
interface IAaveStewardInjector {
  struct EModeCategoryUpdate {
    uint256 ltv;
    uint256 liqThreshold;
    uint256 liqBonus;
  }

  function getMarkets() external view returns (address[] memory);

  function addMarkets(address[] calldata markets) external;

  function removeMarkets(address[] calldata markets) external;

  function getUpdateTypes() external pure returns (string[] memory updateTypes);

  function RISK_STEWARD() external view returns (address);

  function RISK_ORACLE() external view returns (address);
}
