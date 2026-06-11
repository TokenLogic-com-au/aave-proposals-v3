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
    discussion: 'https://governance.aave.com/t/arfc-launch-remotegsm-on-arbitrum/24986',
    snapshot:
      'https://snapshot.org/#/s:aavedao.eth/proposal/0xf24321514fb593af9e5082d26a1358819ec0f648db8fdb5c2b083f53ef785793',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {}, cache: {blockNumber: 25296195}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 472472428}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 84734234}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 45637639}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 45935000}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 95179108}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 21132780}},
    AaveV3XLayer: {configs: {OTHERS: {}}, cache: {blockNumber: 61831240}},
  },
};
