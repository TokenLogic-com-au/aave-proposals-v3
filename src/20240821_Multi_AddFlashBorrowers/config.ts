import {ConfigFile, VOTING_NETWORK} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3EthereumLido', 'AaveV3Optimism', 'AaveV3Arbitrum'],
    title: 'Add Flash Borrowers',
    shortName: 'AddFlashBorrowers',
    date: '20240821',
    author: 'Karpatkey_Tokenlogic',
    discussion: 'https://governance.aave.com/t/arfc-add-cian-protocol-to-flashborrowers/18731',
    snapshot: 'Direct-to-AIP',
    votingNetwork: VOTING_NETWORK.POLYGON,
  },
  poolOptions: {
    AaveV3Ethereum: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82c4371ffa43faea660c917b'}},
      cache: {blockNumber: 20577727},
    },
    AaveV3EthereumLido: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82c4371ffa43faea660c917b'}},
      cache: {blockNumber: 20577737},
    },
    AaveV3Optimism: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82c4371ffa43faea660c917b'}},
      cache: {blockNumber: 124326740},
    },
    AaveV3Arbitrum: {
      configs: {FLASH_BORROWER: {address: '0x49d9409111a6363d82c4371ffa43faea660c917b'}},
      cache: {blockNumber: 245217825},
    },
  },
};
