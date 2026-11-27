// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPool
 * @notice Interface of the Pool library
 * @dev Adapted from https://github.com/smartcontractkit/ccip/blob/0ae527c30030fcf931bf2220f0b7159b237cb313/contracts/src/v0.8/ccip/libraries/Pool.sol
 */
interface IPool {
  struct LockOrBurnInV1 {
    bytes receiver;
    uint64 remoteChainSelector;
    address originalSender;
    uint256 amount;
    address localToken;
  }

  struct LockOrBurnOutV1 {
    bytes destTokenAddress;
    bytes destPoolData;
  }

  struct ReleaseOrMintInV1 {
    bytes originalSender;
    uint64 remoteChainSelector;
    address receiver;
    uint256 amount;
    address localToken;
    bytes sourcePoolAddress;
    bytes sourcePoolData;
    bytes offchainTokenData;
  }

  struct ReleaseOrMintOutV1 {
    uint256 destinationAmount;
  }
}
