// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console2} from 'forge-std/Script.sol';
import {GovernanceV3Ethereum} from 'aave-address-book/GovernanceV3Ethereum.sol';
import {GovernanceV3Arbitrum} from 'aave-address-book/GovernanceV3Arbitrum.sol';
import {GhoArbitrum} from 'aave-address-book/GhoArbitrum.sol';

import {AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1.sol';
import {AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2} from './AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2.sol';

import {IGhoToken} from 'src/interfaces/IGhoToken.sol';

contract CCIPBridgeE2EVirtualTest is Script {
  string private constant MAINNET = 'mainnet_virtual';
  string private constant ARBITRUM = 'arbitrum_virtual';

  string private constant SNAP_FILE_MAINNET = './snapshot/.snap_mainnet';
  string private constant SNAP_FILE_ARB = './snapshot/.snap_arb';

  uint256 constant NEW_BUCKET_CAPACITY = 150_000_000 ether;

  uint256 constant EXPECTED_BRIDGE_AMOUNT = 50_000_000 ether;

  // GhoReserve on Arbitrum
  // https://arbiscan.io/address/0xC912D64F9F649897dC0244da3835869d410d053e
  address constant GHO_RESERVE = 0xC912D64F9F649897dC0244da3835869d410d053e;

  // Some funded address on virtual testnet
  address constant DEPLOYER = 0xDE910C0000000000000000000000000000000001;

  string private currentFork;

  function run() external {
    // Snapshot so Virtual Testnet does not drift
    _snapshotVirtualTestnet();

    // Deploy payloads on Virtual Testnet
    _refork(MAINNET);
    _fund(DEPLOYER);
    _fund(address(GovernanceV3Ethereum.PAYLOADS_CONTROLLER));
    address ethPart1 = _deployOnVirtualTestnet(
      type(AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part1).creationCode
    );
    address ethPart2 = _deployOnVirtualTestnet(
      type(AaveV3Ethereum_RemoteGSMLaunchArbitrum_20260512_Part2).creationCode
    );

    _refork(ARBITRUM);
    _fund(DEPLOYER);
    _fund(address(GovernanceV3Arbitrum.PAYLOADS_CONTROLLER));
    address arbPart1 = _deployOnVirtualTestnet(
      type(AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part1).creationCode
    );
    address arbPart2 = _deployOnVirtualTestnet(
      type(AaveV3Arbitrum_RemoteGSMLaunchArbitrum_20260512_Part2).creationCode
    );

    // Execute Arbitrum Part to Increase Bridge Limit and Rate Limit
    _executePayload(
      address(GovernanceV3Arbitrum.PAYLOADS_CONTROLLER),
      GovernanceV3Arbitrum.EXECUTOR_LVL_1,
      arbPart1
    );

    // Test Arbitrum Values
    _refork(ARBITRUM);
    (uint256 cap, ) = IGhoToken(GhoArbitrum.GHO_TOKEN).getFacilitatorBucket(
      GhoArbitrum.GHO_CCIP_TOKEN_POOL
    );
    require(cap == NEW_BUCKET_CAPACITY, 'ArbPart1 Bucket Capacity Not Updated');

    // Snaposhot GhoReserve value before
    uint256 ghoBefore = IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(GHO_RESERVE);
    require(ghoBefore == 0, 'Invalid GhoReserve GHO balance');

    // Execute Ethereum Parts 1 and 2 sequentially
    _refork(MAINNET);
    _executePayload(
      address(GovernanceV3Ethereum.PAYLOADS_CONTROLLER),
      GovernanceV3Ethereum.EXECUTOR_LVL_1,
      ethPart1
    );
    _executePayload(
      address(GovernanceV3Ethereum.PAYLOADS_CONTROLLER),
      GovernanceV3Ethereum.EXECUTOR_LVL_1,
      ethPart2
    );

    // Wait for Arbitrum to receive message
    bool delivered;
    for (uint256 i = 0; i < 60; i++) {
      console2.log('running loop:');
      console2.log(i);
      _refork(ARBITRUM);
      uint256 ghoAfter = IGhoToken(GhoArbitrum.GHO_TOKEN).balanceOf(GHO_RESERVE);
      if (ghoAfter >= ghoBefore + EXPECTED_BRIDGE_AMOUNT) {
        delivered = true;
        break;
      }
      vm.sleep(3000); // Wait 3 seconds (real wait time is 20 minutes)
    }
    require(delivered, 'CCIP message never delivered by relay');

    // Execute Arbitrum Parte 2
    _executePayload(
      address(GovernanceV3Arbitrum.PAYLOADS_CONTROLLER),
      GovernanceV3Arbitrum.EXECUTOR_LVL_1,
      arbPart2
    );

    // Layer-2 asserts for part2 — TODO(fermin): assert the GSM state your
    // Part2 configures (registry entry, exposure cap 20M, reserve limit 25M,
    // swap freezer wiring…) exactly as in your .t.sol expectations
    _refork(ARBITRUM);
  }

  /// Deploy on Virtual Testnet
  function _deployOnVirtualTestnet(bytes memory creationCode) internal returns (address deployed) {
    // Compute the CREATE address from the deployer's current VTN nonce
    bytes memory nonceRet = vm.rpc(
      'eth_getTransactionCount',
      string.concat('["', vm.toString(DEPLOYER), '","latest"]')
    );
    uint256 nonce = _toUint(nonceRet);
    deployed = vm.computeCreateAddress(DEPLOYER, nonce);

    vm.rpc(
      'eth_sendTransaction',
      string.concat(
        '[{"from":"',
        vm.toString(DEPLOYER),
        '","data":"',
        vm.toString(creationCode),
        '"}]'
      )
    );

    // Validate deployed
    _reforkCurrent();
    require(deployed.code.length > 0, 'VTN deploy failed');
  }

  /// PayloadsController real action
  function _executePayload(address controller, address executor, address payload) internal {
    bytes memory data = abi.encodeCall(
      IExecutor.executeTransaction,
      (payload, 0, 'execute()', '', true)
    );
    vm.rpc(
      'eth_sendTransaction',
      string.concat(
        '[{"from":"',
        vm.toString(controller),
        '","to":"',
        vm.toString(executor),
        '","data":"',
        vm.toString(data),
        '"}]'
      )
    );
  }

  function _fund(address who) internal {
    vm.rpc(
      'tenderly_setBalance',
      string.concat('[["', vm.toString(who), '"], "0xDE0B6B3A7640000"]')
    );
  }

  /// Pull updated fork state
  function _refork(string memory fork) internal {
    currentFork = fork;
    vm.selectFork(vm.createFork(vm.rpcUrl(fork)));
  }

  function _reforkCurrent() internal {
    _refork(currentFork);
  }

  function _toUint(bytes memory rpcResult) internal pure returns (uint256 v) {
    for (uint256 i = 0; i < rpcResult.length; i++) {
      v = (v << 8) | uint8(rpcResult[i]);
    }
  }

  function _snapshot(string memory fork) internal returns (string memory id) {
    _refork(fork);
    bytes memory ret = vm.rpc('evm_snapshot', '[]');
    id = vm.toString(ret);
    require(bytes(id).length == 66, string.concat('Unexpected Snapshot Id shape: ', id));
    console2.log('snapshot', fork, id);
  }

  function _readSnapshot(string memory path) internal view returns (string memory) {
    try vm.readFile(path) returns (string memory s) {
      return s;
    } catch {
      return '';
    }
  }

  function _revertTo(string memory fork, string memory id) internal {
    _refork(fork);
    bytes memory ret = vm.rpc('evm_revert', string.concat('["', id, '"]'));
    require(_isTrue(ret), string.concat('evm_revert=false on ', fork, ' for ', id));
    _refork(fork);
  }

  function _isTrue(bytes memory ret) internal pure returns (bool) {
    if (ret.length == 1) return ret[0] == 0x01;
    if (ret.length == 32) return uint256(bytes32(ret)) == 1;
    return keccak256(ret) == keccak256(bytes('true'));
  }

  function _snapshotVirtualTestnet() internal {
    if (!vm.exists('./snapshot')) {
      vm.createDir('./snapshot', true);
    }

    string memory snapMainnet = _readSnapshot(SNAP_FILE_MAINNET);
    string memory snapArb = _readSnapshot(SNAP_FILE_ARB);

    if (bytes(snapMainnet).length != 0) {
      _revertTo(MAINNET, snapMainnet);
      _revertTo(ARBITRUM, snapArb);

      (uint256 cap, ) = IGhoToken(GhoArbitrum.GHO_TOKEN).getFacilitatorBucket(
        GhoArbitrum.GHO_CCIP_TOKEN_POOL
      );
      require(cap < NEW_BUCKET_CAPACITY, 'baseline not restored: bucket already at 150M');
    }

    vm.writeFile(SNAP_FILE_MAINNET, _snapshot(MAINNET));
    vm.writeFile(SNAP_FILE_ARB, _snapshot(ARBITRUM));
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
