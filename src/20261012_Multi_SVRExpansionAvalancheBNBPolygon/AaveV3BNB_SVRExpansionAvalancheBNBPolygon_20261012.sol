// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';
import {ISvrOracleSteward} from '../interfaces/ISvrOracleSteward.sol';

/**
 * @title SVR Expansion (Avalanche, BNB, Polygon)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012 is IProposalGenericExecutor {
  // TODO: set SVR steward address
  address public constant STEWARD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_BNB_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_BTCB_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDT_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_ETH_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_wstETH_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_FDUSD_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_CAKE_USD = address(0);

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
