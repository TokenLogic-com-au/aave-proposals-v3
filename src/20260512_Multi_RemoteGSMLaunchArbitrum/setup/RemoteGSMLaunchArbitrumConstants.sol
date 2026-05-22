// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library RemoteGSMLaunchArbitrumConstants {
  // TODO: define amount to bridge; temporary numbers taken from Plasma's proposal
  uint256 public constant GHO_BRIDGE_AMOUNT = 50_000_000 ether;

  // 50M GHO bridge amount + 10% leeway in case of other bridges
  uint128 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;

  // Maximum capacity per day to be applied to every lane
  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000 ether;
  // Refill rate per second to be applied to every lane
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 1_000 ether;

  // Facilitator capacity matches bridge amount (as uint128)
  uint128 public constant DIRECT_FACILITATOR_CAPACITY = uint128(GHO_BRIDGE_AMOUNT);

  // GSM USDT
  // TODO: check amount (should be <= bridged amount, can be changed by steward later)
  uint128 public constant GSM_USDT_RESERVE_LIMIT = 15_000_000 ether;

  // TODO: refine amount (stata tokens have a rate with respect to underlying)
  uint128 public constant GSM_USDT_INITIAL_EXPOSURE_CAP = 15_000_000e6; // 15M, 6 decimals

  // GSM USDC
  // TODO: check amount (should be <= bridged amount, can be changed by steward later)
  uint128 public constant GSM_USDC_RESERVE_LIMIT = 15_000_000 ether;

  // TODO: refine amount (stata tokens have a rate with respect to underlying)
  uint128 public constant GSM_USDC_INITIAL_EXPOSURE_CAP = 15_000_000e6; // 15M, 6 decimals
}
