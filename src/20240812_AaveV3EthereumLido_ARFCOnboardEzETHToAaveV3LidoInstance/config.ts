import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3EthereumLido'],
    title: '[ARFC] Onboard ezETH to Aave V3 Lido Instance',
    shortName: 'ARFCOnboardEzETHToAaveV3LidoInstance',
    date: '20240812',
    author: 'Karpatkey_Tokenlogic',
    discussion: 'https://governance.aave.com/t/arfc-onboard-ezeth-to-aave-v3-lido-instance/18504',
    snapshot:
      'https://snapshot.org/#/aave.eth/proposal/0x7ef22a28cb6729ea4a978b02332ff1af8ed924a726915f9a6debf835d8bf8048',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {AaveV3EthereumLido: {configs: {}, cache: {blockNumber: 20514403}}},
};
