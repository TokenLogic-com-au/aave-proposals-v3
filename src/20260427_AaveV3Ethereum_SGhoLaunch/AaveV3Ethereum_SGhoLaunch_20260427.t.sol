// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC4626} from 'openzeppelin-contracts/contracts/interfaces/IERC4626.sol';
import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_SGhoLaunch_20260427} from './AaveV3Ethereum_SGhoLaunch_20260427.sol';

interface IsGhoSteward {
  struct RateConfig {
    uint16 amplification;
    uint16 floatRate;
    uint16 fixedRate;
  }

  function getRateConfig() external view returns (RateConfig memory);
  function sGHO() external view returns (address);
}

interface ISGho is IERC4626 {
  function GHO() external view returns (address);
  function supplyCap() external view returns (uint160);
  function targetRate() external view returns (uint16);
}

/**
 * @dev Test for AaveV3Ethereum_SGhoLaunch_20260427
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260427_AaveV3Ethereum_SGhoLaunch/AaveV3Ethereum_SGhoLaunch_20260427.t.sol -vv
 */
contract AaveV3Ethereum_SGhoLaunch_20260427_Test is ProtocolV3TestBase {
  AaveV3Ethereum_SGhoLaunch_20260427 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 24974238);
    proposal = new AaveV3Ethereum_SGhoLaunch_20260427();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest('AaveV3Ethereum_SGhoLaunch_20260427', AaveV3Ethereum.POOL, address(proposal));
  }

  function test_initialization() public {
    assertEq(ISGho(proposal.SGHO()).targetRate(), 0);
    assertEq(ISGho(proposal.SGHO()).supplyCap(), 0);
    assertEq(ISGho(proposal.SGHO()).GHO(), GhoEthereum.GHO_TOKEN);
    assertEq(ISGho(proposal.SGHO()).asset(), GhoEthereum.GHO_TOKEN);

    assertEq(IsGhoSteward(proposal.SGHO_STEWARD()).sGHO(), proposal.SGHO());

    IsGhoSteward.RateConfig memory rateConfig = IsGhoSteward(proposal.SGHO_STEWARD())
      .getRateConfig();

    assertEq(rateConfig.amplification, 0);
    assertEq(rateConfig.floatRate, 0);
    assertEq(rateConfig.fixedRate, 0);

    executePayload(vm, address(proposal));

    assertEq(ISGho(proposal.SGHO()).targetRate(), proposal.FIXED_RATE());
    assertEq(ISGho(proposal.SGHO()).supplyCap(), proposal.SUPPLY_CAP());

    rateConfig = IsGhoSteward(proposal.SGHO_STEWARD()).getRateConfig();

    assertEq(rateConfig.amplification, 0);
    assertEq(rateConfig.floatRate, 0);
    assertEq(rateConfig.fixedRate, proposal.FIXED_RATE());
  }

  function test_access() public {
    // AccessControl is only granted during execution then revoked
    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        proposal.FIXED_RATE_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        proposal.SUPPLY_CAP_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );

    executePayload(vm, address(proposal));

    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        proposal.FIXED_RATE_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
    assertFalse(
      IAccessControl(proposal.SGHO_STEWARD()).hasRole(
        proposal.SUPPLY_CAP_MANAGER_ROLE(),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      )
    );
  }
}
