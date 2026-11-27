// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ITypeAndVersion
 * @notice Interface of the TypeAndVersion contract
 * @dev Copied from https://github.com/smartcontractkit/ccip/blob/2e1daa841f49302e40a77e23082e018bd4952e47/contracts/src/v0.8/shared/interfaces/ITypeAndVersion.sol
 */
interface ITypeAndVersion {
  function typeAndVersion() external pure returns (string memory);
}
