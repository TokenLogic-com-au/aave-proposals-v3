// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers, IPayloadsControllerCore, PayloadsControllerUtils} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript, PolygonScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV2Polygon_MultipleIRCurvesUpdates_20240401} from './AaveV2Polygon_MultipleIRCurvesUpdates_20240401.sol';

/**
 * @dev Deploy Polygon
 * deploy-command: make deploy-ledger contract=src/20231221_Multi_StablecoinIRCurvesUpdates/PolygonV2IRCurvesUpdates_20240401.s.sol:DeployPolygon chain=polygon
 * verify-command: npx catapulta-verify -b broadcast/PolygonV2IRCurvesUpdates_20240401.s.sol/137/run-latest.json
 */
contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    // deploy payloads
    address payload0 = GovV3Helpers.deployDeterministic(
      type(AaveV2Polygon_MultipleIRCurvesUpdates_20240401).creationCode
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
 * command: make deploy-ledger contract=src/20231221_Multi_StablecoinIRCurvesUpdates/StablecoinIRCurvesUpdates_20231221.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external {
    // create payloads
    PayloadsControllerUtils.Payload[] memory payloads = new PayloadsControllerUtils.Payload[](1);

    IPayloadsControllerCore.ExecutionAction[]
      memory actionsPolygon = new IPayloadsControllerCore.ExecutionAction[](1);
    actionsPolygon[0] = GovV3Helpers.buildAction(
      type(AaveV2Polygon_MultipleIRCurvesUpdates_20240401).creationCode
    );
    payloads[0] = GovV3Helpers.buildPolygonPayload(vm, actionsPolygon);

    // create proposal
    vm.startBroadcast();
    GovV3Helpers.createProposal(
      vm,
      payloads,
      GovV3Helpers.ipfsHashFile(
        vm,
        'src/20240401_AaveV2Polygon_IRCurveUpdates/PolygonV2IRCurvesUpdates.md'
      )
    );
  }
}
