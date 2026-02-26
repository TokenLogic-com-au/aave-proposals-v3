import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: 'Reduce Safety Module Emissions',
    shortName: 'ReduceSafetyModuleEmissions',
    date: '20260224',
    author: '@TokenLogic',
    discussion: 'https://',
    snapshot: 'https;//',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 24528301}}},
};
