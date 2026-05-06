// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';

import {IsGho} from '../interfaces/IsGho.sol';
import {IsGhoSteward} from '../interfaces/IsGhoSteward.sol';
import {AaveV3Ethereum_SGhoLaunch_20260427} from './AaveV3Ethereum_SGhoLaunch_20260427.sol';

/**
 * @dev Test for AaveV3Ethereum_SGhoLaunch_20260427
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260427_AaveV3Ethereum_SGhoLaunch/AaveV3Ethereum_SGhoLaunch_20260427.t.sol -vv
 */
contract AaveV3Ethereum_SGhoLaunch_20260427_Test is ProtocolV3TestBase {
  AaveV3Ethereum_SGhoLaunch_20260427 internal proposal;

  IsGho private sgho;
  IsGhoSteward private sghoSteward;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25029360);
    proposal = new AaveV3Ethereum_SGhoLaunch_20260427();

    sgho = IsGho(proposal.SGHO());
    sghoSteward = IsGhoSteward(proposal.SGHO_STEWARD());
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Ethereum_SGhoLaunch_20260427', AaveV3Ethereum.POOL, address(proposal));
  }

  function test_initialization() public {
    assertEq(sgho.targetRate(), 0);
    assertEq(sgho.supplyCap(), 0);
    assertEq(sgho.GHO(), GhoEthereum.GHO_TOKEN);
    assertEq(IERC4626(proposal.SGHO()).asset(), GhoEthereum.GHO_TOKEN);

    assertEq(sghoSteward.sGHO(), proposal.SGHO());

    IsGhoSteward.RateConfig memory rateConfig = sghoSteward.getRateConfig();

    assertEq(rateConfig.amplification, 0);
    assertEq(rateConfig.floatRate, 0);
    assertEq(rateConfig.fixedRate, 0);

    executePayload(vm, address(proposal));

    assertEq(sgho.targetRate(), proposal.FIXED_RATE());
    assertEq(sgho.supplyCap(), proposal.SUPPLY_CAP());

    rateConfig = sghoSteward.getRateConfig();

    assertEq(rateConfig.amplification, 0);
    assertEq(rateConfig.floatRate, 0);
    assertEq(rateConfig.fixedRate, proposal.FIXED_RATE());
  }

  function test_access() public {
    assertFalse(
      IAccessControl(proposal.SGHO()).hasRole(
        sgho.PAUSE_GUARDIAN_ROLE(),
        MiscEthereum.PROTOCOL_GUARDIAN
      )
    );

    vm.prank(MiscEthereum.PROTOCOL_GUARDIAN);
    vm.expectRevert();
    sgho.pause();

    assertFalse(
      IAccessControl(proposal.SGHO()).hasRole(
        sgho.TOKEN_RESCUER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );

    assertFalse(
      IAccessControl(proposal.SGHO()).hasRole(sgho.YIELD_MANAGER_ROLE(), proposal.SGHO_STEWARD())
    );

    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FIXED_RATE_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.SUPPLY_CAP_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );

    executePayload(vm, address(proposal));

    assertTrue(
      IAccessControl(proposal.SGHO()).hasRole(
        sgho.PAUSE_GUARDIAN_ROLE(),
        MiscEthereum.PROTOCOL_GUARDIAN
      )
    );

    vm.prank(MiscEthereum.PROTOCOL_GUARDIAN);
    sgho.pause();

    assertTrue(
      IAccessControl(proposal.SGHO()).hasRole(
        sgho.TOKEN_RESCUER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );

    assertTrue(
      IAccessControl(proposal.SGHO()).hasRole(sgho.YIELD_MANAGER_ROLE(), proposal.SGHO_STEWARD())
    );

    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FIXED_RATE_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.SUPPLY_CAP_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
  }

  function test_rolesSGhoSteward() public {
    // RiskCouncil already has these roles from deployment
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.AMPLIFICATION_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FLOAT_RATE_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FIXED_RATE_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.SUPPLY_CAP_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );

    executePayload(vm, address(proposal));

    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.AMPLIFICATION_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FLOAT_RATE_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.FIXED_RATE_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
    assertTrue(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        sghoSteward.SUPPLY_CAP_MANAGER_ROLE(),
        GhoEthereum.RISK_COUNCIL
      )
    );
  }

  function test_allowance() public {
    assertEq(
      IERC20(GhoEthereum.GHO_TOKEN).allowance(
        address(AaveV3Ethereum.COLLECTOR),
        MiscEthereum.AFC_SAFE
      ),
      0
    );

    executePayload(vm, address(proposal));

    assertEq(
      IERC20(GhoEthereum.GHO_TOKEN).allowance(
        address(AaveV3Ethereum.COLLECTOR),
        MiscEthereum.AFC_SAFE
      ),
      proposal.GHO_ALLOWANCE()
    );

    uint256 balanceBefore = IERC20(GhoEthereum.GHO_TOKEN).balanceOf(proposal.SGHO());
    uint256 transferAmount = 100_000 ether;

    vm.startPrank(MiscEthereum.AFC_SAFE);
    IERC20(GhoEthereum.GHO_TOKEN).transferFrom(
      address(AaveV3Ethereum.COLLECTOR),
      proposal.SGHO(),
      transferAmount
    );
    vm.stopPrank();

    assertEq(
      IERC20(GhoEthereum.GHO_TOKEN).balanceOf(proposal.SGHO()),
      balanceBefore + transferAmount
    );
  }
}
