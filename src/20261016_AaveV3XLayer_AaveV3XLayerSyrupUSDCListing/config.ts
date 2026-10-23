import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20261016_AaveV3XLayer_AaveV3XLayerSyrupUSDCListing/config.ts',
    markets: ['AaveV3XLayer'],
    title: 'Onboard syrupUSDC to Aave V3 X Layer',
    shortName: 'AaveV3XLayerSyrupUSDCListing',
    date: '20261016',
    author: '@TokenLogic',
    discussion: '',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3XLayer: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'syrupUSDC',
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
            label: 'syrupUSDC__Stablecoins',
            isolated: 'DISABLED',
            collateralAssets: ['syrupUSDC'],
            borrowableAssets: ['USDT', 'USDG', 'USDC', 'GHO'],
          },
        ],
      },
      cache: {blockNumber: 73147962},
    },
  },
};
