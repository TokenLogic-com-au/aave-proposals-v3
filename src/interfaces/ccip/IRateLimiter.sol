// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title IRateLimiter
 * @notice Interface of the RateLimiter library
 * @dev Adapted from https://github.com/smartcontractkit/ccip/blob/390ee2334126e313c0e214c2cd9a7a379b5bfe13/contracts/src/v0.8/ccip/libraries/RateLimiter.sol
 */
interface IRateLimiter {
  struct TokenBucket {
    uint128 tokens; // ──────╮ Current number of tokens that are in the bucket.
    uint32 lastUpdated; //   │ Timestamp in seconds of the last token refill, good for 100+ years.
    bool isEnabled; // ──────╯ Indication whether the rate limiting is enabled or not
    uint128 capacity; // ────╮ Maximum number of tokens that can be in the bucket.
    uint128 rate; // ────────╯ Number of tokens per second that the bucket is refilled.
  }

  struct Config {
    bool isEnabled; // Indication whether the rate limiting should be enabled
    uint128 capacity; // ────╮ Specifies the capacity of the rate limiter
    uint128 rate; //  ───────╯ Specifies the rate of the rate limiter
  }
}
