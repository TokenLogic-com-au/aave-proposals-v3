// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';

/**
 * @title [ARFC] TokenLogic Phase II - Extension
 * @author @TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69
 * - Discussion: https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846
 */
contract AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526 is IProposalGenericExecutor {
  address public constant TOKEN_LOGIC = 0xAA088dfF3dcF619664094945028d44E779F19894;

  uint256 public constant STREAM_DURATION = 365 days;

  uint256 public constant AAVE_STREAM_AMOUNT = 5_000 ether;

  function execute() external {
    uint256 aaveStreamAmount = (AAVE_STREAM_AMOUNT / STREAM_DURATION) * STREAM_DURATION;
    MiscEthereum.AAVE_ECOSYSTEM_RESERVE_CONTROLLER.createStream(
      MiscEthereum.ECOSYSTEM_RESERVE,
      TOKEN_LOGIC,
      aaveStreamAmount,
      AaveV3EthereumAssets.AAVE_UNDERLYING,
      block.timestamp,
      block.timestamp + STREAM_DURATION
    );
  }
}
