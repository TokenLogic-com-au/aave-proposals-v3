// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IAaveCLRobotOperator
 * @author BGD Labs
 * @notice Interface of the AaveCLRobotOperator contract
 * @dev Adapted from https://github.com/aave-dao/aave-governance-v3-robot/blob/92919405ec7a1ee48bcc5b65fec85aa5c89cd745/src/interfaces/IAaveCLRobotOperator.sol
 */
interface IAaveCLRobotOperator {
  event KeeperCancelled(uint256 indexed id, address indexed upkeep);

  event KeeperRegistered(uint256 indexed id, address indexed upkeep, uint96 indexed amount);

  function register(
    string memory name,
    address upkeepContract,
    bytes calldata upkeepCheckData,
    uint32 gasLimit,
    uint96 amountToFund,
    uint8 triggerType,
    bytes calldata triggerConfig
  ) external returns (uint256);

  struct KeeperInfo {
    address upkeep;
    bytes checkData;
  }

  function cancel(uint256 id) external;

  function withdrawLink(uint256 id) external;

  function getKeepersList() external view returns (uint256[] memory);

  function getKeeperInfo(uint256 id) external view returns (KeeperInfo memory);
}
