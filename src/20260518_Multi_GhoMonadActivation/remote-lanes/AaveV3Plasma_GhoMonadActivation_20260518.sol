// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {AaveV3GHOLane} from '../../helpers/gho-launch/AaveV3GHOLane.sol';
import {GhoCCIPChains} from '../../helpers/gho-launch/constants/GhoCCIPChains.sol';
/**
 * @title Plasma<>Monad GHO CCIP Lane
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Plasma_GhoMonadActivation_20260518 is AaveV3GHOLane {
  constructor() AaveV3GHOLane(GhoCCIPChains.PLASMA()) {}
  function lanesToAdd()
    public
    pure
    override
    returns (IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate[] memory)
  {
    return _asArray(_asChainUpdateWithDefaultRateLimiterConfig(GhoCCIPChains.MONAD()));
  }
}
