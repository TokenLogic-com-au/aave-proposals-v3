import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    markets: ['AaveV3BNB'],
    title: 'SVR Expansion (BNB)',
    shortName: 'SVRExpansionBNB',
    date: '20261012',
    author: 'TokenLogic',
    discussion:
      'https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3BNB: {configs: {OTHERS: {}}, cache: {blockNumber: 127465400}},
  },
};
