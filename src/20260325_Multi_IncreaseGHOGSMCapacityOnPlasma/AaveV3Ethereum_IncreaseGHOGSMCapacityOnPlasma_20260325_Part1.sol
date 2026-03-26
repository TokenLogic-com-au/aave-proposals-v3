// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';

import {IUpgradeableLockReleaseTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';

/**
 * @title Increase GHO GSM Capacity on Plasma
 * @author @TokenLogic
 * - Snapshot: Direct-to-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327
 */
contract AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1 is IProposalGenericExecutor {
  // 50M GHO bridge amount + 10% leeway in case of other bridges
  uint256 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;
  uint256 public constant NEW_BRIDGE_LIMIT = 150_000_000 ether;

  uint128 internal constant NEW_DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000e18;
  uint128 internal constant NEW_DEFAULT_RATE_LIMITER_RATE = 1_000e18;

  function execute() external {
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setBridgeLimit(
      NEW_BRIDGE_LIMIT
    );

    // Temporarily increase the maximum bridge limit
    IUpgradeableLockReleaseTokenPool(GhoEthereum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
      CCIPChainSelectors.PLASMA,
      IRateLimiter.Config({
        isEnabled: true,
        capacity: uint128(TEMP_BRIDGE_CAPACITY),
        rate: uint128(TEMP_BRIDGE_CAPACITY) - 1 // Set rate to new capacity so it refills immediately
      }),
      IRateLimiter.Config({
        isEnabled: true,
        capacity: NEW_DEFAULT_RATE_LIMITER_CAPACITY,
        rate: NEW_DEFAULT_RATE_LIMITER_RATE
      })
    );
  }
}
