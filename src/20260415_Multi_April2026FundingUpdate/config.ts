import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Avalanche'],
    title: 'April 2026 - Funding Update',
    shortName: 'April2026FundingUpdate',
    date: '20260415',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/direct-to-aip-april-2026-funding-update/24447',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 24887500}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 83029780}},
  },
};
