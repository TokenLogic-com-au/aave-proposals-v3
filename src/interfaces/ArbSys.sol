// Copyright 2021-2022, Offchain Labs, Inc.
// For license information, see https://github.com/nitro/blob/master/LICENSE
// SPDX-License-Identifier: BUSL-1.1

pragma solidity >=0.4.21 <0.9.0;

/**
 * @title System level functionality
 * @notice For use by contracts to interact with core L2-specific functionality.
 * Precompiled contract that exists in every Arbitrum chain at address(100), 0x0000000000000000000000000000000000000064.
 * @dev Adapted from https://github.com/OffchainLabs/nitro-contracts/blob/a14355b67cbd896c74043d5364b9f4c8252566d6/src/precompiles/ArbSys.sol
 */
interface ArbSys {
  /**
   * @notice Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)
   * @return block number as int
   */
  function arbBlockNumber() external view returns (uint256);

  /**
   * @notice Get Arbitrum block hash (reverts unless currentBlockNum-256 <= arbBlockNum < currentBlockNum)
   * @return block hash
   */
  function arbBlockHash(uint256 arbBlockNum) external view returns (bytes32);
}
