// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IFixedPriceStrategy4626
 * @author Aave
 * @notice Interface of the GsmPriceStrategy contract
 * @dev Adapted from https://github.com/aave-dao/gho-origin/blob/731776bc2c5d231271d4bdca93b6ff92231aeb51/src/contracts/facilitators/gsm/priceStrategy/interfaces/IGsmPriceStrategy.sol
 */
interface IFixedPriceStrategy4626 {
  function getAssetPriceInGho(uint256 assetAmount, bool roundUp) external view returns (uint256);
  function getGhoPriceInAsset(uint256 ghoAmount, bool roundUp) external view returns (uint256);
}
