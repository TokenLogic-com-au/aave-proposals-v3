// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore, PayloadsControllerUtils} from 'aave-helpers/src/GovV3Helpers.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
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

/**
 * @dev Create Proposal
 * command: make deploy-ledger contract=src/20261109_Multi_PermissionedGSMUSATAvalanche/PermissionedGSMUSATAvalanche_20261109.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external {
    PayloadsControllerUtils.Payload[] memory payloads = new PayloadsControllerUtils.Payload[](4);

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsEthereum = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsEthereum[0] = GovV3Helpers.buildAction(
        type(AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1).creationCode
      );
      payloads[0] = GovV3Helpers.buildMainnetPayload(vm, actionsEthereum);
    }

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsEthereum = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsEthereum[0] = GovV3Helpers.buildAction(
        type(AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2).creationCode
      );
      payloads[1] = GovV3Helpers.buildMainnetPayload(vm, actionsEthereum);
    }

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsAvalanche = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsAvalanche[0] = GovV3Helpers.buildAction(
        type(AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1).creationCode
      );
      payloads[2] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalanche);
    }

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsAvalanche = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsAvalanche[0] = GovV3Helpers.buildAction(
        type(AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2).creationCode
      );
      payloads[3] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalanche);
    }

    vm.startBroadcast();
    GovV3Helpers.createProposal(
      vm,
      payloads,
      GovernanceV3Ethereum.VOTING_PORTAL_ETH_AVAX,
      GovV3Helpers.ipfsHashFile(
        vm,
        'src/20261109_Multi_PermissionedGSMUSATAvalanche/PermissionedGSMUSATAvalanche.md'
      )
    );
  }
}
