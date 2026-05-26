import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: [
      'AaveV3Ethereum',
      'AaveV3Arbitrum',
      'AaveV3Avalanche',
      'AaveV3Base',
      'AaveV3Gnosis',
      'AaveV3Mantle',
      'AaveV3Plasma',
      'AaveV3XLayer',
    ],
    title: 'Remote GSM Launch: Arbitrum',
    shortName: 'RemoteGSMLaunchArbitrum',
    date: '20260512',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {}, cache: {blockNumber: 25080900}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 462142700}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 84734234}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 45637639}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 45935000}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 95179108}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 21132780}},
    AaveV3XLayer: {configs: {OTHERS: {}}, cache: {blockNumber: 0}},
  },
};
