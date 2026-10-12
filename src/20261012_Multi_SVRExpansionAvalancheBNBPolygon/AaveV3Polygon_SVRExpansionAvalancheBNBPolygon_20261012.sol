// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {ISvrOracleSteward} from '../interfaces/ISvrOracleSteward.sol';

/**
 * @title SVR Expansion (Avalanche, BNB, Polygon)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012 is IProposalGenericExecutor {
  // TODO: set SVR steward address
  address public constant STEWARD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_WBTC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDT_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_ETH_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_wstETH_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_POL_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_DAI_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_AAVE_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_EURS_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_LINK_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_MaticX_USD = address(0);

  function execute() external {
    AaveV3Polygon.ACL_MANAGER.addAssetListingAdmin(STEWARD);
    ISvrOracleSteward.AssetOracle[] memory configInput = getSvrOracles();

    ISvrOracleSteward(STEWARD).enableSvrOracles(configInput);
  }

  function getSvrOracles() public pure returns (ISvrOracleSteward.AssetOracle[] memory) {
    ISvrOracleSteward.AssetOracle[] memory configInput = new ISvrOracleSteward.AssetOracle[](12);
    configInput[0] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.WBTC_UNDERLYING,
      svrOracle: SVR_WBTC_USD
    });
    configInput[1] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.USDT0_UNDERLYING,
      svrOracle: SVR_USDT_USD
    });
    configInput[2] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.USDCn_UNDERLYING,
      svrOracle: SVR_USDC_USD
    });
    configInput[3] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.WETH_UNDERLYING,
      svrOracle: SVR_ETH_USD
    });
    configInput[4] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.wstETH_UNDERLYING,
      svrOracle: SVR_wstETH_USD
    });
    configInput[5] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.WPOL_UNDERLYING,
      svrOracle: SVR_POL_USD
    });
    configInput[6] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.USDC_UNDERLYING,
      svrOracle: SVR_USDC_USD
    });
    configInput[7] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.DAI_UNDERLYING,
      svrOracle: SVR_DAI_USD
    });
    configInput[8] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.AAVE_UNDERLYING,
      svrOracle: SVR_AAVE_USD
    });
    configInput[9] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.EURS_UNDERLYING,
      svrOracle: SVR_EURS_USD
    });
    configInput[10] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.LINK_UNDERLYING,
      svrOracle: SVR_LINK_USD
    });
    configInput[11] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3PolygonAssets.MaticX_UNDERLYING,
      svrOracle: SVR_MaticX_USD
    });

    return configInput;
  }
}
