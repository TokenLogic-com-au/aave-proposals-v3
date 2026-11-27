// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title INonceManager
 * @notice Contract interface that allows managing sender nonces.
 * @dev Adapted from https://github.com/smartcontractkit/ccip/blob/5e7b2096586bc32c6e975fc13f4c411eb687f833/contracts/src/v0.8/ccip/NonceManager.sol
 */
interface INonceManager {
  /// @notice Increments the outbound nonce for a given sender on a given destination chain.
  /// @param destChainSelector The destination chain selector.
  /// @param sender The sender address.
  /// @return incrementedOutboundNonce The new outbound nonce.
  function getOutboundNonce(
    uint64 destChainSelector,
    address sender
  ) external view returns (uint64);
}
