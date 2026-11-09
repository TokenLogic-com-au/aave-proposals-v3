// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GhoEthereum} from 'aave-address-book/GhoEthereum.sol';
import {GhoAvalanche} from 'aave-address-book/GhoAvalanche.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IAaveGhoCcipBridge} from 'aave-helpers/src/bridges/ccip/interfaces/IAaveGhoCcipBridge.sol';
import {CCIPChainSelectors} from 'src/helpers/gho-launch/constants/CCIPChainSelectors.sol';
import {IGhoToken} from 'src/interfaces/IGhoToken.sol';
import {IGhoDirectFacilitator} from 'src/interfaces/IGhoDirectFacilitator.sol';

import {PermissionedGSMUSATAvalancheSetup as Setup} from './setup/PermissionedGSMUSATAvalancheSetup.sol';

/**
 * @title Permissioned GSM: USAT on Aave V4 Avalanche
 * @author TokenLogic
 * - Snapshot: TBA
 * - Discussion: https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852
 */
contract AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2 is IProposalGenericExecutor {
  using SafeERC20 for IERC20;

  // GhoDirectFacilitator, pending deployment (gho-deploy)
  address public constant DIRECT_FACILITATOR = address(0);
  string public constant DIRECT_FACILITATOR_NAME = 'GhoDirectFacilitator GSM USAT Avalanche';

  // Same gas limit the Avalanche bridge uses for its Ethereum destination
  uint32 public constant AVALANCHE_BRIDGE_GAS_LIMIT = 450_000;

  function execute() external {
    IGhoToken(AaveV3EthereumAssets.GHO_UNDERLYING).addFacilitator(
      DIRECT_FACILITATOR,
      DIRECT_FACILITATOR_NAME,
      Setup.DIRECT_FACILITATOR_CAPACITY
    );

    IGhoDirectFacilitator(DIRECT_FACILITATOR).mint(address(this), Setup.GHO_BRIDGE_AMOUNT);

    IERC20(AaveV3EthereumAssets.GHO_UNDERLYING).forceApprove(
      GhoEthereum.GHO_CCIP_BRIDGE,
      Setup.GHO_BRIDGE_AMOUNT
    );

    // The Avalanche bridge already trusts this bridge as its Ethereum source and forwards GHO to the Avalanche Collector
    IAaveGhoCcipBridge(GhoEthereum.GHO_CCIP_BRIDGE).setDestinationChain(
      CCIPChainSelectors.AVALANCHE,
      abi.encode(GhoAvalanche.GHO_CCIP_BRIDGE),
      bytes(''),
      AVALANCHE_BRIDGE_GAS_LIMIT
    );

    // Fee paid from the bridge's LINK balance; reverts within the same second as Part 1 (outbound bucket refill)
    IAaveGhoCcipBridge(GhoEthereum.GHO_CCIP_BRIDGE).send(
      CCIPChainSelectors.AVALANCHE,
      Setup.GHO_BRIDGE_AMOUNT,
      AaveV3EthereumAssets.LINK_UNDERLYING
    );

    Setup.restoreLaneRateLimitConfig(GhoEthereum.GHO_CCIP_TOKEN_POOL, CCIPChainSelectors.AVALANCHE);
  }
}
