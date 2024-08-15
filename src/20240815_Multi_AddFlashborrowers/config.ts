import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3Optimism', 'AaveV3Arbitrum'],
    title: 'Add Flashborrowers',
    shortName: 'AddFlashborrowers',
    date: '20240815',
    author: 'Karpatkey_Tokenlogic',
    discussion: '',
    snapshot: '',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Ethereum: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82C4371fFa43fAEA660C917B'}},
      cache: {blockNumber: 20535321},
    },
    AaveV3Optimism: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82C4371fFa43fAEA660C917B'}},
      cache: {blockNumber: 124070855},
    },
    AaveV3Arbitrum: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82C4371fFa43fAEA660C917B'}},
      cache: {blockNumber: 243183370},
    },
  },
};
