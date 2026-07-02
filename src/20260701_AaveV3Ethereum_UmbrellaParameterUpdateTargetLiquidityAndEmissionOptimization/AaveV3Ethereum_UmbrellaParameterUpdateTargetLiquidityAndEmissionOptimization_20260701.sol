// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UmbrellaEthereum, UmbrellaEthereumAssets} from 'aave-address-book/UmbrellaEthereum.sol';
import {EngineFlags} from 'aave-umbrella/payloads/EngineFlags.sol';
import {IUmbrellaEngineStructs} from 'aave-umbrella/payloads/IUmbrellaEngineStructs.sol';
import {UmbrellaBasePayload} from 'aave-umbrella/payloads/UmbrellaBasePayload.sol';
import {IRewardsStructs} from 'aave-umbrella/rewards/interfaces/IRewardsStructs.sol';

/**
 * @title Umbrella Parameter Update: Target Liquidity and Emission Optimization
 * @author @TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/0x1b262e62f554d2a5a68eb56a267e14ec3aeacad5bd185ef328be8b38aca651ca
 * - Discussion: https://governance.aave.com/t/arfc-umbrella-parameter-update-target-liquidity-and-emission-optimization/25154
 */
contract AaveV3Ethereum_UmbrellaParameterUpdateTargetLiquidityAndEmissionOptimization_20260701 is
  UmbrellaBasePayload
{
  uint256 public constant SECONDS_PER_YEAR = 365 days;

  uint256 public constant USDT_TARGET_LIQUIDITY = 34_114_525e6;
  uint256 public constant USDC_TARGET_LIQUIDITY = 32_518_555e6;
  uint256 public constant WETH_TARGET_LIQUIDITY = 17_437.44e18;

  uint256 public constant USDT_EMISSION_PER_YEAR = 1_280_000e6;
  uint256 public constant USDC_EMISSION_PER_YEAR = 1_220_000e6;
  uint256 public constant WETH_EMISSION_PER_YEAR = 470e18;

  uint256 public constant GHO_TARGET_LIQUIDITY = 1e18;
  uint256 public constant GHO_DEFICIT_OFFSET = 3_000_000e18;

  constructor() UmbrellaBasePayload(UmbrellaEthereum.UMBRELLA_CONFIG_ENGINE) {}

  function configureStakeAndRewards()
    public
    pure
    override
    returns (IUmbrellaEngineStructs.ConfigureStakeAndRewardsConfig[] memory)
  {
    IUmbrellaEngineStructs.ConfigureStakeAndRewardsConfig[]
      memory configs = new IUmbrellaEngineStructs.ConfigureStakeAndRewardsConfig[](4);

    configs[0] = _buildConfig(
      UmbrellaEthereumAssets.STK_WA_USDT_V1,
      AaveV3EthereumAssets.USDT_A_TOKEN,
      USDT_TARGET_LIQUIDITY,
      USDT_EMISSION_PER_YEAR / SECONDS_PER_YEAR
    );
    configs[1] = _buildConfig(
      UmbrellaEthereumAssets.STK_WA_USDC_V1,
      AaveV3EthereumAssets.USDC_A_TOKEN,
      USDC_TARGET_LIQUIDITY,
      USDC_EMISSION_PER_YEAR / SECONDS_PER_YEAR
    );
    configs[2] = _buildConfig(
      UmbrellaEthereumAssets.STK_WA_WETH_V1,
      AaveV3EthereumAssets.WETH_A_TOKEN,
      WETH_TARGET_LIQUIDITY,
      WETH_EMISSION_PER_YEAR / SECONDS_PER_YEAR
    );
    configs[3] = _buildConfig(
      UmbrellaEthereumAssets.STK_GHO_V1,
      AaveV3EthereumAssets.GHO_UNDERLYING,
      GHO_TARGET_LIQUIDITY,
      0
    );

    return configs;
  }

  function setDeficitOffset()
    public
    pure
    override
    returns (IUmbrellaEngineStructs.SetDeficitOffset[] memory)
  {
    IUmbrellaEngineStructs.SetDeficitOffset[]
      memory offsets = new IUmbrellaEngineStructs.SetDeficitOffset[](1);

    offsets[0] = IUmbrellaEngineStructs.SetDeficitOffset({
      reserve: AaveV3EthereumAssets.GHO_UNDERLYING,
      newDeficitOffset: GHO_DEFICIT_OFFSET
    });

    return offsets;
  }

  function _buildConfig(
    address stakeToken,
    address reward,
    uint256 targetLiquidity,
    uint256 maxEmissionPerSecond
  ) internal pure returns (IUmbrellaEngineStructs.ConfigureStakeAndRewardsConfig memory) {
    IRewardsStructs.RewardSetupConfig[]
      memory rewardConfigs = new IRewardsStructs.RewardSetupConfig[](1);
    rewardConfigs[0] = IRewardsStructs.RewardSetupConfig({
      reward: reward,
      rewardPayer: address(AaveV3Ethereum.COLLECTOR),
      maxEmissionPerSecond: maxEmissionPerSecond,
      distributionEnd: EngineFlags.KEEP_CURRENT
    });

    return
      IUmbrellaEngineStructs.ConfigureStakeAndRewardsConfig({
        umbrellaStake: stakeToken,
        targetLiquidity: targetLiquidity,
        rewardConfigs: rewardConfigs
      });
  }
}
