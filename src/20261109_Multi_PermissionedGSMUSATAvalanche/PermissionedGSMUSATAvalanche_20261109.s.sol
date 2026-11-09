// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {EthereumScript, AvalancheScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';

import {AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1} from './AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.sol';
import {AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2} from './AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.sol';
import {AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1} from './AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.sol';
import {AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2} from './AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.sol';

/**
 * @dev Deploy Ethereum
 * deploy-command: make deploy-ledger contract=src/20261109_Multi_PermissionedGSMUSATAvalanche/PermissionedGSMUSATAvalanche_20261109.s.sol:DeployEthereum chain=mainnet
 * verify-command: FOUNDRY_PROFILE=deploy npx catapulta-verify -b broadcast/PermissionedGSMUSATAvalanche_20261109.s.sol/1/run-latest.json
 */
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1).creationCode
    );
    address payload1 = GovV3Helpers.deployDeterministic(
      type(AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2).creationCode
    );

    GovV3Helpers.createPayload(GovV3Helpers.buildAction(payload0));
    GovV3Helpers.createPayload(GovV3Helpers.buildAction(payload1));
  }
}

/**
 * @dev Deploy Avalanche
 * deploy-command: make deploy-ledger contract=src/20261109_Multi_PermissionedGSMUSATAvalanche/PermissionedGSMUSATAvalanche_20261109.s.sol:DeployAvalanche chain=avalanche
 * verify-command: FOUNDRY_PROFILE=deploy npx catapulta-verify -b broadcast/PermissionedGSMUSATAvalanche_20261109.s.sol/43114/run-latest.json
 */
contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1).creationCode
    );
    address payload1 = GovV3Helpers.deployDeterministic(
      type(AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2).creationCode
    );

    GovV3Helpers.createPayload(GovV3Helpers.buildAction(payload0));
    GovV3Helpers.createPayload(GovV3Helpers.buildAction(payload1));
  }
}
