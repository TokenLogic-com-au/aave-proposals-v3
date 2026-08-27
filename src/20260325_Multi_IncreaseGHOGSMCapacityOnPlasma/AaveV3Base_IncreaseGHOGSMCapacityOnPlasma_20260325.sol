// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {GhoBase} from 'aave-address-book/GhoBase.sol';

import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

/**
 * @title Increase GHO GSM Capacity on Plasma
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327
 */
contract AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325 is IProposalGenericExecutor {
  uint128 public constant NEW_BRIDGE_LIMIT = 150_000_000 ether;
  uint128 public constant NEW_DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000e18;
  uint128 public constant NEW_DEFAULT_RATE_LIMITER_RATE = 1_000e18;

  function execute() external {
    IGhoToken(GhoBase.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoBase.GHO_CCIP_TOKEN_POOL,
      NEW_BRIDGE_LIMIT
    );

    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.BASE,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      IUpgradeableBurnMintTokenPool(GhoBase.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
        chains[i].chainSelector,
        IRateLimiter.Config({
          isEnabled: true,
          capacity: NEW_DEFAULT_RATE_LIMITER_CAPACITY,
          rate: NEW_DEFAULT_RATE_LIMITER_RATE
        }),
        IRateLimiter.Config({
          isEnabled: true,
          capacity: uint128(NEW_DEFAULT_RATE_LIMITER_CAPACITY),
          rate: uint128(NEW_DEFAULT_RATE_LIMITER_RATE)
        })
      );
    }
  }
}
