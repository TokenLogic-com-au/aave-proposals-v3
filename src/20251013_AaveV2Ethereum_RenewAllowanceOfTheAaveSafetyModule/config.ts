import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV2Ethereum'],
    title: 'Renew allowance of the Aave Safety Module',
    shortName: 'RenewAllowanceOfTheAaveSafetyModule',
    date: '20251013',
    author: 'TokenLogic',
    discussion: '',
    snapshot: '',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {AaveV2Ethereum: {configs: {}, cache: {blockNumber: 23567428}}},
};
