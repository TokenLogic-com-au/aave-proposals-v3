import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3EthereumLido'],
    title: 'TokenLogic Service Provider Renewal',
    shortName: 'ARFCTokenLogicPhaseIIExtension',
    date: '20260526',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846',
    snapshot:
      'https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3EthereumLido: {configs: {OTHERS: {}}, cache: {blockNumber: 25177110}},
  },
};
