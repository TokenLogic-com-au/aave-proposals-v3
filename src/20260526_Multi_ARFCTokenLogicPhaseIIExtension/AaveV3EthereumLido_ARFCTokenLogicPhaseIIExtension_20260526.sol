// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {CollectorUtils} from 'aave-helpers/src/CollectorUtils.sol';
import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

/**
 * @title [ARFC] TokenLogic Phase II - Extension
 * @author @TokenLogic
 * - Snapshot: https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69
 * - Discussion: https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846
 */
contract AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526 is IProposalGenericExecutor {
  address public constant TOKEN_LOGIC = 0xAA088dfF3dcF619664094945028d44E779F19894;

  uint256 public constant PREVIOUS_STREAM = 100072;

  uint256 public constant STREAM_DURATION = 365 days;

  uint256 public constant GHO_ALLOWANCE = 2_000_000 ether;
  uint256 public constant GHO_STREAM_AMOUNT = 2_500_000 ether;

  function execute() external {
    AaveV3EthereumLido.COLLECTOR.cancelStream(PREVIOUS_STREAM);

    uint256 currentAllowance = IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN).allowance(
      address(AaveV3EthereumLido.COLLECTOR),
      TOKEN_LOGIC
    );
    AaveV3EthereumLido.COLLECTOR.approve(
      IERC20(AaveV3EthereumLidoAssets.GHO_A_TOKEN),
      TOKEN_LOGIC,
      currentAllowance + GHO_ALLOWANCE
    );

    CollectorUtils.stream(
      AaveV3EthereumLido.COLLECTOR,
      CollectorUtils.CreateStreamInput({
        underlying: AaveV3EthereumLidoAssets.GHO_A_TOKEN,
        receiver: TOKEN_LOGIC,
        amount: GHO_STREAM_AMOUNT,
        start: block.timestamp,
        duration: STREAM_DURATION
      })
    );
  }
}
