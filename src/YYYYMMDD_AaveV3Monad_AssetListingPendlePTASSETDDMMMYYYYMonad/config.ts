import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'cfg/<hash>.ts',
    force: true,
    markets: ['AaveV3Monad'],
    title: 'Onboard PT-ASSET-DDMMMYYYY to Aave V3 Monad',
    shortName: 'AssetListingPendlePTASSETDDMMMYYYYMonad',
    date: 'YYYYMMDD',
    author: '@TokenLogic',
    discussion: 'https://governance.aave.com/t/<slug>/<id>',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Monad: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'PT_ASSET_DDMMMYYYY',
            decimals: 6,
            priceFeed: '0x0000000000000000000000000000000000000000',
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'ENABLED',
            reserveFactor: '20',
            supplyCap: '0',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0x0000000000000000000000000000000000000000',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            label: 'PT_ASSET_DDMMMYYYY__Stablecoins',
            isolated: 'DISABLED',
            collateralAssets: ['PT_ASSET_DDMMMYYYY'],
            borrowableAssets: ['USDT0', 'USDC', 'GHO', 'USDe', 'mUSD'],
          },
        ],
      },
      cache: {blockNumber: 0},
    },
  },
};
