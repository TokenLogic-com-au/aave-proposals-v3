// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TenderlyVirtualTestnetBase} from 'src/helpers/gsm-launch/TenderlyVirtualTestnetBase.sol';
import {GovNetworks} from 'src/helpers/gsm-launch/GovNetworks.sol';

import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';

import {AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';

import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

contract CCIPBridgeE2EVirtualTest is TenderlyVirtualTestnetBase {
  string private constant MAINNET = 'mainnet_virtual';
  string private constant ARBITRUM = 'arbitrum_virtual';

  uint256 constant EXPECTED_BRIDGE_AMOUNT = 50_000_000 ether;

  uint256 internal ghoBefore;

  function run() external {
    // Snapshot so Virtual Testnet does not drift
    string[] memory aliases = new string[](2);
    aliases[0] = 'mainnet_virtual';
    aliases[1] = 'arbitrum_virtual';
    _snapshotLifecycle(aliases, './snapshot');

    GovNetworks.GovNetwork memory eth = GovNetworks.mainnet();
    GovNetworks.GovNetwork memory arb = GovNetworks.arbitrum();

    // Deploy payloads on Virtual Testnet
    address ethPart1 = _deployPayloadOn(
      eth,
      type(AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1).creationCode
    );
    address ethPart2 = _deployPayloadOn(
      eth,
      type(AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2).creationCode
    );
    address arbPart1 = _deployPayloadOn(
      arb,
      type(AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1).creationCode
    );
    address arbPart2 = _deployPayloadOn(
      arb,
      type(AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2).creationCode
    );

    // Execute Arb Part 1
    _refork(arb.rpcAlias);
    (uint256 capBefore, ) = IGhoToken(GhoArbitrum.GHO_TOKEN).getFacilitatorBucket(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );

    _executePayloadOn(arb, arbPart1);
    _refork(arb.rpcAlias);

    (uint256 capAfter, ) = IGhoToken(GhoArbitrum.GHO_TOKEN).getFacilitatorBucket(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );
    require(capAfter == capBefore + EXPECTED_BRIDGE_AMOUNT, 'ArbPart1: bucket not increased');

    ghoBefore = IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(AaveV3Arbitrum.COLLECTOR));

    _executePayloadOn(eth, ethPart1);
    _executePayloadOn(eth, ethPart2);

    _pollUntilDelivered(arb.rpcAlias, 60, 3000);

    _executePayloadOn(arb, arbPart2);

    // Layer-2 asserts for part2 — TODO(fermin): assert the GSM state your
    // Part2 configures (registry entry, exposure cap 20M, reserve limit 25M,
    // swap freezer wiring…) exactly as in your .t.sol expectations
    _refork(ARBITRUM);
  }

  function _isDelivered() internal view override returns (bool) {
    return
      IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(address(AaveV3Arbitrum.COLLECTOR)) >=
      ghoBefore + EXPECTED_BRIDGE_AMOUNT;
  }
}

interface IExecutor {
  function executeTransaction(
    address target,
    uint256 value,
    string memory signature,
    bytes memory data,
    bool withDelegateCall
  ) external payable returns (bytes memory);
}
