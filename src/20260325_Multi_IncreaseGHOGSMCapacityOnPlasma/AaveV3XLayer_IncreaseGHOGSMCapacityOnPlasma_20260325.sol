// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {GhoXLayer} from 'aave-address-book/GhoXLayer.sol';

import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

/**
 * @title Increase GHO GSM Capacity on Plasma
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-XLayer/24327
 */
contract AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325 is IProposalGenericExecutor {
  uint128 public constant NEW_BRIDGE_LIMIT = 150_000_000 ether;

  function execute() external {
    IGhoToken(GhoXLayer.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoXLayer.GHO_CCIP_TOKEN_POOL,
      NEW_BRIDGE_LIMIT
    );
  }
}
