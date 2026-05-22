import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: 'stkAAVE Emissions Update',
    shortName: 'StkAAVEEmissionsUpdate',
    date: '20260522',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/arfc-stkaave-emissions-update/24945',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {AaveV3Ethereum: {configs: {}, cache: {blockNumber: 25152670}}},
};
