// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';

/**
 * @title IGhoReserve
 * @author Aave/TokenLogic
 * @notice Interface of the GhoReserve contract
 * @dev Adapted from https://github.com/aave-dao/gho-origin/blob/863ec56dd4041e87749351098274f41b00a29c27/src/contracts/facilitators/gsm/interfaces/IGhoReserve.sol
 */
interface IGhoReserve is IAccessControl {
  function addEntity(address entity) external;
  function removeEntity(address entity) external;
  function setLimit(address entity, uint256 limit) external;
  function getLimit(address entity) external view returns (uint256);
  function getUsed(address entity) external view returns (uint256);
  function isEntity(address entity) external view returns (bool);
  function totalEntities() external view returns (uint256);
  function LIMIT_MANAGER_ROLE() external view returns (bytes32);
}
