import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Arbitrum', 'AaveV3Base', 'AaveV3Sonic'],
    title: 'Deploy GHO on Sonic',
    shortName: 'DeployGHOOnSonic',
    date: '20250519',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/arfc-launch-gho-on-sonic-set-aci-as-emissions-manager-for-rewards/21282',
    snapshot:
      'https://snapshot.box/#/s:aavedao.eth/proposal/0xac45d4c364ce0306b0c487ae83215ebc1b1ebb406704ec36b9bba7aab428cdea',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 22517259}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 338322405}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 30435708}},
    AaveV3Sonic: {configs: {OTHERS: {}}, cache: {blockNumber: 28001278}},
  },
};
