// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {IRateLimiter} from 'src/interfaces/ccip/IRateLimiter.sol';

import {CCIPUtils} from './CCIPUtils.sol';
import {CCIPLaunchConstants} from './CCIPLaunchConstants.sol';

/**
 * @title Deploy GHO on Sonic
 * @author @TokenLogic
 * - Snapshot: https://snapshot.box/#/s:aavedao.eth/proposal/0xac45d4c364ce0306b0c487ae83215ebc1b1ebb406704ec36b9bba7aab428cdea
 * - Discussion: https://governance.aave.com/t/arfc-launch-gho-on-sonic-set-aci-as-emissions-manager-for-rewards/21282
 */
contract AaveV3Gnosis_DeployGHOOnSonic_20250519 is IProposalGenericExecutor {
  // https://gnosisscan.io/address/0xDe6539018B095353A40753Dc54C91C68c9487D4E
  IUpgradeableBurnMintTokenPool_1_5_1 public constant TOKEN_POOL =
    IUpgradeableBurnMintTokenPool_1_5_1(CCIPLaunchConstants.GNO_TOKEN_POOL);

  // https://sonicscan.org/address/0xab1c66208266bbF5b2809ce1deDd3e5149eb4C94
  address public constant REMOTE_TOKEN_POOL_SONIC = CCIPLaunchConstants.SONIC_TOKEN_POOL;

  // https://sonicscan.org/address/0x2FB8193f1302D3D0323f53E29C0AEBc5acEf73Ca
  address public constant REMOTE_GHO_TOKEN_SONIC = CCIPLaunchConstants.SONIC_GHO_TOKEN;

  function execute() external {
    IRateLimiter.Config memory rateLimiterConfig = IRateLimiter.Config({
      isEnabled: true,
      capacity: CCIPLaunchConstants.CCIP_RATE_LIMIT_CAPACITY,
      rate: CCIPLaunchConstants.CCIP_RATE_LIMIT_REFILL_RATE
    });

    IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate[]
      memory chainsToAdd = new IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate[](1);

    bytes[] memory remotePoolAddresses = new bytes[](1);
    remotePoolAddresses[0] = abi.encode(REMOTE_TOKEN_POOL_SONIC);

    chainsToAdd[0] = IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate({
      remoteChainSelector: CCIPUtils.SONIC_CHAIN_SELECTOR,
      remotePoolAddresses: remotePoolAddresses,
      remoteTokenAddress: abi.encode(REMOTE_GHO_TOKEN_SONIC),
      outboundRateLimiterConfig: rateLimiterConfig,
      inboundRateLimiterConfig: rateLimiterConfig
    });

    TOKEN_POOL.applyChainUpdates({
      remoteChainSelectorsToRemove: new uint64[](0),
      chainsToAdd: chainsToAdd
    });
  }
}
