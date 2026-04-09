import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: [
      'AaveV3Ethereum',
      'AaveV3Avalanche',
      'AaveV3Arbitrum',
      'AaveV3Base',
      'AaveV3Plasma',
      'AaveV3Mantle',
      'AaveV3XLayer',
    ],
    title: 'Increase GHO GSM Capacity on Plasma',
    shortName: 'IncreaseGHOGSMCapacityOnPlasma',
    date: '20260325',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 24838165}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 82460335}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 450489035}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 44449950}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 18757880}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 93779480}},
    AaveV3XLayer: {configs: {OTHERS: {}}, cache: {blockNumber: 56920870}},
  },
};
