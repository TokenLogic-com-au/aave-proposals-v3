import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/meth-config-temp.ts',
    markets: ['AaveV3Mantle'],
    title: 'Aave V3 Mantle – mETH Listing',
    shortName: 'AaveV3MantleMETHListing',
    date: '20260806',
    author: '@TokenLogic',
    discussion: '',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Mantle: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'mETH',
            decimals: 18,
            priceFeed: '0x0000000000000000000000000000000000000001',
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'ENABLED',
            reserveFactor: '20',
            supplyCap: '5000',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0xcDA86A272531e8640cD7F1a92c01839911B90bb0',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '93',
            liqThreshold: '95',
            liqBonus: '1',
            label: 'mETH Correlated',
            isolated: 'DISABLED',
            collateralAssets: ['mETH'],
            borrowableAssets: ['WETH'],
          },
        ],
      },
      cache: {blockNumber: 98931031},
    },
  },
};
