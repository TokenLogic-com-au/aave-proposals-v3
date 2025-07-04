// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore, PayloadsControllerUtils} from 'aave-helpers/src/GovV3Helpers.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {EthereumScript, ArbitrumScript, BaseScript, AvalancheScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Ethereum_GHOAvalancheLaunch_20250519} from './AaveV3Ethereum_GHOAvalancheLaunch_20250519.sol';
import {AaveV3Arbitrum_GHOAvalancheLaunch_20250519} from './AaveV3Arbitrum_GHOAvalancheLaunch_20250519.sol';
import {AaveV3Base_GHOAvalancheLaunch_20250519} from './AaveV3Base_GHOAvalancheLaunch_20250519.sol';
import {AaveV3Avalanche_GHOAvalancheLaunch_20250519} from './AaveV3Avalanche_GHOAvalancheLaunch_20250519.sol';
import {AaveV3Avalanche_GHOAvalancheListing_20250519} from './AaveV3Avalanche_GHOAvalancheListing_20250519.sol';
/**
 * @dev Deploy Ethereum
 * deploy-command: make deploy-ledger contract=src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch_20250519.s.sol:DeployEthereum chain=mainnet
 * verify-command: FOUNDRY_PROFILE=mainnet npx catapulta-verify -b broadcast/GHOAvalancheLaunch_20250519.s.sol/1/run-latest.json
 */
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Ethereum_GHOAvalancheLaunch_20250519).creationCode
    );

    // compose action
    IPayloadsControllerCore.ExecutionAction[]
      memory actions = new IPayloadsControllerCore.ExecutionAction[](1);
    actions[0] = GovV3Helpers.buildAction(payload0);

    // register action at payloadsController
    GovV3Helpers.createPayload(actions);
  }
}

/**
 * @dev Deploy Arbitrum
 * deploy-command: make deploy-ledger contract=src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch_20250519.s.sol:DeployArbitrum chain=arbitrum
 * verify-command: FOUNDRY_PROFILE=arbitrum npx catapulta-verify -b broadcast/GHOAvalancheLaunch_20250519.s.sol/42161/run-latest.json
 */
contract DeployArbitrum is ArbitrumScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Arbitrum_GHOAvalancheLaunch_20250519).creationCode
    );

    // compose action
    IPayloadsControllerCore.ExecutionAction[]
      memory actions = new IPayloadsControllerCore.ExecutionAction[](1);
    actions[0] = GovV3Helpers.buildAction(payload0);

    // register action at payloadsController
    GovV3Helpers.createPayload(actions);
  }
}

/**
 * @dev Deploy Base
 * deploy-command: make deploy-ledger contract=src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch_20250519.s.sol:DeployBase chain=base
 * verify-command: FOUNDRY_PROFILE=base npx catapulta-verify -b broadcast/GHOAvalancheLaunch_20250519.s.sol/8453/run-latest.json
 */
contract DeployBase is BaseScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Base_GHOAvalancheLaunch_20250519).creationCode
    );

    // compose action
    IPayloadsControllerCore.ExecutionAction[]
      memory actions = new IPayloadsControllerCore.ExecutionAction[](1);
    actions[0] = GovV3Helpers.buildAction(payload0);

    // register action at payloadsController
    GovV3Helpers.createPayload(actions);
  }
}

/**
 * @dev Deploy Avalanche
 * deploy-command: make deploy-ledger contract=src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch_20250519.s.sol:DeployAvalanche chain=avalanche
 * verify-command: FOUNDRY_PROFILE=avalanche npx catapulta-verify -b broadcast/GHOAvalancheLaunch_20250519.s.sol/100/run-latest.json
 */
contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    // compose action
    IPayloadsControllerCore.ExecutionAction[]
      memory launchActions = new IPayloadsControllerCore.ExecutionAction[](1);
    launchActions[0] = GovV3Helpers.buildAction(
      GovV3Helpers.deployDeterministic(
        type(AaveV3Avalanche_GHOAvalancheLaunch_20250519).creationCode
      )
    );

    IPayloadsControllerCore.ExecutionAction[]
      memory listingActions = new IPayloadsControllerCore.ExecutionAction[](1);
    listingActions[0] = GovV3Helpers.buildAction(
      GovV3Helpers.deployDeterministic(
        type(AaveV3Avalanche_GHOAvalancheListing_20250519).creationCode
      )
    );

    // register both actions separately at payloadsController
    GovV3Helpers.createPayload(launchActions);
    GovV3Helpers.createPayload(listingActions);
  }
}

/**
 * @dev Create Proposal
 * command: make deploy-ledger contract=src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch_20250519.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external {
    // create payloads
    PayloadsControllerUtils.Payload[] memory payloads = new PayloadsControllerUtils.Payload[](5);

    // compose actions for validation
    IPayloadsControllerCore.ExecutionAction[]
      memory actionsEthereum = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsEthereum[0] = GovV3Helpers.buildAction(
      type(AaveV3Ethereum_GHOAvalancheLaunch_20250519).creationCode
    );
    payloads[0] = GovV3Helpers.buildMainnetPayload(vm, actionsEthereum);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsArbitrum = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsArbitrum[0] = GovV3Helpers.buildAction(
      type(AaveV3Arbitrum_GHOAvalancheLaunch_20250519).creationCode
    );
    payloads[1] = GovV3Helpers.buildArbitrumPayload(vm, actionsArbitrum);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsBase = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsBase[0] = GovV3Helpers.buildAction(
      type(AaveV3Base_GHOAvalancheLaunch_20250519).creationCode
    );
    payloads[2] = GovV3Helpers.buildBasePayload(vm, actionsBase);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsAvalancheLaunch = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsAvalancheLaunch[0] = GovV3Helpers.buildAction(
      type(AaveV3Avalanche_GHOAvalancheLaunch_20250519).creationCode
    );
    payloads[3] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalancheLaunch);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsAvalancheListing = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsAvalancheListing[0] = GovV3Helpers.buildAction(
      type(AaveV3Avalanche_GHOAvalancheListing_20250519).creationCode
    );
    payloads[4] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalancheListing);

    // create proposal
    vm.startBroadcast();
    GovV3Helpers.createProposal(
      vm,
      payloads,
      GovernanceV3Ethereum.VOTING_PORTAL_ETH_POL,
      GovV3Helpers.ipfsHashFile(vm, 'src/20250519_Multi_GHOAvalancheLaunch/GHOAvalancheLaunch.md')
    );
  }
}
