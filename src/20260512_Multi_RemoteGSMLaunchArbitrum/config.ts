import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Arbitrum'],
    title: 'Remote GSM Launch: Arbitrum',
    shortName: 'RemoteGSMLaunchArbitrum',
    date: '20260512',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240',
    snapshot: 'TODO',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {}, cache: {blockNumber: 25080976}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 462142794}},
  },
};
