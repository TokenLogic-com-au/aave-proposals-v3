import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20261022_AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma/config.ts',
    markets: ['AaveV3Plasma'],
    title: 'Asset Listing - Pendle PT-sUSDe-28JAN2027 Plasma',
    shortName: 'AssetListingPendlePTsUSDe28JAN2027Plasma',
    date: '20261022',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-onboard-pt-susde-28jan2027-to-aave-v3-plasma-instance/25902',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Plasma: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'PT_sUSDE_28JAN2027',
            decimals: 18,
            priceFeed: '0x0000000000000000000000000000000000000000',
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'DISABLED',
            reserveFactor: '45',
            supplyCap: '150000000',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0x257561233419039BeC3a28be717d14B4f490883D',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '87.71',
            liqThreshold: '89.71',
            liqBonus: '4.87',
            label: 'sUSDe_PT_sUSDe_28JAN2027__Stablecoins',
            isolated: 'ENABLED',
            collateralAssets: ['sUSDe', 'PT_sUSDE_28JAN2027'],
            borrowableAssets: ['USDT0', 'USDe', 'GHO'],
          },
          {
            ltv: '90.35',
            liqThreshold: '92.35',
            liqBonus: '1.87',
            label: 'sUSDe_PT_sUSDe_28JAN2027__USDe',
            isolated: 'ENABLED',
            collateralAssets: ['sUSDe', 'PT_sUSDE_28JAN2027'],
            borrowableAssets: ['USDe'],
          },
        ],
      },
      cache: {blockNumber: 35734145},
    },
  },
};
