// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {IEmissionManager} from 'aave-v3-origin/contracts/rewards/interfaces/IEmissionManager.sol';

/**
 * @title Incentive Campaign
 * @author karpatkey_TokenLogic
 * - Snapshot: TBA
 * - Discussion: https://governance.aave.com/t/arfc-pyusd-reserve-configuration-update-incentive-campaign/19573
 */
contract AaveV3Ethereum_IncentiveCampaign_20241028 is IProposalGenericExecutor {
  address public constant ALC_SAFE = 0xA1c93D2687f7014Aaf588c764E3Ce80aF016229b;
  address public constant ALC_TREASURY = 0xac140648435d03f784879cd789130F22Ef588Fcd;
  uint256 public constant GHO_AMOUNT = 300_000 ether;

  function execute() external {
    AaveV3Ethereum.COLLECTOR.approve(AaveV3EthereumAssets.GHO_UNDERLYING, ALC_SAFE, GHO_AMOUNT);

    IEmissionManager(AaveV3Ethereum.EMISSION_MANAGER).setEmissionAdmin(
      AaveV3EthereumAssets.PYUSD_A_TOKEN,
      ALC_TREASURY
    );
  }
}
