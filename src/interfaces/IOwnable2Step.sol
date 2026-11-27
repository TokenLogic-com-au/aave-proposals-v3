// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IOwnable} from 'aave-address-book/common/IOwnable.sol';

/**
 * @title IOwnable2Step
 * @notice Interface of the Ownable2Step contract
 * @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5fd1781b1454fd1ef8e722282f86f9293cacf256/contracts/access/Ownable2Step.sol
 */
interface IOwnable2Step is IOwnable {
  function pendingOwner() external view returns (address);

  function acceptOwnership() external;
}
