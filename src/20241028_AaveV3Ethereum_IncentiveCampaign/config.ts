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
    snapshot:
      'https://snapshot.org/#/aave.eth/proposal/0xcd73f17361c7757cd94ec758b4d9f160b7cecefa7f4cb23b0b4ee49b5eb1b8b2',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 21065936}}},
};
