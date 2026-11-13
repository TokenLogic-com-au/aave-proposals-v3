// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {IUpgradeableBurnMintTokenPool, IRateLimiter} from 'src/interfaces/ccip/IUpgradeableBurnMintTokenPool.sol';

import {PermissionedGSMUSATAvalancheFacilitatorProposalBase} from './PermissionedGSMUSATAvalancheFacilitatorProposalBase.sol';
import {PermissionedGSMUSATAvalancheSetup as Setup} from './PermissionedGSMUSATAvalancheSetup.sol';
import {SupportedChainsCheck} from './SupportedChainsCheck.sol';

/**
 * @dev Shared tests for the remote GHO networks other than Avalanche.
 */
abstract contract PermissionedGSMUSATAvalancheFacilitatorProposalBaseTest is
  ProtocolV3TestBase,
  SupportedChainsCheck
{
  PermissionedGSMUSATAvalancheFacilitatorProposalBase internal proposal;
  uint64 internal chainSelector;

  function test_bucketCapacity() public {
    IGhoToken gho = IGhoToken(proposal.GHO_TOKEN());
    IGhoToken.Facilitator memory before = gho.getFacilitator(proposal.GHO_CCIP_TOKEN_POOL());

    executePayload(vm, address(proposal));

    IGhoToken.Facilitator memory post = gho.getFacilitator(proposal.GHO_CCIP_TOKEN_POOL());
    assertEq(post.bucketCapacity, before.bucketCapacity + Setup.GHO_BRIDGE_AMOUNT);
    assertEq(post.bucketCapacity, Setup.EXPECTED_BUCKET_CAPACITY);
    assertEq(post.bucketLevel, before.bucketLevel);
  }

  /// @dev Every lane already runs the ongoing config, so the reset changes no value
  function test_allLanesAtOngoingConfig() public {
    GhoCCIPChains.ChainInfo[] memory chains = GhoCCIPChains.getAllChainsExcept(
      chainSelector,
      false
    );
    _assertAllLanesDefault(chains);

    executePayload(vm, address(proposal));

    _assertAllLanesDefault(chains);
  }

  function test_supportedChainsMatchLibrary() public view {
    _assertSupportedChainsMatchLibrary(proposal.GHO_CCIP_TOKEN_POOL(), chainSelector);
  }

  function _assertAllLanesDefault(GhoCCIPChains.ChainInfo[] memory chains) internal view {
    IUpgradeableBurnMintTokenPool pool = IUpgradeableBurnMintTokenPool(
      proposal.GHO_CCIP_TOKEN_POOL()
    );
    for (uint256 i = 0; i < chains.length; i++) {
      _assertDefault(pool.getCurrentInboundRateLimiterState(chains[i].chainSelector));
      _assertDefault(pool.getCurrentOutboundRateLimiterState(chains[i].chainSelector));
    }
  }

  function _assertDefault(IRateLimiter.TokenBucket memory bucket) internal pure {
    assertTrue(bucket.isEnabled);
    assertEq(bucket.capacity, Setup.DEFAULT_RATE_LIMITER_CAPACITY);
    assertEq(bucket.rate, Setup.DEFAULT_LIMITER_RATE);
  }
}
