import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20240410_AaveV2Polygon_IRCurveUpdates/config.ts',
    author: 'Chaos Labs',
    title: 'Stablecoin IR Curves Updates',
    discussion: 'https://governance.aave.com/t/arfc-polygon-v2-borrow-rate-adjustments/17252',
    snapshot: '',
    pools: ['AaveV2Polygon'],
    shortName: 'PolygonV2IRCurvesUpdates',
    date: '20240401',
  },
  poolOptions: {
    AaveV2Polygon: {
      configs: {
        RATE_UPDATE_V2: [
          {
            asset: 'DAI',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '6',
              variableRateSlope2: '',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'USDT',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '6',
              variableRateSlope2: '',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'USDC',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '6',
              variableRateSlope2: '',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
        ],
      },
      cache: {blockNumber: 55472471},
    },
  },
};
