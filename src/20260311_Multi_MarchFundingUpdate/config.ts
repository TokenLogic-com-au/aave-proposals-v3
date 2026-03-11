import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: [
      'AaveV3Ethereum',
      'AaveV3Polygon',
      'AaveV3Arbitrum',
      'AaveV3Base',
      'AaveV3InkWhitelabel',
    ],
    title: 'March Funding Update',
    shortName: 'MarchFundingUpdate',
    date: '20260311',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/direct-to-aip-march-2026-funding-update/24225',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 24636212}},
    AaveV3Polygon: {configs: {OTHERS: {}}, cache: {blockNumber: 84068021}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 440761931}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 43233365}},
    AaveV3InkWhitelabel: {configs: {OTHERS: {}}, cache: {blockNumber: 39760729}},
  },
};
