// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';
import {ISvrOracleSteward} from '../interfaces/ISvrOracleSteward.sol';

/**
 * @title SVR Expansion (BNB)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3BNB_SVRExpansionBNB_20261012 is IProposalGenericExecutor {
  // https://bscscan.com/address/0x65105C82DDd10Ad37DCBe7a3A137E008CC456754
  address public constant STEWARD = 0x65105C82DDd10Ad37DCBe7a3A137E008CC456754;

  // https://bscscan.com/address/0xdca984ba9029188C8bcF494B0541A8A620e71b76
  address public constant SVR_BNB_USD = 0xdca984ba9029188C8bcF494B0541A8A620e71b76;

  // https://bscscan.com/address/0xaDb448B9Cc76359E6d27BeC25640B355d829785B
  address public constant SVR_BTCB_USD = 0xaDb448B9Cc76359E6d27BeC25640B355d829785B;

  // https://bscscan.com/address/0x9BFf47f30Da132C8D91A3Ae723af8880E0fB4e22
  address public constant SVR_USDT_USD = 0x9BFf47f30Da132C8D91A3Ae723af8880E0fB4e22;

  // https://bscscan.com/address/0xB1965ff04EC3626D36C0480622Fd843DEAdd852b
  address public constant SVR_USDC_USD = 0xB1965ff04EC3626D36C0480622Fd843DEAdd852b;

  // https://bscscan.com/address/0xa0fAd7Fa1A57100fC4f4ef3ef1f6DdF1c623e4d4
  address public constant SVR_ETH_USD = 0xa0fAd7Fa1A57100fC4f4ef3ef1f6DdF1c623e4d4;

  // https://bscscan.com/address/0x527B9A2Cfce08F66C475E98769aA1c37795b89A3
  address public constant SVR_wstETH_USD = 0x527B9A2Cfce08F66C475E98769aA1c37795b89A3;

  // https://bscscan.com/address/0x7570bdcB52eeE78847a9af6207F05FD0D2B5dc85
  address public constant SVR_FDUSD_USD = 0x7570bdcB52eeE78847a9af6207F05FD0D2B5dc85;

  // https://bscscan.com/address/0xFE6C88dE04c3088d7C9B92153E92D555DC0EbE92
  address public constant SVR_CAKE_USD = 0xFE6C88dE04c3088d7C9B92153E92D555DC0EbE92;

  function execute() external {
    AaveV3BNB.ACL_MANAGER.addAssetListingAdmin(STEWARD);
    ISvrOracleSteward.AssetOracle[] memory configInput = getSvrOracles();

    ISvrOracleSteward(STEWARD).enableSvrOracles(configInput);
  }

  function getSvrOracles() public pure returns (ISvrOracleSteward.AssetOracle[] memory) {
    ISvrOracleSteward.AssetOracle[] memory configInput = new ISvrOracleSteward.AssetOracle[](8);
    configInput[0] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.WBNB_UNDERLYING,
      svrOracle: SVR_BNB_USD
    });
    configInput[1] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.BTCB_UNDERLYING,
      svrOracle: SVR_BTCB_USD
    });
    configInput[2] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.USDT_UNDERLYING,
      svrOracle: SVR_USDT_USD
    });
    configInput[3] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.USDC_UNDERLYING,
      svrOracle: SVR_USDC_USD
    });
    configInput[4] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.ETH_UNDERLYING,
      svrOracle: SVR_ETH_USD
    });
    configInput[5] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.wstETH_UNDERLYING,
      svrOracle: SVR_wstETH_USD
    });
    configInput[6] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.FDUSD_UNDERLYING,
      svrOracle: SVR_FDUSD_USD
    });
    configInput[7] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3BNBAssets.Cake_UNDERLYING,
      svrOracle: SVR_CAKE_USD
    });

    return configInput;
  }
}
