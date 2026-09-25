// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Plasma} from 'aave-address-book/AaveV3Plasma.sol';
import {GhoPlasma} from 'aave-address-book/GhoPlasma.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
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
contract AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2 is IProposalGenericExecutor {
  uint128 public constant NEW_DEFAULT_RATE_LIMITER_CAPACITY = 5_000_000e18;
  uint128 public constant NEW_DEFAULT_RATE_LIMITER_RATE = 1_000e18;

  uint256 public constant BRIDGED_AMOUNT = 50_000_000 ether;

  function execute() external {
    AaveV3Plasma.COLLECTOR.transfer(
      IERC20(GhoPlasma.GHO_TOKEN),
      GhoPlasma.GHO_RESERVE,
      BRIDGED_AMOUNT
    );

    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      CCIPChainSelectors.PLASMA,
      false
    );

    for (uint256 i = 0; i < chains.length; i++) {
      IUpgradeableBurnMintTokenPool(GhoPlasma.GHO_CCIP_TOKEN_POOL).setChainRateLimiterConfig(
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
