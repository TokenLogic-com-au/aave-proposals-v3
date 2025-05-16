import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: 'May Funding Part B',
    shortName: 'MayFundingPartB',
    date: '20250516',
    author: 'TokenLogic',
    discussion: 'TODO',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 22496153}}},
};
