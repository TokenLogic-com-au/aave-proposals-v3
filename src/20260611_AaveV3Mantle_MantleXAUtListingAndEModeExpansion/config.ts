import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'src/20260611_AaveV3Mantle_MantleXAUtListingAndEModeExpansion/config.ts',
    force: true,
    pools: ['AaveV3Mantle'],
    title: 'Aave V3 Mantle – XAUt Listing, WMNT/WETH eMode Expansion and Isolation Removal',
    shortName: 'MantleXAUtListingAndEModeExpansion',
    date: '20260611',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-aave-v3-mantle-collateral-enablement-emode-expansion-and-isolation-updates-usdt0-usde-eth-xaut/24153',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  poolOptions: {
    AaveV3Mantle: {
      configs: {
        COLLATERALS_UPDATE: [
          {
            asset: 'WETH',
            ltv: '78',
            liqThreshold: '80',
            liqBonus: '5.5',
            debtCeiling: '0',
            liqProtocolFee: '10',
          },
          {
            asset: 'WMNT',
            ltv: '0',
            liqThreshold: '45',
            liqBonus: '10',
            debtCeiling: '0',
            liqProtocolFee: '10',
          },
        ],
        ASSET_LISTING_CUSTOM: [
          {
            base: {
              assetSymbol: 'XAUt',
              decimals: 6,
              priceFeed: '0x0000000000000000000000000000000000000001',
              ltv: '0',
              liqThreshold: '0',
              liqBonus: '0',
              debtCeiling: '0',
              liqProtocolFee: '10',
              enabledToBorrow: 'DISABLED',
              flashloanable: 'ENABLED',
              borrowableInIsolation: 'DISABLED',
              withSiloedBorrowing: 'DISABLED',
              reserveFactor: '20',
              supplyCap: '4000',
              borrowCap: '1',
              rateStrategyParams: {
                optimalUtilizationRate: '45',
                baseVariableBorrowRate: '0',
                variableRateSlope1: '10',
                variableRateSlope2: '300',
              },
              asset: '0x6199ccd9273a1e0e41e2cc18d9dacd1e9382f58e',
              admin: '',
            },
            implementations: {
              aToken: '0xD7ab0676222c0235e09a06640c422bf97CCC2Bc5',
              vToken: '0x604174a3bA9228F3c7823d2E1aAA17A90E06C160',
              sToken: '0xD7ab0676222c0235e09a06640c422bf97CCC2Bc5',
            },
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '70',
            liqThreshold: '75',
            liqBonus: '6',
            label: 'XAUt Stablecoins',
            collateralAssets: ['XAUt'],
            borrowableAssets: ['USDT0', 'USDC', 'GHO'],
          },
          {
            ltv: '80.5',
            liqThreshold: '83',
            liqBonus: '5.5',
            label: 'WETH Stablecoins',
            collateralAssets: ['WETH'],
            borrowableAssets: ['USDT0', 'USDC', 'GHO'],
          },
          {
            ltv: '40',
            liqThreshold: '45',
            liqBonus: '10',
            label: 'WMNT Stablecoins',
            collateralAssets: ['WMNT'],
            borrowableAssets: ['USDT0', 'USDC', 'GHO'],
          },
        ],
      },
      cache: {blockNumber: 96533222},
    },
  },
};
