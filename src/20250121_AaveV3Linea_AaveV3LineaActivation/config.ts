import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    pools: ['AaveV3Linea'],
    title: 'Aave v3 Linea Activation',
    shortName: 'AaveV3LineaActivation',
    date: '20250121',
    author: 'BGD Labs (@bgdlabs)',
    discussion: 'https://governance.aave.com/t/arfc-deployment-of-aave-on-linea/19852/6',
    snapshot:
      'https://snapshot.org/#/s:aave.eth/proposal/0x5ae276cb67c8d40868916e99f2ef113de02049dd412c3eb47539f97648f50878',
    votingNetwork: 'POLYGON',
  },
  poolOptions: {
    AaveV3Linea: {
      configs: {
        EMODES_UPDATES: [
          {
            eModeCategory: 1,
            ltv: '90',
            liqThreshold: '93',
            liqBonus: '1',
            label: 'LRT LST correlated',
          },
          {
            eModeCategory: 2,
            ltv: '93.5',
            liqThreshold: '95.5',
            liqBonus: '1',
            label: 'wstETH correlated',
          },
        ],
        ASSET_LISTING: [
          {
            assetSymbol: 'WETH',
            decimals: 18,
            priceFeed: '0x3c6Cd9Cc7c7a4c2Cf5a82734CD249D7D593354dA',
            ltv: '80',
            liqThreshold: '83',
            liqBonus: '6',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'ENABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'DISABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '15',
            supplyCap: '1200',
            borrowCap: '1100',
            rateStrategyParams: {
              optimalUtilizationRate: '90',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '2.7',
              variableRateSlope2: '80',
            },
            asset: '0xe5d7c2a44ffddf6b295a15c148167daaaf5cf34f',
            admin: '',
          },
          {
            assetSymbol: 'WBTC',
            decimals: 8,
            priceFeed: '0x7A99092816C8BD5ec8ba229e3a6E6Da1E628E1F9',
            ltv: '73',
            liqThreshold: '78',
            liqBonus: '7',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'ENABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'DISABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '20',
            supplyCap: '25',
            borrowCap: '12',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '7',
              variableRateSlope2: '300',
            },
            asset: '0x3aAB2285ddcDdaD8edf438C1bAB47e1a9D05a9b4',
            admin: '',
          },
          {
            assetSymbol: 'USDC',
            decimals: 6,
            priceFeed: '0x14ac9f8a8646D11D66fbaA9E9F5A869dC08B5D71',
            ltv: '75',
            liqThreshold: '78',
            liqBonus: '5',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'ENABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'ENABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '10',
            supplyCap: '12000000',
            borrowCap: '11000000',
            rateStrategyParams: {
              optimalUtilizationRate: '90',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '5.5',
              variableRateSlope2: '60',
            },
            asset: '0x176211869ca2b568f2a7d4ee941e073a821ee1ff',
            admin: '',
          },
          {
            assetSymbol: 'USDT',
            decimals: 6,
            priceFeed: '0x0DccbA847D677d4dc3c22C9Dc17DC468226d08Ed',
            ltv: '75',
            liqThreshold: '78',
            liqBonus: '5',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'ENABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'ENABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '10',
            supplyCap: '7800000',
            borrowCap: '7150000',
            rateStrategyParams: {
              optimalUtilizationRate: '90',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '5.5',
              variableRateSlope2: '60',
            },
            asset: '0xA219439258ca9da29E9Cc4cE5596924745e12B93',
            admin: '',
          },
          {
            assetSymbol: 'wstETH',
            decimals: 18,
            priceFeed: '0x96014CA32e2902A5F07c6ADF00eB17D3DE9aC364',
            ltv: '75',
            liqThreshold: '79',
            liqBonus: '7',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'ENABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'DISABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '5',
            supplyCap: '800',
            borrowCap: '400',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '7',
              variableRateSlope2: '300',
            },
            asset: '0xb5bedd42000b71fdde22d3ee8a79bd49a568fc8f',
            admin: '',
          },
          {
            assetSymbol: 'ezETH',
            decimals: 18,
            priceFeed: '0x1217a8A40cea4dB5429fbF6EDeB3B606b99CC9b0',
            ltv: '72',
            liqThreshold: '75',
            liqBonus: '7.5',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'DISABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '45',
            supplyCap: '1200',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '7',
              variableRateSlope2: '300',
            },
            asset: '0x2416092f143378750bb29b79ed961ab195cceea5',
            admin: '',
          },
          {
            assetSymbol: 'weETH',
            decimals: 18,
            priceFeed: '0x0abf2f5642d945b49B8d2DBC6f85c2D8e0424C85',
            ltv: '72.5',
            liqThreshold: '75',
            liqBonus: '7.5',
            debtCeiling: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'ENABLED',
            borrowableInIsolation: 'DISABLED',
            withSiloedBorrowing: 'DISABLED',
            reserveFactor: '45',
            supplyCap: '1200',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '7',
              variableRateSlope2: '300',
            },
            asset: '0x1Bf74C010E6320bab11e2e5A532b5AC15e0b8aA6',
            admin: '',
          },
        ],
      },
      cache: {blockNumber: 14852350},
    },
  },
};
