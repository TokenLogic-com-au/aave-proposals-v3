// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library RemoteGSMLaunchArbitrumConstants {
  // TODO: define amount to bridge; temporary numbers taken from Plasma's proposal
  // 50M GHO bridge amount + 10% leeway in case of other bridges
  uint128 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;

  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 300 ether;

  // TODO: define amount to bridge; temporary numbers taken from Plasma's proposal
  uint256 public constant ARBITRUM_BRIDGE_AMOUNT = 50_000_000 ether;

  // Facilitator capacity matches bridge amount (as uint128)
  uint128 public constant DIRECT_FACILITATOR_CAPACITY = uint128(ARBITRUM_BRIDGE_AMOUNT);
}
