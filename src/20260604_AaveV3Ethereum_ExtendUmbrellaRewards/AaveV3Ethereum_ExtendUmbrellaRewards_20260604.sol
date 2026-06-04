// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UmbrellaEthereum, UmbrellaEthereumAssets} from 'aave-address-book/UmbrellaEthereum.sol';
import {IUmbrellaEngineStructs} from 'aave-umbrella/payloads/IUmbrellaEngineStructs.sol';
import {UmbrellaBasePayload} from 'aave-umbrella/payloads/UmbrellaBasePayload.sol';
import {IRewardsController} from 'aave-umbrella/rewards/interfaces/IRewardsController.sol';
import {IRewardsStructs} from 'aave-umbrella/rewards/interfaces/IRewardsStructs.sol';

/**
 * @title Extend Umbrella Rewards Distribution
 * @author @TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Ethereum_ExtendUmbrellaRewards_20260604 is UmbrellaBasePayload {
  uint256 public constant DISTRIBUTION_DURATION = 365 days;

  constructor() UmbrellaBasePayload(UmbrellaEthereum.UMBRELLA_CONFIG_ENGINE) {}

  function configureRewards()
    public
    view
    override
    returns (IUmbrellaEngineStructs.ConfigureRewardsConfig[] memory)
  {
    IUmbrellaEngineStructs.ConfigureRewardsConfig[]
      memory configs = new IUmbrellaEngineStructs.ConfigureRewardsConfig[](4);

    configs[0] = _buildRewardExtension(
      UmbrellaEthereumAssets.STK_WA_USDC_V1,
      AaveV3EthereumAssets.USDC_A_TOKEN
    );
    configs[1] = _buildRewardExtension(
      UmbrellaEthereumAssets.STK_WA_USDT_V1,
      AaveV3EthereumAssets.USDT_A_TOKEN
    );
    configs[2] = _buildRewardExtension(
      UmbrellaEthereumAssets.STK_WA_WETH_V1,
      AaveV3EthereumAssets.WETH_A_TOKEN
    );
    configs[3] = _buildRewardExtension(
      UmbrellaEthereumAssets.STK_GHO_V1,
      AaveV3EthereumAssets.GHO_UNDERLYING
    );

    return configs;
  }

  function _buildRewardExtension(
    address stakeToken,
    address reward
  ) internal view returns (IUmbrellaEngineStructs.ConfigureRewardsConfig memory) {
    IRewardsStructs.RewardDataExternal memory currentRewardData = IRewardsController(
      UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER
    ).getRewardData(stakeToken, reward);

    IRewardsStructs.RewardSetupConfig[]
      memory rewardConfigs = new IRewardsStructs.RewardSetupConfig[](1);
    rewardConfigs[0] = IRewardsStructs.RewardSetupConfig({
      reward: reward,
      rewardPayer: address(AaveV3Ethereum.COLLECTOR),
      maxEmissionPerSecond: currentRewardData.maxEmissionPerSecond,
      distributionEnd: block.timestamp + DISTRIBUTION_DURATION
    });

    return
      IUmbrellaEngineStructs.ConfigureRewardsConfig({
        umbrellaStake: stakeToken,
        rewardConfigs: rewardConfigs
      });
  }
}
