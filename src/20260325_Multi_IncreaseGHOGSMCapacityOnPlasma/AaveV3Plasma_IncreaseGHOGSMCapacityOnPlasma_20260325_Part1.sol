// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {GhoPlasma} from 'aave-address-book/GhoPlasma.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

/**
 * @title Increase GHO GSM Capacity on Plasma
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327
 */
contract AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1 is IProposalGenericExecutor {
  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 300 ether;

  uint128 public constant NEW_BRIDGE_LIMIT = 150_000_000 ether;

  // 50M GHO bridge amount + 10% leeway in case of other bridges
  uint256 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;

  function execute() external {
    IGhoToken(GhoPlasma.GHO_TOKEN).setFacilitatorBucketCapacity(
      GhoPlasma.GHO_CCIP_TOKEN_POOL,
      NEW_BRIDGE_LIMIT
    );

    IUpgradeableBurnMintTokenPool(GhoPlasma.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.ETHEREUM,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: DEFAULT_RATE_LIMITER_CAPACITY,
        rate: DEFAULT_RATE_LIMITER_RATE
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: uint128(TEMP_BRIDGE_CAPACITY),
        rate: uint128(TEMP_BRIDGE_CAPACITY) - 1 // Set rate to capacity so it fills to limit right away (-1 because they cannot be the same)
      })
    );
  }
}
