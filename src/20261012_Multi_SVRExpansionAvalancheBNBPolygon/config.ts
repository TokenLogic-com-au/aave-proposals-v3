import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    markets: ['AaveV3Polygon', 'AaveV3Avalanche', 'AaveV3BNB'],
    title: 'SVR Expansion (Avalanche, BNB, Polygon)',
    shortName: 'SVRExpansionAvalancheBNBPolygon',
    date: '20261012',
    author: 'TokenLogic',
    discussion:
      'https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Polygon: {configs: {OTHERS: {}}, cache: {blockNumber: 95412356}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 97376552}},
    AaveV3BNB: {configs: {OTHERS: {}}, cache: {blockNumber: 127245802}},
  },
};
