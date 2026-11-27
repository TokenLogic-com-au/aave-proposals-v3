// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ITransparentUpgradeableProxy} from 'openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol';

/**
 * @title ILegacyProxyAdmin
 * @notice Interface of the ProxyAdmin contract
 * @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/dc44c9f1a4c3b10af99492eed84f83ed244203f6/contracts/proxy/transparent/ProxyAdmin.sol
 */
interface ILegacyProxyAdmin {
  function changeProxyAdmin(ITransparentUpgradeableProxy proxy, address newAdmin) external;

  function upgrade(ITransparentUpgradeableProxy proxy, address implementation) external;

  function upgradeAndCall(
    ITransparentUpgradeableProxy proxy,
    address implementation,
    bytes memory data
  ) external;
}
