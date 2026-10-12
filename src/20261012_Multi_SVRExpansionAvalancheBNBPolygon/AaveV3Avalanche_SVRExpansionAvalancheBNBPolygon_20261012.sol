// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/src/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {ISvrOracleSteward} from '../interfaces/ISvrOracleSteward.sol';

/**
 * @title SVR Expansion (Avalanche, BNB, Polygon)
 * @author TokenLogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332
 */
contract AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012 is IProposalGenericExecutor {
  // TODO: set SVR steward address
  address public constant STEWARD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_BTCb_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_AVAX_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_sAVAX_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_ETH_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDT_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_DAI_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_EURC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_LINK_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_AUSD_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_AAVE_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_WBTC_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_sUSDe_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_FRAX_USD = address(0);

  // TODO: set SVR oracle address (constant or address book)
  address public constant SVR_USDe_USD = address(0);

  function execute() external {
    AaveV3Avalanche.ACL_MANAGER.addAssetListingAdmin(STEWARD);
    ISvrOracleSteward.AssetOracle[] memory configInput = getSvrOracles();

    ISvrOracleSteward(STEWARD).enableSvrOracles(configInput);
  }

  function getSvrOracles() public pure returns (ISvrOracleSteward.AssetOracle[] memory) {
    ISvrOracleSteward.AssetOracle[] memory configInput = new ISvrOracleSteward.AssetOracle[](15);
    configInput[0] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.BTCb_UNDERLYING,
      svrOracle: SVR_BTCb_USD
    });
    configInput[1] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.WAVAX_UNDERLYING,
      svrOracle: SVR_AVAX_USD
    });
    configInput[2] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.sAVAX_UNDERLYING,
      svrOracle: SVR_sAVAX_USD
    });
    configInput[3] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.USDC_UNDERLYING,
      svrOracle: SVR_USDC_USD
    });
    configInput[4] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.WETHe_UNDERLYING,
      svrOracle: SVR_ETH_USD
    });
    configInput[5] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.USDt_UNDERLYING,
      svrOracle: SVR_USDT_USD
    });
    configInput[6] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.DAIe_UNDERLYING,
      svrOracle: SVR_DAI_USD
    });
    configInput[7] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.EURC_UNDERLYING,
      svrOracle: SVR_EURC_USD
    });
    configInput[8] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.LINKe_UNDERLYING,
      svrOracle: SVR_LINK_USD
    });
    configInput[9] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.AUSD_UNDERLYING,
      svrOracle: SVR_AUSD_USD
    });
    configInput[10] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.AAVEe_UNDERLYING,
      svrOracle: SVR_AAVE_USD
    });
    configInput[11] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.WBTCe_UNDERLYING,
      svrOracle: SVR_WBTC_USD
    });
    configInput[12] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.sUSDe_UNDERLYING,
      svrOracle: SVR_sUSDe_USD
    });
    configInput[13] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.FRAX_UNDERLYING,
      svrOracle: SVR_FRAX_USD
    });
    configInput[14] = ISvrOracleSteward.AssetOracle({
      asset: AaveV3AvalancheAssets.USDe_UNDERLYING,
      svrOracle: SVR_USDe_USD
    });

    return configInput;
  }
}
