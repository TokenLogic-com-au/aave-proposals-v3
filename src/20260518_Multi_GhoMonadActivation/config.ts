import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: [
      'AaveV3Ethereum',
      'AaveV3Avalanche',
      'AaveV3Arbitrum',
      'AaveV3Base',
      'AaveV3Gnosis',
      'AaveV3Plasma',
      'AaveV3Mantle',
      'AaveV3InkWhitelabel',
      'AaveV3XLayer',
    ],
    title: 'Gho Monad Activation',
    shortName: 'GhoMonadActivation',
    date: '20260203',
    author: '@TokenLogic',
    discussion: 'TODO',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  // TODO: block numbers
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3InkWhitelabel: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
    AaveV3XLayer: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
  },
};
