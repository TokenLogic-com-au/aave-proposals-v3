// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IBaseAaveAgent
 * @notice Getters shared by the Aave agent contracts
 * @dev Written for this repository; no upstream interface.
 */
interface IBaseAaveAgent {
  function RANGE_VALIDATION_MODULE() external view returns (address);
  function POOL() external view returns (address);
  function AGENT_HUB() external view returns (address);
  function getUpdateType() external view returns (string memory);
}

/**
 * @title IAaveDiscountRateAgent
 * @notice Exposes the Aave oracle of a discount rate agent
 * @dev Written for this repository; no upstream interface.
 */
interface IAaveDiscountRateAgent is IBaseAaveAgent {
  function AAVE_ORACLE() external view returns (address);
}
