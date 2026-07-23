import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    markets: ['AaveV3EthereumLido'],
    title: 'Enable wstETH Borrowing on Prime',
    shortName: 'EnableWstETHBorrowingOnPrime',
    date: '20260720',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/direct-to-aip-aave-v3-ltv-and-e-mode-update/25067',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3EthereumLido: {
      configs: {
        BORROWS_UPDATE: [
          {
            enabledToBorrow: 'ENABLED',
            flashloanable: 'KEEP_CURRENT',
            reserveFactor: '',
            asset: 'wstETH',
          },
        ],
      },
      cache: {blockNumber: 25576654},
    },
  },
};
