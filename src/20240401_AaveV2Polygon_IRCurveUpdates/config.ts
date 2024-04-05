import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20240401_AaveV2Polygon_IRCurveUpdates/config.ts',
    author: 'karpatkey_TokenLogic',
    title: 'Polygon v2 Borrow Rate Adjustments',
    discussion: 'https://governance.aave.com/t/arfc-polygon-v2-borrow-rate-adjustments/17252',
    snapshot: '*',
    pools: ['AaveV2Polygon'],
    shortName: 'PolygonV2IRCurvesUpdates',
    date: '20240401',
  },
  poolOptions: {
    AaveV2Polygon: {
      configs: {
        RATE_UPDATE_V2: [
          {
            asset: 'BAL',
            params: {
              optimalUtilizationRate: '20',
              baseVariableBorrowRate: '',
              variableRateSlope1: '50',
              variableRateSlope2: '1000',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'CRV',
            params: {
              optimalUtilizationRate: '10',
              baseVariableBorrowRate: '',
              variableRateSlope1: '50',
              variableRateSlope2: '1000',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'GHST',
            params: {
              optimalUtilizationRate: '10',
              baseVariableBorrowRate: '',
              variableRateSlope1: '50',
              variableRateSlope2: '1000',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'LINK',
            params: {
              optimalUtilizationRate: '10',
              baseVariableBorrowRate: '',
              variableRateSlope1: '50',
              variableRateSlope2: '1000',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'DAI',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '12.75',
              variableRateSlope2: '750',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'USDC',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '12.75',
              variableRateSlope2: '750',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'USDT',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '12.75',
              variableRateSlope2: '750',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'WBTC',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '4.75',
              variableRateSlope2: '750',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'WETH',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '4.75',
              variableRateSlope2: '750',
              stableRateSlope1: '',
              stableRateSlope2: '',
            },
          },
          {
            asset: 'WMATIC',
            params: {
              optimalUtilizationRate: '',
              baseVariableBorrowRate: '',
              variableRateSlope1: '6.75',
              variableRateSlope2: '750',
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
