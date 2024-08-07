import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    author: 'BGD Labs @bgdlabs',
    pools: [
      'AaveV3Ethereum',
      'AaveV3Polygon',
      'AaveV3Avalanche',
      'AaveV3Optimism',
      'AaveV3Arbitrum',
      'AaveV3Metis',
      'AaveV3Base',
      'AaveV3Gnosis',
      'AaveV3Scroll',
      'AaveV3BNB',
    ],
    title: 'ADI Shuffle Update',
    shortName: 'ADIShuffleUpdate',
    date: '20240709',
    discussion: 'https://governance.aave.com/t/bgd-a-di-aave-delivery-infrastructure-v1-1/17838',
    snapshot: '',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 20269340}},
    AaveV3Polygon: {configs: {OTHERS: {}}, cache: {blockNumber: 59151167}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 47751817}},
    AaveV3Optimism: {configs: {OTHERS: {}}, cache: {blockNumber: 122467132}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 230412382}},
    AaveV3Metis: {configs: {OTHERS: {}}, cache: {blockNumber: 17607520}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 16871856}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 34878865}},
    AaveV3Scroll: {configs: {OTHERS: {}}, cache: {blockNumber: 7276334}},
    AaveV3BNB: {configs: {OTHERS: {}}, cache: {blockNumber: 40323746}},
  },
};
