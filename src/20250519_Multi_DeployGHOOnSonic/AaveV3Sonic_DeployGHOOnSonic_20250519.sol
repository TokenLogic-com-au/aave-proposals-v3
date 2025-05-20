// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {ITokenAdminRegistry} from 'src/interfaces/ccip/ITokenAdminRegistry.sol';
import {IRateLimiter} from 'src/interfaces/ccip/IRateLimiter.sol';
import {IGhoBucketSteward} from 'src/interfaces/IGhoBucketSteward.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {AaveV3Sonic, AaveV3SonicAssets} from 'aave-address-book/AaveV3Sonic.sol';
import {GovernanceV3Sonic} from 'aave-address-book/GovernanceV3Sonic.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GhoBase} from 'aave-address-book/GhoBase.sol';
import {AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {CCIPUtils} from './CCIPUtils.sol';
import {CCIPLaunchConstants} from './CCIPLaunchConstants.sol';

/**
 * @title Deploy GHO on Sonic
 * @author @TokenLogic
 * - Snapshot: https://snapshot.box/#/s:aavedao.eth/proposal/0xac45d4c364ce0306b0c487ae83215ebc1b1ebb406704ec36b9bba7aab428cdea
 * - Discussion: https://governance.aave.com/t/arfc-launch-gho-on-sonic-set-aci-as-emissions-manager-for-rewards/21282
 */
contract AaveV3Sonic_DeployGHOOnSonic_20250519 is IProposalGenericExecutor {
  uint64 public constant BASE_CHAIN_SELECTOR = CCIPUtils.BASE_CHAIN_SELECTOR;
  uint64 public constant ARB_CHAIN_SELECTOR = CCIPUtils.ARB_CHAIN_SELECTOR;
  uint64 public constant ETH_CHAIN_SELECTOR = CCIPUtils.ETH_CHAIN_SELECTOR;

  uint128 public constant CCIP_BUCKET_CAPACITY = CCIPLaunchConstants.CCIP_BUCKET_CAPACITY;

  // https://sonicscan.org/address/0x2961Cb47b5111F38d75f415c21ceB4120ddd1b69
  ITokenAdminRegistry public constant TOKEN_ADMIN_REGISTRY =
    ITokenAdminRegistry(CCIPLaunchConstants.SONIC_TOKEN_ADMIN_REGISTRY);

  // https://sonicscan.org/address/0xab1c66208266bbF5b2809ce1deDd3e5149eb4C94
  IUpgradeableBurnMintTokenPool_1_5_1 public constant TOKEN_POOL =
    IUpgradeableBurnMintTokenPool_1_5_1(CCIPLaunchConstants.SONIC_TOKEN_POOL);

  // https://sonicscan.org/address/0x2FB8193f1302D3D0323f53E29C0AEBc5acEf73Ca
  IGhoToken public constant GHO_TOKEN = IGhoToken(CCIPLaunchConstants.SONIC_GHO_TOKEN);

  // https://sonicscan.org/address/0x6e637e1E48025E51315d50ab96d5b3be1971A715
  address public constant GHO_AAVE_STEWARD = CCIPLaunchConstants.SONIC_AAVE_STEWARD;

  // https://sonicscan.org/address/
  address public constant GHO_BUCKET_STEWARD = CCIPLaunchConstants.SONIC_BUCKET_STEWARD;

  // https://sonicscan.org/address/
  address public constant GHO_CCIP_STEWARD = CCIPLaunchConstants.SONIC_CCIP_STEWARD;

  // https://etherscan.io/address/
  address public constant REMOTE_TOKEN_POOL_ETH = GhoEthereum.GHO_CCIP_TOKEN_POOL;

  // https://arbiscan.io/address/0xB94Ab28c6869466a46a42abA834ca2B3cECCA5eB
  address public constant REMOTE_TOKEN_POOL_ARB = GhoArbitrum.GHO_CCIP_TOKEN_POOL;

  // https://basescan.org/address/0xDe6539018B095353A40753Dc54C91C68c9487D4E
  address public constant REMOTE_TOKEN_POOL_BASE = GhoBase.GHO_CCIP_TOKEN_POOL;

  // Token Rate Limit Capacity: 300_000 GHO
  uint128 public constant CCIP_RATE_LIMIT_CAPACITY = CCIPLaunchConstants.CCIP_RATE_LIMIT_CAPACITY;

  // Token Rate Limit Refill Rate: 60 GHO per second (=> 216_000 GHO per hour)
  uint128 public constant CCIP_RATE_LIMIT_REFILL_RATE =
    CCIPLaunchConstants.CCIP_RATE_LIMIT_REFILL_RATE;

  function execute() external {
    _acceptOwnership();
    _setupStewardsAndTokenPoolOnGho();
    _setupRemoteAndRegisterTokenPool();
  }

  function _acceptOwnership() internal {
    TOKEN_ADMIN_REGISTRY.acceptAdminRole(address(GHO_TOKEN));
    TOKEN_POOL.acceptOwnership();
  }

  function _setupStewardsAndTokenPoolOnGho() internal {
    GHO_TOKEN.grantRole(GHO_TOKEN.FACILITATOR_MANAGER_ROLE(), GovernanceV3Sonic.EXECUTOR_LVL_1);
    GHO_TOKEN.grantRole(GHO_TOKEN.BUCKET_MANAGER_ROLE(), GovernanceV3Sonic.EXECUTOR_LVL_1);

    // Token Pool as facilitator with 15M GHO capacity
    GHO_TOKEN.addFacilitator(address(TOKEN_POOL), 'CCIP TokenPool v1.5.1', CCIP_BUCKET_CAPACITY);

    // Gho Aave Steward
    AaveV3Sonic.ACL_MANAGER.grantRole(AaveV3Sonic.ACL_MANAGER.RISK_ADMIN_ROLE(), GHO_AAVE_STEWARD);

    // Gho Bucket Steward
    GHO_TOKEN.grantRole(GHO_TOKEN.BUCKET_MANAGER_ROLE(), GHO_BUCKET_STEWARD);
    address[] memory facilitatorList = new address[](1);
    facilitatorList[0] = address(TOKEN_POOL);
    IGhoBucketSteward(GHO_BUCKET_STEWARD).setControlledFacilitator({
      facilitatorList: facilitatorList,
      approve: true
    });

    // Gho CCIP Steward
    TOKEN_POOL.setRateLimitAdmin(GHO_CCIP_STEWARD);
  }

  function _setupRemoteAndRegisterTokenPool() internal {
    IRateLimiter.Config memory rateLimiterConfig = IRateLimiter.Config({
      isEnabled: true,
      capacity: CCIP_RATE_LIMIT_CAPACITY,
      rate: CCIP_RATE_LIMIT_REFILL_RATE
    });

    IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate[]
      memory chainsToAdd = new IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate[](3);

    {
      bytes[] memory remotePoolAddresses = new bytes[](1);
      remotePoolAddresses[0] = abi.encode(REMOTE_TOKEN_POOL_ETH);
      chainsToAdd[0] = IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate({
        remoteChainSelector: ETH_CHAIN_SELECTOR,
        remotePoolAddresses: remotePoolAddresses,
        remoteTokenAddress: abi.encode(AaveV3EthereumAssets.GHO_UNDERLYING),
        outboundRateLimiterConfig: rateLimiterConfig,
        inboundRateLimiterConfig: rateLimiterConfig
      });
    }

    {
      bytes[] memory remotePoolAddresses = new bytes[](1);
      remotePoolAddresses[0] = abi.encode(REMOTE_TOKEN_POOL_ARB);
      chainsToAdd[1] = IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate({
        remoteChainSelector: ARB_CHAIN_SELECTOR,
        remotePoolAddresses: remotePoolAddresses,
        remoteTokenAddress: abi.encode(AaveV3ArbitrumAssets.GHO_UNDERLYING),
        outboundRateLimiterConfig: rateLimiterConfig,
        inboundRateLimiterConfig: rateLimiterConfig
      });
    }

    {
      bytes[] memory remotePoolAddresses = new bytes[](1);
      remotePoolAddresses[0] = abi.encode(REMOTE_TOKEN_POOL_BASE);
      chainsToAdd[2] = IUpgradeableBurnMintTokenPool_1_5_1.ChainUpdate({
        remoteChainSelector: BASE_CHAIN_SELECTOR,
        remotePoolAddresses: remotePoolAddresses,
        remoteTokenAddress: abi.encode(AaveV3BaseAssets.GHO_UNDERLYING),
        outboundRateLimiterConfig: rateLimiterConfig,
        inboundRateLimiterConfig: rateLimiterConfig
      });
    }

    // setup remote token pools
    TOKEN_POOL.applyChainUpdates({
      remoteChainSelectorsToRemove: new uint64[](0),
      chainsToAdd: chainsToAdd
    });

    // register token pool
    TOKEN_ADMIN_REGISTRY.setPool(address(GHO_TOKEN), address(TOKEN_POOL));
  }
}
