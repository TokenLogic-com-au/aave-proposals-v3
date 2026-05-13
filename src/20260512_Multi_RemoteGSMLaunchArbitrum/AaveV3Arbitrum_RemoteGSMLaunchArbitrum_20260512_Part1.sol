// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {CCIPChainSelectors} from '../helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title Remote GSM Launch: Arbitrum
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240
 */
contract AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1 is IProposalGenericExecutor {
  uint128 public constant DEFAULT_RATE_LIMITER_CAPACITY = 1_500_000 ether;
  uint128 public constant DEFAULT_RATE_LIMITER_RATE = 300 ether;

  // 50M GHO bridge amount + 10% leeway in case of other bridges
  // TODO: define amount to bridge; temporary numbers taken from Plasma's proposal. Must match Ethereum / Part 1
  uint256 public constant TEMP_BRIDGE_CAPACITY = 55_000_000 ether;

  function execute() external {
    // Temporarily increase the maximum bridge limit (inbound capacity; counterpart to Ethereum / Part 1 step)
    IUpgradeableBurnMintTokenPool(GhoArbitrum.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
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
