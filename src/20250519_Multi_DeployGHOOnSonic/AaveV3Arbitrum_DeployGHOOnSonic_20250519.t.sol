// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IUpgradeableBurnMintTokenPool_1_5_1} from 'src/interfaces/ccip/tokenPool/IUpgradeableBurnMintTokenPool.sol';
import {IPool as IPool_CCIP} from 'src/interfaces/ccip/tokenPool/IPool.sol';
import {IClient} from 'src/interfaces/ccip/IClient.sol';
import {IInternal} from 'src/interfaces/ccip/IInternal.sol';
import {IRouter} from 'src/interfaces/ccip/IRouter.sol';
import {IRateLimiter} from 'src/interfaces/ccip/IRateLimiter.sol';
import {IEVM2EVMOnRamp} from 'src/interfaces/ccip/IEVM2EVMOnRamp.sol';
import {IEVM2EVMOffRamp_1_5} from 'src/interfaces/ccip/IEVM2EVMOffRamp.sol';
import {ITokenAdminRegistry} from 'src/interfaces/ccip/ITokenAdminRegistry.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGhoCcipSteward} from 'src/interfaces/IGhoCcipSteward.sol';

import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GhoBase} from 'aave-address-book/GhoBase.sol';

import {CCIPUtils} from './CCIPUtils.sol';
import {CCIPLaunchConstants} from './CCIPLaunchConstants.sol';
import {AaveV3Arbitrum_DeployGHOOnSonic_20250519} from './AaveV3Arbitrum_DeployGHOOnSonic_20250519.sol';

/**
 * @dev Test for AaveV3Arbitrum_DeployGHOOnSonic_20250519
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20250519_Multi_DeployGHOOnSonic/AaveV3Arbitrum_DeployGHOOnSonic_20250519.t.sol -vv
 */
