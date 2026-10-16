import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20261014_AaveV3XLayer_AaveV3XLayerSyrupUSDGListing/config.ts',
    markets: ['AaveV3XLayer'],
    title: 'Onboard syrupUSDG to Aave V3 X Layer',
    shortName: 'AaveV3XLayerSyrupUSDGListing',
    date: '20261014',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-x-layer/25855',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3XLayer: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'syrupUSDG',
            decimals: 6,
            priceFeed: '0x0000000000000000000000000000000000000000',
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'DISABLED',
            reserveFactor: '20',
            supplyCap: '20000000',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0x0000000000000000000000000000000000000000',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '90',
            liqThreshold: '92',
            liqBonus: '4',
            label: 'syrupUSDG__Stablecoins',
            isolated: 'DISABLED',
            collateralAssets: ['syrupUSDG'],
            borrowableAssets: ['USDT', 'USDG', 'USDC', 'GHO'],
          },
        ],
      },
      cache: {blockNumber: 73147962},
    },
  },
};
