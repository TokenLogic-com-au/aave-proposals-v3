// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {GovernanceV3Avalanche} from 'aave-address-book/GovernanceV3Avalanche.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IGhoReserve} from 'src/interfaces/IGhoReserve.sol';
import {IPermissionedGsm} from 'src/interfaces/IPermissionedGsm.sol';

import {PermissionedGSMUSATAvalancheSetup as Setup} from './setup/PermissionedGSMUSATAvalancheSetup.sol';

/**
 * @title Permissioned GSM: USAT on Aave V4 Avalanche
 * @author TokenLogic
 * - Snapshot: TBA
 * - Discussion: https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852
 *
 * @dev Reverts until the bridged GHO has reached the Avalanche Collector.
 * The GSM is deployed with its GhoReserve and the 20M exposure cap already set, and with no fee
 * strategy: fees are 0/0 and FixedFeeStrategy rejects 0/0. No oracle swap freezer: the Aave V3
 * Avalanche oracle has no USAT source. No GsmRegistry exists on Avalanche.
 */
contract AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2 is IProposalGenericExecutor {
  // Pending deployment (gho-deploy DeployPermissionedGsmUsatAvalanche): zero until the suite exists on Avalanche.
  IGhoReserve public constant GHO_RESERVE = IGhoReserve(address(0));
  address public constant GHO_GSM_STEWARD = address(0);
  // PermissionedGsm4626, underlying waCoreUSAT
  IPermissionedGsm public constant GSM_USAT = IPermissionedGsm(address(0));

  // Approved commercial counterparty, pending
  address public constant APPROVED_COUNTERPARTY = address(0);

  // Approved Aave DAO Safe, controlled by the Aave Finance Committee (same 2/3 signers as GhoAvalanche.RISK_COUNCIL)
  // https://snowscan.xyz/address/0x22740deBa78d5a0c24C58C740e3715ec29de1bFa
  address public constant APPROVED_DAO_SAFE = 0x22740deBa78d5a0c24C58C740e3715ec29de1bFa;

  function execute() external {
    GHO_RESERVE.grantRole(GHO_RESERVE.LIMIT_MANAGER_ROLE(), GhoAvalanche.RISK_COUNCIL);
    GHO_RESERVE.addEntity(address(GSM_USAT));
    GHO_RESERVE.setLimit(address(GSM_USAT), Setup.GSM_RESERVE_LIMIT);

    GSM_USAT.grantRole(GSM_USAT.SWAP_FREEZER_ROLE(), GovernanceV3Avalanche.EXECUTOR_LVL_1);
    GSM_USAT.grantRole(GSM_USAT.CONFIGURATOR_ROLE(), GHO_GSM_STEWARD);

    // SWAP_ACCESS_MANAGER_ROLE administers BUY_ASSET_ROLE and SELL_ASSET_ROLE; the executor needs it to grant them
    bytes32 accessManagerRole = GSM_USAT.SWAP_ACCESS_MANAGER_ROLE();
    GSM_USAT.grantRole(accessManagerRole, GovernanceV3Avalanche.EXECUTOR_LVL_1);
    GSM_USAT.grantRole(accessManagerRole, GhoAvalanche.RISK_COUNCIL);
    _approveSwapper(APPROVED_DAO_SAFE);
    _approveSwapper(APPROVED_COUNTERPARTY);

    AaveV3Avalanche.COLLECTOR.transfer(
      IERC20(GhoAvalanche.GHO_TOKEN),
      address(GHO_RESERVE),
      Setup.GHO_BRIDGE_AMOUNT
    );

    Setup.restoreLaneRateLimitConfig(GhoAvalanche.GHO_CCIP_TOKEN_POOL, CCIPChainSelectors.ETHEREUM);
  }

  function _approveSwapper(address swapper) internal {
    GSM_USAT.grantRole(GSM_USAT.BUY_ASSET_ROLE(), swapper);
    GSM_USAT.grantRole(GSM_USAT.SELL_ASSET_ROLE(), swapper);
  }
}
