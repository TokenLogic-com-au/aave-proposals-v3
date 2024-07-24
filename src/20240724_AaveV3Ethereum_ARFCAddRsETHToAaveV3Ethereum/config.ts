import {ConfigFile, VOTING_NETWORK} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: '[ARFC] Add rsETH to Aave V3 Ethereum',
    shortName: 'ARFCAddRsETHToAaveV3Ethereum',
    date: '20240724',
    author: 'Karpatkey_Tokenlogic',
    discussion: 'https://governance.aave.com/t/arfc-add-rseth-to-aave-v3-ethereum/17696',
    snapshot: '',
    votingNetwork: VOTING_NETWORK.POLYGON,
  },
  poolOptions: {AaveV3Ethereum: {configs: {}, cache: {blockNumber: 20377074}}},
};
