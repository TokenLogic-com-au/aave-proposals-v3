import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Polygon', 'AaveV3Arbitrum'],
    title: 'July 2025 - Funding Update',
    shortName: 'July2025FundingUpdate',
    date: '20250720',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/direct-to-aip-july-2025-funding-update/22555',
    snapshot: 'Direct-To-AIP',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 22962153}},
    AaveV3Polygon: {configs: {OTHERS: {}}, cache: {blockNumber: 74199592}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 359769675}},
  },
};
