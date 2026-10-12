// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore, PayloadsControllerUtils} from 'aave-helpers/src/GovV3Helpers.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';

import {EthereumScript, PolygonScript, AvalancheScript, BNBScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012} from './AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012.sol';
import {AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012} from './AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012.sol';
import {AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012} from './AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012.sol';

/**
 * @dev Deploy Polygon
 * deploy-command: make deploy-ledger contract=src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/SVRExpansionAvalancheBNBPolygon_20261012.s.sol:DeployPolygon chain=polygon
 * verify-command: FOUNDRY_PROFILE=deploy npx catapulta-verify -b broadcast/SVRExpansionAvalancheBNBPolygon_20261012.s.sol/137/run-latest.json
 */
contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
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
 * deploy-command: make deploy-ledger contract=src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/SVRExpansionAvalancheBNBPolygon_20261012.s.sol:DeployAvalanche chain=avalanche
 * verify-command: FOUNDRY_PROFILE=deploy npx catapulta-verify -b broadcast/SVRExpansionAvalancheBNBPolygon_20261012.s.sol/43114/run-latest.json
 */
contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
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
 * @dev Deploy BNB
 * deploy-command: make deploy-ledger contract=src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/SVRExpansionAvalancheBNBPolygon_20261012.s.sol:DeployBNB chain=bnb
 * verify-command: FOUNDRY_PROFILE=deploy npx catapulta-verify -b broadcast/SVRExpansionAvalancheBNBPolygon_20261012.s.sol/56/run-latest.json
 */
contract DeployBNB is BNBScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
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
 * command: make deploy-ledger contract=src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/SVRExpansionAvalancheBNBPolygon_20261012.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external {
    // create payloads
    PayloadsControllerUtils.Payload[] memory payloads = new PayloadsControllerUtils.Payload[](3);

    // compose actions for validation
    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsPolygon = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsPolygon[0] = GovV3Helpers.buildAction(
        type(AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
      );
      payloads[0] = GovV3Helpers.buildPolygonPayload(vm, actionsPolygon);
    }

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsAvalanche = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsAvalanche[0] = GovV3Helpers.buildAction(
        type(AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
      );
      payloads[1] = GovV3Helpers.buildAvalanchePayload(vm, actionsAvalanche);
    }

    {
      IPayloadsControllerCore.ExecutionAction[]
        memory actionsBNB = new IPayloadsControllerCore.ExecutionAction[](1);
      actionsBNB[0] = GovV3Helpers.buildAction(
        type(AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012).creationCode
      );
      payloads[2] = GovV3Helpers.buildBNBPayload(vm, actionsBNB);
    }

    // create proposal
    vm.startBroadcast();
    GovV3Helpers.createProposal(
      vm,
      payloads,
      GovernanceV3Ethereum.VOTING_PORTAL_ETH_AVAX,
      GovV3Helpers.ipfsHashFile(
        vm,
        'src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/SVRExpansionAvalancheBNBPolygon.md'
      )
    );
  }
}
