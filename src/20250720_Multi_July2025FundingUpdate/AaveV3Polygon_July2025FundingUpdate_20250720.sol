// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAavePolEthERC20Bridge} from 'aave-helpers/src/bridges/polygon/IAavePolEthERC20Bridge.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title July 2025 - Funding Update
 * @author @TokenLogic
 * - Snapshot: Direct-To-AIP
 * - Discussion: https://governance.aave.com/t/direct-to-aip-july-2025-funding-update/22555
 */
contract AaveV3Polygon_July2025FundingUpdate_20250720 is IProposalGenericExecutor {
  function execute() external {
    IAavePolEthERC20Bridge(BRIDGE).bridge(AaveV3PolygonAssets.DAI_UNDERLYING, daiBalance);
  }
}
