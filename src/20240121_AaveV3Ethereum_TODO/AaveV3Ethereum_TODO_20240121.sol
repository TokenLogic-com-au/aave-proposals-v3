// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AavePermissionedSwapper} from './AavePermissionedSwapper.sol';

/**
 * @title TODO
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Ethereum_TODO_20240121 is IProposalGenericExecutor {
  address public constant GUARDIAN = address(123); // TODO
  address public constant INPUT = AaveV3EthereumAssets.WETH_A_TOKEN;
  address public constant INPUT_ORACLE = AaveV3EthereumAssets.WETH_ORACLE;

  function execute() external {
    AavePermissionedSwapper aps = new AavePermissionedSwapper(GUARDIAN, INPUT, INPUT_ORACLE);

    AaveV3Ethereum.COLLECTOR.approve(INPUT, address(aps), type(uint256).max);
  }
}
