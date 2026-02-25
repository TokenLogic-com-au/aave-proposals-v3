// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {IStakeToken} from 'aave-helpers/lib/aave-address-book/src/common/IStakeToken.sol';
import {AaveSafetyModule} from 'aave-address-book/AaveSafetyModule.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

/**
 * @title Reduce Safety Module Emissions
 * @author @TokenLogic
 * - Snapshot: https;//
 * - Discussion: https://
 */
contract AaveV3Ethereum_ReduceSafetyModuleEmissions_20260224 is IProposalGenericExecutor {
  uint128 public constant STK_AAVE_EMISSION_PER_SECOND = uint128(uint256(220 ether) / 1 days);
  uint256 public constant STK_AAVE_COOLDOWN_SECONDS = 2 days;

  function execute() external override {
    IStakeToken(AaveSafetyModule.STK_ABPT).setCooldownSeconds(0);

    IStakeToken stkAAVE = IStakeToken(AaveSafetyModule.STK_AAVE);

    IStakeToken.AssetConfigInput[] memory stkAAVEConfig = new IStakeToken.AssetConfigInput[](1);
    stkAAVEConfig[0] = IStakeToken.AssetConfigInput({
      emissionPerSecond: STK_AAVE_EMISSION_PER_SECOND,
      totalStaked: IERC20(AaveSafetyModule.STK_AAVE).totalSupply(),
      underlyingAsset: AaveSafetyModule.STK_AAVE
    });

    stkAAVE.configureAssets(stkAAVEConfig);
    stkAAVE.setCooldownSeconds(STK_AAVE_COOLDOWN_SECONDS);
  }
}
