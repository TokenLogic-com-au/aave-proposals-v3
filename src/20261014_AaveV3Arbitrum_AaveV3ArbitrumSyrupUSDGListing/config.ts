import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20261014_AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing/config.ts',
    markets: ['AaveV3Arbitrum'],
    title: 'Onboard syrupUSDG to Aave V3 Arbitrum',
    shortName: 'AaveV3ArbitrumSyrupUSDGListing',
    date: '20261014',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-arbitrum/25851',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Arbitrum: {
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
            supplyCap: '10000000',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0xE1B0dC5A21b10f1634fBfbE9976fBA2Ee2e1c762',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '90',
            liqThreshold: '92',
            liqBonus: '4',
            label: 'syrupUSDG__USDCn_USDT_GHO_USDG',
            isolated: 'DISABLED',
            collateralAssets: ['syrupUSDG'],
            borrowableAssets: ['USDCn', 'USDT', 'GHO', 'USDG'],
          },
        ],
      },
      cache: {blockNumber: 514767348},
    },
  },
};
