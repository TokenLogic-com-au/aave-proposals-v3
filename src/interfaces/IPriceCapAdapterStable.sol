// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPriceCapAdapterStable
 * @notice Interface of the PriceCapAdapterStable contract
 * @dev Adapted from https://github.com/aave-dao/aave-price-feeds/blob/ee7b97cadf89b7a006871aa6f060ae3651ca9cd0/src/interfaces/IPriceCapAdapterStable.sol
 */
interface IPriceCapAdapterStable {
  function isCapped() external view returns (bool);
  function getPriceCap() external view returns (int256);
  function ASSET_TO_USD_AGGREGATOR() external view returns (address);
}
