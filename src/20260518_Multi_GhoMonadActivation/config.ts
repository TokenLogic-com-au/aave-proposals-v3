import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: [
      'AaveV3Ethereum',
      'AaveV3Avalanche',
      'AaveV3Arbitrum',
      'AaveV3Base',
      'AaveV3Gnosis',
      'AaveV3Plasma',
      'AaveV3Mantle',
      'AaveV3InkWhitelabel',
      'AaveV3XLayer',
      'AaveV3Monad',
    ],
    title: 'Gho Monad Activation',
    shortName: 'GhoMonadActivation',
    date: '20260518',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/arfc-deploy-aave-protocol-on-monad/24943',
    snapshot:
      'https://snapshot.box/#/s:aavedao.eth/proposal/0x24f105bd023c476a9b85fa87ff795bfeec769fa799ce6ada8e2724c9738049f6',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Ethereum: {configs: {OTHERS: {}}, cache: {blockNumber: 25343705}},
    AaveV3Avalanche: {configs: {OTHERS: {}}, cache: {blockNumber: 88288750}},
    AaveV3Arbitrum: {configs: {OTHERS: {}}, cache: {blockNumber: 474743240}},
    AaveV3Base: {configs: {OTHERS: {}}, cache: {blockNumber: 47493780}},
    AaveV3Gnosis: {configs: {OTHERS: {}}, cache: {blockNumber: 46758170}},
    AaveV3Plasma: {configs: {OTHERS: {}}, cache: {blockNumber: 24837240}},
    AaveV3Mantle: {configs: {OTHERS: {}}, cache: {blockNumber: 96823390}},
    AaveV3InkWhitelabel: {configs: {OTHERS: {}}, cache: {blockNumber: 48278619}},
    AaveV3XLayer: {configs: {OTHERS: {}}, cache: {blockNumber: 63008130}},
    AaveV3Monad: {configs: {OTHERS: {}}, cache: {blockNumber: 82069090}},
  },
};
