import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: 'Incentive Campaign',
    shortName: 'IncentiveCampaign',
    date: '20241028',
    author: 'karpatkey_TokenLogic',
    discussion:
      'https://governance.aave.com/t/arfc-pyusd-reserve-configuration-update-incentive-campaign/19573',
    snapshot: 'TBA',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 21065936}}},
};
