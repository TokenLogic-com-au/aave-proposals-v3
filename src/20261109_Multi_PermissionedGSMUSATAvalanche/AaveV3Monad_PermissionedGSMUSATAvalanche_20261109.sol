// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoMonad} from 'aave-address-book/GhoMonad.sol';

import {PermissionedGSMUSATAvalancheFacilitatorProposalBase} from './setup/PermissionedGSMUSATAvalancheFacilitatorProposalBase.sol';

/**
 * @title Permissioned GSM: USAT on Aave V4 Avalanche
 * @author TokenLogic
 * - Snapshot: TBA
 * - Discussion: https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852
 */
contract AaveV3Monad_PermissionedGSMUSATAvalanche_20261109 is
  PermissionedGSMUSATAvalancheFacilitatorProposalBase
{
  function GHO_TOKEN() public pure override returns (address) {
    return GhoMonad.GHO_TOKEN;
  }

  function GHO_CCIP_TOKEN_POOL() public pure override returns (address) {
    return GhoMonad.GHO_CCIP_TOKEN_POOL;
  }
}
