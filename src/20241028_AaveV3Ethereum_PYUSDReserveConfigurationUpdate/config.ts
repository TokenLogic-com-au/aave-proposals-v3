import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum'],
    title: 'PYUSD Reserve Configuration Update',
    shortName: 'PYUSDReserveConfigurationUpdate',
    date: '20241028',
    author: 'karpatkey_TokenLogic',
    discussion:
      'https://governance.aave.com/t/arfc-pyusd-reserve-configuration-update-incentive-campaign/19573',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Ethereum: {
      configs: {
        CAPS_UPDATE: [{asset: 'PYUSD', supplyCap: '', borrowCap: '15000000'}],
        COLLATERALS_UPDATE: [
          {
            asset: 'PYUSD',
            ltv: '75',
            liqThreshold: '78',
            liqBonus: '7.5',
            debtCeiling: '',
            liqProtocolFee: '10',
          },
        ],
        EMODES_ASSETS: [
          {
            asset: 'PYUSD',
            eModeCategory: 'AaveV3EthereumEModes.ETH_CORRELATED',
            collateral: 'ENABLED',
            borrowable: 'ENABLED',
          },
        ],
      },
      cache: {blockNumber: 21064864},
    },
  },
};
