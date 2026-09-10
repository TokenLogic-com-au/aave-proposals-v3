import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20260907_AaveV3Ethereum_AugustSeptember2026FundingUpdate/config.ts',
    markets: ['AaveV3Ethereum'],
    title: 'August/September 2026 Funding Update',
    shortName: 'AugustSeptember2026FundingUpdate',
    date: '20260907',
    author: 'TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-august-september-2026-funding-update/25597',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 25927734}}},
};
