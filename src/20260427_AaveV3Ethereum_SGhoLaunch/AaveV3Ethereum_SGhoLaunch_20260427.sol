// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

interface IsGhoSteward {
  struct RateConfig {
    uint16 amplification;
    uint16 floatRate;
    uint16 fixedRate;
  }

  function setRateConfig(RateConfig calldata rateConfig) external returns (uint16);
  function setSupplyCap(uint256 supplyCap) external;
}

/**
 * @title sGho Launch
 * @author TokenLogic
 * - Snapshot: https://snapshot.box/#/s:aavedao.eth/proposal/0xb9e9b01efcf6151bade78546d0f51f11d7961939b649fb7717e82ea3d43d4f47
 * - Discussion: https://governance.aave.com/t/arfc-sgho-launch-configuration/24346
 */
contract AaveV3Ethereum_SGhoLaunch_20260427 is IProposalGenericExecutor {
  // https://etherscan.io/address/0xE1753F2e00940cC31213dd92013cF019DFE4ca1d
  address public constant SGHO = 0xE1753F2e00940cC31213dd92013cF019DFE4ca1d;

  // https://etherscan.io/address/0x60Bf2DF49F17529Cf956D57848ebEB8a0d0a2757
  address public constant SGHO_STEWARD = 0x60Bf2DF49F17529Cf956D57848ebEB8a0d0a2757;

  // sGhoSteward roles
  bytes32 public constant FIXED_RATE_MANAGER_ROLE = keccak256('FIXED_RATE_MANAGER_ROLE');
  bytes32 public constant SUPPLY_CAP_MANAGER_ROLE = keccak256('SUPPLY_CAP_MANAGER_ROLE');

  // sGho roles
  bytes32 public constant PAUSE_GUARDIAN_ROLE = keccak256('PAUSE_GUARDIAN_ROLE');
  bytes32 public constant TOKEN_RESCUER_ROLE = keccak256('TOKEN_RESCUER_ROLE');
  bytes32 public constant YIELD_MANAGER_ROLE = keccak256('YIELD_MANAGER_ROLE');

  uint256 public constant GHO_ALLOWANCE = 10_000_000 ether;
  uint256 public constant SUPPLY_CAP = 400_000_000 ether;
  uint16 public constant FIXED_RATE = 4_25;

  function execute() external {
    IAccessControl(SGHO_STEWARD).grantRole(FIXED_RATE_MANAGER_ROLE, address(this));
    IAccessControl(SGHO_STEWARD).grantRole(SUPPLY_CAP_MANAGER_ROLE, address(this));

    IAccessControl(SGHO).grantRole(PAUSE_GUARDIAN_ROLE, MiscEthereum.PROTOCOL_GUARDIAN);
    IAccessControl(SGHO).grantRole(TOKEN_RESCUER_ROLE, GovernanceV3Ethereum.EXECUTOR_LVL_1);
    IAccessControl(SGHO).grantRole(YIELD_MANAGER_ROLE, SGHO_STEWARD);

    IsGhoSteward(SGHO_STEWARD).setSupplyCap(SUPPLY_CAP);
    IsGhoSteward(SGHO_STEWARD).setRateConfig(
      IsGhoSteward.RateConfig({amplification: 0, floatRate: 0, fixedRate: FIXED_RATE})
    );

    AaveV3Ethereum.COLLECTOR.approve(
      IERC20(GhoEthereum.GHO_TOKEN),
      MiscEthereum.AFC_SAFE,
      GHO_ALLOWANCE
    );

    IAccessControl(SGHO_STEWARD).revokeRole(FIXED_RATE_MANAGER_ROLE, address(this));
    IAccessControl(SGHO_STEWARD).revokeRole(SUPPLY_CAP_MANAGER_ROLE, address(this));
  }
}
