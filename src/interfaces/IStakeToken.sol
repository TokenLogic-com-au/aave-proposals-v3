// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IStakeToken
 * @author BGD labs
 * @notice Interface of the StakeToken contract
 * @dev Adapted from https://github.com/aave-dao/aave-umbrella/blob/c279bf145eb58e013fd24f97b10e4bf6058236a1/src/contracts/stakeToken/StakeToken.sol
 */
interface IStakeToken {
  function paused() external view returns (bool);
}