contract AaveV3Arbitrum_DeployGHOOnSonic_20250519_Test is ProtocolV3TestBase {
  struct CCIPSendParams {
    address sender;
    uint256 amount;
    uint64 destChainSelector;
  }

  uint64 internal constant ARB_CHAIN_SELECTOR = CCIPUtils.ARB_CHAIN_SELECTOR;
  uint64 internal constant BASE_CHAIN_SELECTOR = CCIPUtils.BASE_CHAIN_SELECTOR;
  uint64 internal constant ETH_CHAIN_SELECTOR = CCIPUtils.ETH_CHAIN_SELECTOR;
  uint64 internal constant SONIC_CHAIN_SELECTOR = CCIPUtils.SONIC_CHAIN_SELECTOR;
  uint64 internal constant GNO_CHAIN_SELECTOR = CCIPUtils.GNO_CHAIN_SELECTOR;

  uint128 public constant CCIP_RATE_LIMIT_CAPACITY = CCIPLaunchConstants.CCIP_RATE_LIMIT_CAPACITY;
  uint128 public constant CCIP_RATE_LIMIT_REFILL_RATE =
    CCIPLaunchConstants.CCIP_RATE_LIMIT_REFILL_RATE;

  IGhoToken internal constant GHO = IGhoToken(AaveV3ArbitrumAssets.GHO_UNDERLYING);
  ITokenAdminRegistry internal constant TOKEN_ADMIN_REGISTRY =
    ITokenAdminRegistry(CCIPLaunchConstants.ARB_TOKEN_ADMIN_REGISTRY);
  IEVM2EVMOnRamp internal constant ETH_ON_RAMP =
    IEVM2EVMOnRamp(CCIPLaunchConstants.ARB_ETH_ON_RAMP);
  IEVM2EVMOnRamp internal constant SONIC_ON_RAMP =
    IEVM2EVMOnRamp(CCIPLaunchConstants.ARB_SONIC_ON_RAMP);
  IEVM2EVMOffRamp_1_5 internal constant ETH_OFF_RAMP =
    IEVM2EVMOffRamp_1_5(CCIPLaunchConstants.ARB_ETH_OFF_RAMP);
  IEVM2EVMOffRamp_1_5 internal constant SONIC_OFF_RAMP =
    IEVM2EVMOffRamp_1_5(CCIPLaunchConstants.ARB_SONIC_OFF_RAMP);

  address internal constant RISK_COUNCIL = CCIPLaunchConstants.RISK_COUNCIL;
  address public constant NEW_REMOTE_TOKEN_SONIC = CCIPLaunchConstants.SONIC_GHO_TOKEN;
  IRouter internal constant ROUTER = IRouter(CCIPLaunchConstants.SONIC_CCIP_ROUTER);

  IGhoCcipSteward internal constant NEW_GHO_CCIP_STEWARD =
    IGhoCcipSteward(GhoArbitrum.GHO_CCIP_STEWARD);
  IUpgradeableBurnMintTokenPool_1_5_1 internal constant NEW_TOKEN_POOL =
    IUpgradeableBurnMintTokenPool_1_5_1(GhoArbitrum.GHO_CCIP_TOKEN_POOL);

  address internal constant NEW_REMOTE_POOL_ETH = GhoEthereum.GHO_CCIP_TOKEN_POOL;
  address internal constant NEW_REMOTE_POOL_BASE = GhoBase.GHO_CCIP_TOKEN_POOL;
  address internal constant NEW_REMOTE_POOL_GNOSIS = CCIPLaunchConstants.GNO_TOKEN_POOL;
  address internal constant NEW_REMOTE_POOL_SONIC = CCIPLaunchConstants.SONIC_TOKEN_POOL;

  AaveV3Arbitrum_DeployGHOOnSonic_20250519 internal proposal;

  address internal alice = makeAddr('alice');
  address internal bob = makeAddr('bob');
  address internal carol = makeAddr('carol');

  event Burned(address indexed sender, uint256 amount);
  event Minted(address indexed sender, address indexed recipient, uint256 amount);
  event CCIPSendRequested(IInternal.EVM2EVMMessage message);

  error CallerIsNotARampOnRouter(address);
  error InvalidSourcePoolAddress(bytes);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 338322405);
    proposal = new AaveV3Arbitrum_DeployGHOOnSonic_20250519();
    _validateConstants();
  }

  function _validateConstants() private view {
    assertEq(proposal.GNOSIS_CHAIN_SELECTOR(), GNO_CHAIN_SELECTOR);
    assertEq(address(proposal.TOKEN_POOL()), address(NEW_TOKEN_POOL));
    assertEq(proposal.REMOTE_TOKEN_POOL_GNOSIS(), NEW_REMOTE_POOL_GNOSIS);
    assertEq(proposal.REMOTE_GHO_TOKEN_GNOSIS(), NEW_REMOTE_TOKEN_GNO);
    assertEq(proposal.CCIP_RATE_LIMIT_CAPACITY(), CCIP_RATE_LIMIT_CAPACITY);
    assertEq(proposal.CCIP_RATE_LIMIT_REFILL_RATE(), CCIP_RATE_LIMIT_REFILL_RATE);

    assertEq(TOKEN_ADMIN_REGISTRY.typeAndVersion(), 'TokenAdminRegistry 1.5.0');
    assertEq(NEW_TOKEN_POOL.typeAndVersion(), 'BurnMintTokenPool 1.5.1');
    assertEq(ROUTER.typeAndVersion(), 'Router 1.2.0');

    _assertOnRamp(ETH_ON_RAMP, ARB_CHAIN_SELECTOR, ETH_CHAIN_SELECTOR, ROUTER);
    _assertOnRamp(GNO_ON_RAMP, ARB_CHAIN_SELECTOR, GNO_CHAIN_SELECTOR, ROUTER);
    _assertOffRamp(ETH_OFF_RAMP, ETH_CHAIN_SELECTOR, ARB_CHAIN_SELECTOR, ROUTER);
    _assertOffRamp(GNO_OFF_RAMP, GNO_CHAIN_SELECTOR, ARB_CHAIN_SELECTOR, ROUTER);

    assertEq(NEW_GHO_CCIP_STEWARD.RISK_COUNCIL(), RISK_COUNCIL);
    assertEq(NEW_GHO_CCIP_STEWARD.GHO_TOKEN(), AaveV3ArbitrumAssets.GHO_UNDERLYING);
    assertEq(NEW_GHO_CCIP_STEWARD.GHO_TOKEN_POOL(), address(NEW_TOKEN_POOL));
    assertFalse(NEW_GHO_CCIP_STEWARD.BRIDGE_LIMIT_ENABLED());
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Arbitrum_DeployGHOOnSonic_20250519', AaveV3Arbitrum.POOL, address(proposal));
  }
}
