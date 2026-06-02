// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPoolExposureSteward {
  /// @notice Withdraws a specified amount of a reserve token from Aave V3
  /// @param V3Pool The address of the V3 pool to withdraw from
  /// @param underlying The address of the reserve token to withdraw
  /// @param amount The amount of the reserve token to withdraw
  function withdrawV3(address V3Pool, address underlying, uint256 amount) external;
}
