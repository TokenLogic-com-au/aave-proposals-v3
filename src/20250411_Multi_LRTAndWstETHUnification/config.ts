import {ConfigFile, VOTING_NETWORK} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Ethereum', 'AaveV3EthereumLido', 'AaveV3Arbitrum', 'AaveV3Base'],
    title: 'LRT and wstETH Unification',
    shortName: 'LRTAndWstETHUnification',
    date: '20250411',
    author: 'TokenLogic',
    discussion: 'https://governance.aave.com/t/arfc-lrt-and-wsteth-unification/21739',
    snapshot: 'Direct-to-AIP',
    votingNetwork: VOTING_NETWORK.POLYGON,
  },
  poolOptions: {
    AaveV3Ethereum: {
      configs: {
        EMODES_UPDATES: [
          {
            eModeCategory: 8,
            ltv: '93',
            liqThreshold: '95',
            liqBonus: '1',
            label: 'rsETH/wstETH',
          },
        ],
        EMODES_ASSETS: [
          {
            asset: 'wstETH',
            eModeCategory: '8',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'rsETH',
            eModeCategory: '8',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
          {
            asset: 'wstETH',
            eModeCategory: 'AaveV3EthereumEModes.RSETH_LST_MAIN',
            collateral: 'DISABLED',
            borrowable: 'DISABLED',
          },
        ],
      },
      cache: {blockNumber: 22246960},
    },
    AaveV3EthereumLido: {
      configs: {
        COLLATERALS_UPDATE: [
          {
            asset: 'wstETH',
            ltv: '82',
            liqThreshold: '83',
            liqBonus: '',
            debtCeiling: '',
            liqProtocolFee: '',
          },
          {
            asset: 'WETH',
            ltv: '84',
            liqThreshold: '85',
            liqBonus: '',
            debtCeiling: '',
            liqProtocolFee: '',
          },
        ],
        EMODES_UPDATES: [
          {
            eModeCategory: 'AaveV3EthereumLidoEModes.ETH_CORRELATED',
            ltv: '95',
            liqThreshold: '96.5',
            liqBonus: '1',
            label: 'wstETH/WETH',
          },
          {
            eModeCategory: '6',
            ltv: '72',
            liqThreshold: '75',
            liqBonus: '7.5',
            label: 'rsETH/Stablecoins',
          },
        ],
        EMODES_ASSETS: [
          {
            asset: 'USDS',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'USDC',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'GHO',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'rsETH',
            eModeCategory: '6',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
        ],
      },
      cache: {blockNumber: 22246966},
    },
    AaveV3Arbitrum: {
      configs: {
        COLLATERALS_UPDATE: [
          {
            asset: 'weETH',
            ltv: '75',
            liqThreshold: '77',
            liqBonus: '',
            debtCeiling: '',
            liqProtocolFee: '',
          },
        ],
        EMODES_UPDATES: [
          {
            eModeCategory: 'AaveV3ArbitrumEModes.RSETH_WSTETH',
            ltv: '93',
            liqThreshold: '95',
            liqBonus: '1',
            label: '',
          },
          {
            eModeCategory: 6,
            ltv: '72',
            liqThreshold: '75',
            liqBonus: '7.5',
            label: 'rsETH/Stablecoins',
          },
        ],
        EMODES_ASSETS: [
          {
            asset: 'rsETH',
            eModeCategory: '6',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
          {
            asset: 'USDC',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'USDT',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
        ],
      },
      cache: {blockNumber: 325311301},
    },
    AaveV3Base: {
      configs: {
        COLLATERALS_UPDATE: [
          {
            asset: 'weETH',
            ltv: '75',
            liqThreshold: '77',
            liqBonus: '',
            debtCeiling: '',
            liqProtocolFee: '',
          },
        ],
        EMODES_UPDATES: [
          {
            eModeCategory: 'AaveV3BaseEModes.RSETH_WSTETH',
            ltv: '93',
            liqThreshold: '95',
            liqBonus: '1',
            label: '',
          },
          {eModeCategory: 6, ltv: '72', liqThreshold: '75', liqBonus: '7.5', label: 'rsETH/USDC'},
          {eModeCategory: 7, ltv: '93', liqThreshold: '95', liqBonus: '1.25', label: 'weETH/WETH'},
          {eModeCategory: 8, ltv: '93', liqThreshold: '95', liqBonus: '1', label: 'wstETH/WETH'},
          {eModeCategory: 9, ltv: '93', liqThreshold: '95', liqBonus: '1', label: 'cbETH/WETH'},
        ],
        EMODES_ASSETS: [
          {
            asset: 'USDC',
            eModeCategory: '6',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'rsETH',
            eModeCategory: '6',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
          {
            asset: 'WETH',
            eModeCategory: '7',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'weETH',
            eModeCategory: '7',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
          {
            asset: 'WETH',
            eModeCategory: '8',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'wstETH',
            eModeCategory: '8',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
          {
            asset: 'WETH',
            eModeCategory: '9',
            collateral: 'DISABLED',
            borrowable: 'ENABLED',
          },
          {
            asset: 'cbETH',
            eModeCategory: '9',
            collateral: 'ENABLED',
            borrowable: 'DISABLED',
          },
        ],
      },
      cache: {blockNumber: 28800501},
    },
  },
};
