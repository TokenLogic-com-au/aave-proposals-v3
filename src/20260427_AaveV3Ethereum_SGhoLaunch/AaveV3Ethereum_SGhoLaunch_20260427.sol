// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
  address public constant SGHO = address(0);
  address public constant SGHO_STEWARD = address(0);

  uint160 public constant SUPPLY_CAP = 400_000_000 ether;
  uint16 public constant FIXED_RATE = 4_25;

  bytes32 public constant FIXED_RATE_MANAGER_ROLE = keccak256('FIXED_RATE_MANAGER_ROLE');
  bytes32 public constant SUPPLY_CAP_MANAGER_ROLE = keccak256('SUPPLY_CAP_MANAGER_ROLE');

  function execute() external {
    IAccessControl(SGHO_STEWARD).grantRole(FIXED_RATE_MANAGER_ROLE, address(this));
    IAccessControl(SGHO_STEWARD).grantRole(SUPPLY_CAP_MANAGER_ROLE, address(this));

    IsGhoSteward(SGHO_STEWARD).setSupplyCap(SUPPLY_CAP);

    IsGhoSteward(SGHO_STEWARD).setRateConfig(
      IsGhoSteward.RateConfig({amplification: 0, floatRate: 0, fixedRate: FIXED_RATE})
    );

    IAccessControl(SGHO_STEWARD).revokeRole(FIXED_RATE_MANAGER_ROLE, address(this));
    IAccessControl(SGHO_STEWARD).revokeRole(SUPPLY_CAP_MANAGER_ROLE, address(this));
  }
}
