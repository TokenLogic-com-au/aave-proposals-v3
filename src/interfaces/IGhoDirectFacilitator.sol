// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';

/**
 * @title IGhoDirectFacilitator
 * @author Aave/TokenLogic
 * @notice Interface of the GhoDirectFacilitator contract
 * @dev Adapted from https://github.com/aave-dao/gho-origin/blob/863ec56dd4041e87749351098274f41b00a29c27/src/contracts/facilitators/gsm/interfaces/IGhoDirectFacilitator.sol
 */
interface IGhoDirectFacilitator is IAccessControl {
  function mint(address to, uint256 amount) external;
  function MINTER_ROLE() external view returns (bytes32);
}
