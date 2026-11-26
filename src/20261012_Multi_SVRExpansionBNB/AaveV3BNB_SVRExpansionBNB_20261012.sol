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
  address public constant SVR_ORACLE_STEWARD = 0x65105C82DDd10Ad37DCBe7a3A137E008CC456754;

  // https://bscscan.com/address/0xD4C04c875E599eA7aFbc4C4431a9c5CFB117879d
  address public constant SVR_BNB_USD = 0xD4C04c875E599eA7aFbc4C4431a9c5CFB117879d;

  // https://bscscan.com/address/0xb2Fc37a370F002A3e5F5953D7bF805D674855852
  address public constant SVR_BTCB_USD = 0xb2Fc37a370F002A3e5F5953D7bF805D674855852;

  // https://bscscan.com/address/0x5540c0D1FEd2076d52f3bf9ABF32c828936d6ce9
  address public constant SVR_USDT_USD = 0x5540c0D1FEd2076d52f3bf9ABF32c828936d6ce9;

  // https://bscscan.com/address/0x6e748c29c445EbaA65a9E80C7a243CF0dE656D62
  address public constant SVR_USDC_USD = 0x6e748c29c445EbaA65a9E80C7a243CF0dE656D62;

  // https://bscscan.com/address/0x20583d40675F169FAD64c7fF9f3d754607e13ba0
  address public constant SVR_ETH_USD = 0x20583d40675F169FAD64c7fF9f3d754607e13ba0;

  // https://bscscan.com/address/0x73ee1BCEA229A2b578542e368377d4E10640481e
  address public constant SVR_wstETH_USD = 0x73ee1BCEA229A2b578542e368377d4E10640481e;

  // https://bscscan.com/address/0xa8288406A4b3cD4Eb3FF8180A1af438F8B037b69
  address public constant SVR_FDUSD_USD = 0xa8288406A4b3cD4Eb3FF8180A1af438F8B037b69;

  // https://bscscan.com/address/0xB224ba48D9a9d3A64569C4A77C2c3E05DB1c5407
  address public constant SVR_CAKE_USD = 0xB224ba48D9a9d3A64569C4A77C2c3E05DB1c5407;

  function execute() external {
    AaveV3BNB.ACL_MANAGER.addAssetListingAdmin(SVR_ORACLE_STEWARD);
    ISvrOracleSteward.AssetOracle[] memory configInput = getSvrOracles();

    ISvrOracleSteward(SVR_ORACLE_STEWARD).enableSvrOracles(configInput);
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
