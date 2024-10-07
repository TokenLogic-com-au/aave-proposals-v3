// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IAccessControl} from '@openzeppelin/contracts/access/IAccessControl.sol';
import {TransparentUpgradeableProxy} from 'solidity-utils/contracts/transparent-proxy/TransparentUpgradeableProxy.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {AaveV3Arbitrum_GHOStewardV2Upgrade_20241007} from './AaveV3Arbitrum_GHOStewardV2Upgrade_20241007.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGsm} from 'src/interfaces/IGsm.sol';
import {IUpgradeableLockReleaseTokenPool} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';

/**
 * @dev Test for AaveV3Arbitrum_GHOStewardV2Upgrade_20241007
 * command: FOUNDRY_PROFILE=arbitrum forge test --match-path=src/20241007_Multi_GHOStewardV2Upgrade/AaveV3Arbitrum_GHOStewardV2Upgrade_20241007.t.sol -vv
 */
contract AaveV3Arbitrum_GHOStewardV2Upgrade_20241007_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_GHOStewardV2Upgrade_20241007 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 261341067);
    proposal = new AaveV3Arbitrum_GHOStewardV2Upgrade_20241007();
  }

  function test_roles() public {
    // address ACL_MANAGER = AaveV3MiscArbitrum.POOL_ADDRESSES_PROVIDER.getACLManager();
    address ACL_MANAGER = 0xc2aaCf6553D20d1e9d78E365AAba8032af9c85b0;

    // Gho Bucket Steward
    assertEq(
      IGhoToken(AaveV3ArbitrumAssets.GHO_UNDERLYING).hasRole(
        IGhoToken(AaveV3ArbitrumAssets.GHO_UNDERLYING).BUCKET_MANAGER_ROLE(),
        proposal.GHO_BUCKET_STEWARD()
      ),
      false
    );

    // Gho Aave Steward
    assertEq(
      IAccessControl(ACL_MANAGER).hasRole(
        IACLManager(ACL_MANAGER).RISK_ADMIN_ROLE(),
        proposal.GHO_AAVE_STEWARD()
      ),
      false
    );

    // Gho CCIP Steward
    assertEq(
      IUpgradeableLockReleaseTokenPool(MiscArbitrum.GHO_CCIP_TOKEN_POOL).getRateLimitAdmin(),
      address(0)
    );

    executePayload(vm, address(proposal));

    vm.prank(GovernanceV3Arbitrum.EXECUTOR_LVL_1);
    address impl = TransparentUpgradeableProxy(payable(MiscArbitrum.GHO_CCIP_TOKEN_POOL))
      .implementation();

    assertEq(impl, proposal.NEW_CCIP_POOL_TOKEN());

    // Gho Bucket Steward
    assertEq(
      IGhoToken(AaveV3ArbitrumAssets.GHO_UNDERLYING).hasRole(
        IGhoToken(AaveV3ArbitrumAssets.GHO_UNDERLYING).BUCKET_MANAGER_ROLE(),
        proposal.GHO_BUCKET_STEWARD()
      ),
      true
    );

    // Gho Aave Steward
    assertEq(
      IAccessControl(ACL_MANAGER).hasRole(
        IACLManager(ACL_MANAGER).RISK_ADMIN_ROLE(),
        proposal.GHO_AAVE_STEWARD()
      ),
      true
    );

    assertEq(
      IUpgradeableLockReleaseTokenPool(MiscArbitrum.GHO_CCIP_TOKEN_POOL).getRateLimitAdmin(),
      proposal.GHO_CCIP_STEWARD()
    );
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Arbitrum_GHOStewardV2Upgrade_20241007',
      AaveV3Arbitrum.POOL,
      address(proposal)
    );
  }
}
