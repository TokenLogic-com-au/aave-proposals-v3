// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IKeeperRegistry
 * @notice Interface of the KeeperRegistryLogicB2_1 contract
 * @dev Used only by test files in this AIP folder to interact with the Chainlink Automation v2.1 registry deployed on each chain.
 * @dev Adapted from https://github.com/smartcontractkit/chainlink/blob/b54dfa99b7f6e0d33098315a189ab98e10dca67c/contracts/src/v0.8/automation/v2_1/KeeperRegistryLogicB2_1.sol
 */
interface IKeeperRegistry {
  function getCancellationDelay() external view returns (uint256);

  function getLinkAddress() external view returns (address);
}
