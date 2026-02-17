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
    ],
    title: 'Gho X-Layer Activation',
    shortName: 'GhoXLayerActivation',
    date: '20260203',
    author: '@TokenLogic',
    discussion: '',
    snapshot: '',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 24377337}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 77188767}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 428237798}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 41672262}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 44492319}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 13202118}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 91006170}},
  },
};
