// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore, PayloadsControllerUtils} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript, PolygonScript, AvalancheScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV2Ethereum_TemporaryFreezeOfLongTailV2Assets_20240418} from './AaveV2Ethereum_TemporaryFreezeOfLongTailV2Assets_20240418.sol';
import {AaveV2Polygon_TemporaryFreezeOfLongTailV2Assets_20240418} from './AaveV2Polygon_TemporaryFreezeOfLongTailV2Assets_20240418.sol';
import {AaveV2Avalanche_TemporaryFreezeOfLongTailV2Assets_20240418} from './AaveV2Avalanche_TemporaryFreezeOfLongTailV2Assets_20240418.sol';

/**
 * @dev Deploy Ethereum
 * deploy-command: make deploy-ledger contract=src/20240418_Multi_TemporaryFreezeOfLongTailV2Assets/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol:DeployEthereum chain=mainnet
 * verify-command: npx catapulta-verify -b broadcast/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol/1/run-latest.json
 */
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV2Ethereum_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
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
 * @dev Deploy Polygon
 * deploy-command: make deploy-ledger contract=src/20240418_Multi_TemporaryFreezeOfLongTailV2Assets/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol:DeployPolygon chain=polygon
 * verify-command: npx catapulta-verify -b broadcast/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol/137/run-latest.json
 */
contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV2Polygon_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
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
 * deploy-command: make deploy-ledger contract=src/20240418_Multi_TemporaryFreezeOfLongTailV2Assets/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol:DeployAvalanche chain=avalanche
 * verify-command: npx catapulta-verify -b broadcast/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol/43114/run-latest.json
 */
contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV2Avalanche_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
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
 * @dev Create Proposal
 * command: make deploy-ledger contract=src/20240418_Multi_TemporaryFreezeOfLongTailV2Assets/TemporaryFreezeOfLongTailV2Assets_20240418.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external {
    // create payloads
    PayloadsControllerUtils.Payload[] memory payloads = new PayloadsControllerUtils.Payload[](3);

    // compose actions for validation
    IPayloadsControllerCore.ExecutionAction[]
      memory actionsEthereum = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsEthereum[0] = GovV3Helpers.buildAction(
      type(AaveV2Ethereum_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
    );
    payloads[0] = GovV3Helpers.buildMainnetPayload(vm, actionsEthereum);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsPolygon = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsPolygon[0] = GovV3Helpers.buildAction(
      type(AaveV2Polygon_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
    );
    payloads[1] = GovV3Helpers.buildPolygonPayload(vm, actionsPolygon);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsAvalanche = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsAvalanche[0] = GovV3Helpers.buildAction(
      type(AaveV2Avalanche_TemporaryFreezeOfLongTailV2Assets_20240418).creationCode
    );
    payloads[2] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalanche);

    // create proposal
    vm.startBroadcast();
    GovV3Helpers.createProposal(
      vm,
      payloads,
      GovV3Helpers.ipfsHashFile(
        vm,
        'src/20240418_Multi_TemporaryFreezeOfLongTailV2Assets/TemporaryFreezeOfLongTailV2Assets.md'
      )
    );
  }
}
