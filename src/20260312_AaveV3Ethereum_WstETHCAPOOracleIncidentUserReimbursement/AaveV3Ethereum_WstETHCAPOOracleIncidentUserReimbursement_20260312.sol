// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title wstETH CAPO Oracle Incident User Reimbursement
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-wsteth-capo-oracle-incident-user-reimbursement/24275?u=tokenlogic
 */
contract AaveV3Ethereum_WstETHCAPOOracleIncidentUserReimbursement_20260312 is
  IProposalGenericExecutor
{
  // https://etherscan.io/address/0x22740deBa78d5a0c24C58C740e3715ec29de1bFa
  address public constant AFC = 0x22740deBa78d5a0c24C58C740e3715ec29de1bFa;

  uint256 public constant WETH_AMOUNT = 513_190_000_000_000_000_000;

  function execute() external {
    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(AaveV3EthereumAssets.WETH_UNDERLYING),
      AFC,
      WETH_AMOUNT
    );
  }
}
