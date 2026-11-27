// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IInternal} from './IInternal.sol';
import {ITypeAndVersion} from './ITypeAndVersion.sol';

/**
 * @title IEVM2EVMOffRamp_1_2
 * @notice Interface of the EVM2EVMOffRamp contract
 * @dev Adapted from https://github.com/smartcontractkit/ccip/blob/42047e5303ac910a40ccc0076643d689479e94a6/contracts/src/v0.8/ccip/offRamp/EVM2EVMOffRamp.sol
 */
interface IEVM2EVMOffRamp_1_2 is ITypeAndVersion {
  /// @notice Execute a single message.
  /// @param message The message that will be executed.
  /// @param offchainTokenData Token transfer data to be passed to TokenPool.
  /// @dev We make this external and callable by the contract itself, in order to try/catch
  /// its execution and enforce atomicity among successful message processing and token transfer.
  /// @dev We use ERC-165 to check for the ccipReceive interface to permit sending tokens to contracts
  /// (for example smart contract wallets) without an associated message.
  function executeSingleMessage(
    IInternal.EVM2EVMMessage memory message,
    bytes[] memory offchainTokenData
  ) external;
}

/**
 * @title IOffRamp_1_6
 * @notice Interface of the OffRamp contract
 * @dev Adapted from https://github.com/smartcontractkit/chainlink-ccip/blob/e9476e9948c5f84fd4e980484a520085bcc1b9d5/chains/evm/contracts/offRamp/OffRamp.sol
 */
interface IOffRamp_1_6 is ITypeAndVersion {
  /// @dev Struct that contains the static configuration. The individual components are stored as immutable variables.
  // solhint-disable-next-line gas-struct-packing
  struct StaticConfig {
    uint64 chainSelector; // ───────╮ Destination chainSelector
    uint16 gasForCallExactCheck; // | Gas for call exact check
    address rmnRemote; // ───────╯ RMN Verification Contract
    address tokenAdminRegistry; // Token admin registry address
    address nonceManager; // Nonce manager address
  }

  /// @dev Dynamic offRamp config.
  /// @dev Since DynamicConfig is part of DynamicConfigSet event, if changing it, we should update the ABI on Atlas.
  struct DynamicConfig {
    address feeQuoter; // ──────────────────────────────╮ FeeQuoter address on the local chain.
    uint32 permissionLessExecutionThresholdSeconds; // ─╯ Waiting time before manual execution is enabled.
    address messageInterceptor; // Optional, validates incoming messages (zero address = no interceptor).
  }

  /// @notice Returns the static config.
  /// @dev This function will always return the same struct as the contents is static and can never change.
  /// RMN depends on this function, if changing, please notify the RMN maintainers.
  function getStaticConfig() external view returns (StaticConfig memory);

  /// @notice Returns the current dynamic config.
  /// @return The current config.
  function getDynamicConfig() external view returns (DynamicConfig memory);
}

/**
 * @title IEVM2EVMOffRamp_1_5
 * @notice Interface of the EVM2EVMOffRamp contract
 * @dev Adapted from https://github.com/smartcontractkit/ccip/blob/b5529a39311a2fd39cafceb62e4bb8f40eeb2e9e/contracts/src/v0.8/ccip/offRamp/EVM2EVMOffRamp.sol
 */
interface IEVM2EVMOffRamp_1_5 is ITypeAndVersion {
  /// @notice Static offRamp config
  /// @dev RMN depends on this struct, if changing, please notify the RMN maintainers.
  //solhint-disable gas-struct-packing
  struct StaticConfig {
    address commitStore; // ────────╮  CommitStore address on the destination chain
    uint64 chainSelector; // ───────╯  Destination chainSelector
    uint64 sourceChainSelector; // ─╮  Source chainSelector
    address onRamp; // ─────────────╯  OnRamp address on the source chain
    address prevOffRamp; //            Address of previous-version OffRamp
    address rmnProxy; //               RMN proxy address
    address tokenAdminRegistry; //     Token admin registry address
  }

  /// @notice Dynamic offRamp config
  /// @dev since OffRampConfig is part of OffRampConfigChanged event, if changing it, we should update the ABI on Atlas
  struct DynamicConfig {
    uint32 permissionLessExecutionThresholdSeconds; // ─╮ Waiting time before manual execution is enabled
    uint32 maxDataBytes; //                             │ Maximum payload data size in bytes
    uint16 maxNumberOfTokensPerMsg; //                  │ Maximum number of ERC20 token transfers that can be included per message
    address router; // ─────────────────────────────────╯ Router address
    address priceRegistry; //                             Price registry address
  }

  /// @notice Returns the static config.
  /// @dev This function will always return the same struct as the contents is static and can never change.
  /// RMN depends on this function, if changing, please notify the RMN maintainers.
  function getStaticConfig() external view returns (StaticConfig memory);

  /// @notice Returns the current dynamic config.
  /// @return The current config.
  function getDynamicConfig() external view returns (DynamicConfig memory);

  /// @notice Execute a single message.
  /// @param message The message that will be executed.
  /// @param offchainTokenData Token transfer data to be passed to TokenPool.
  /// @dev We make this external and callable by the contract itself, in order to try/catch
  /// its execution and enforce atomicity among successful message processing and token transfer.
  /// @dev We use ERC-165 to check for the ccipReceive interface to permit sending tokens to contracts
  /// (for example smart contract wallets) without an associated message.
  function executeSingleMessage(
    IInternal.EVM2EVMMessage calldata message,
    bytes[] calldata offchainTokenData,
    uint32[] memory tokenGasOverrides
  ) external;
}
