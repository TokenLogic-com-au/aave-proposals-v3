// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';

library GovNetworks {
  struct GovNetwork {
    string rpcAlias;
    address payloadsController;
    address executor;
  }

  function arbitrum() internal pure returns (GovNetwork memory) {
    return
      GovNetwork(
        'arbitrum_virtual',
        address(GovernanceV3Arbitrum.PAYLOADS_CONTROLLER),
        GovernanceV3Arbitrum.EXECUTOR_LVL_1
      );
  }

  function mainnet() internal pure returns (GovNetwork memory) {
    return
      GovNetwork(
        'mainnet_virtual',
        address(GovernanceV3Ethereum.PAYLOADS_CONTROLLER),
        GovernanceV3Ethereum.EXECUTOR_LVL_1
      );
  }
}
