import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Avalanche'],
    title: 'Permissioned GSM: USAT on Aave V4 Avalanche',
    shortName: 'PermissionedGSMUSATAvalanche',
    date: '20261109',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852',
    snapshot: 'TBA',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {}, cache: {blockNumber: 26378000}},
    AaveV3Avalanche: {configs: {}, cache: {blockNumber: 99859000}},
  },
};
