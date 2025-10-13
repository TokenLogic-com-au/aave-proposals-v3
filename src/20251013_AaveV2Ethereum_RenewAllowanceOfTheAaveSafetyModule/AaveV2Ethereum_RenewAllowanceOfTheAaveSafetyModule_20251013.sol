// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveSafetyModule} from 'aave-address-book/AaveSafetyModule.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {IAaveEcosystemReserveController} from 'aave-address-book/common/IAaveEcosystemReserveController.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';

/**
 * @title Renew allowance of the Aave Safety Module
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV2Ethereum_RenewAllowanceOfTheAaveSafetyModule_20251013 is IProposalGenericExecutor {
  uint256 public constant STKAAVE_ALLOWANCE = 401_500 ether;
  uint256 public constant STKABPT_ALLOWANCE = 401_500 ether;

  function execute() external override {
    // For requirement of the controller, first we reset allowance to 0
    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.approve(
      MiscEthereum.ECOSYSTEM_RESERVE,
      AaveV2EthereumAssets.AAVE_UNDERLYING,
      AaveSafetyModule.STK_AAVE,
      0
    );

    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.approve(
      MiscEthereum.ECOSYSTEM_RESERVE,
      AaveV2EthereumAssets.AAVE_UNDERLYING,
      AaveSafetyModule.STK_ABPT,
      0
    );

    // Then set new allowances
    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.approve(
      MiscEthereum.ECOSYSTEM_RESERVE,
      AaveV2EthereumAssets.AAVE_UNDERLYING,
      AaveSafetyModule.STK_AAVE,
      STKAAVE_ALLOWANCE
    );

    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.approve(
      MiscEthereum.ECOSYSTEM_RESERVE,
      AaveV2EthereumAssets.AAVE_UNDERLYING,
      AaveSafetyModule.STK_ABPT,
      STKABPT_ALLOWANCE
    );
  }
}
