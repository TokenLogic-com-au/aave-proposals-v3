import {ConfigFile} from '../../generator/types';
export const config: ConfigFile = {
  rootOptions: {
    configFile: 'cfg/b7e32fdb.ts',
    force: true,
    markets: ['AaveV3Monad'],
    title: 'Onboard PT-AUSD-17DEC2026 to Aave V3 Monad',
    shortName: 'AssetListingPendlePTAUSD17DEC2026Monad',
    date: '20260929',
    author: '@TokenLogic',
    discussion:
      'https://governance.aave.com/t/direct-to-aip-onboard-pt-ausd-17dec2026-to-aave-v3-monad-instance/25701',
    snapshot: 'Direct-to-AIP',
    votingNetwork: 'AVALANCHE',
  },
  marketOptions: {
    AaveV3Monad: {
      configs: {
        ASSET_LISTING: [
          {
            assetSymbol: 'PT_AUSD_17DEC2026',
            decimals: 6,
            priceFeed: '0x608250bbc11eeaeD31794f976946399eB49bd57c',
            ltv: '0',
            liqThreshold: '0',
            liqBonus: '0',
            liqProtocolFee: '10',
            enabledToBorrow: 'DISABLED',
            flashloanable: 'ENABLED',
            reserveFactor: '20',
            supplyCap: '20000000',
            borrowCap: '1',
            rateStrategyParams: {
              optimalUtilizationRate: '45',
              baseVariableBorrowRate: '0',
              variableRateSlope1: '10',
              variableRateSlope2: '300',
            },
            asset: '0x8b562578b2f9aa8c14ccda3c5d6cbcead3b06a57',
            admin: '',
          },
        ],
        EMODES_CREATION: [
          {
            ltv: '93',
            liqThreshold: '95',
            liqBonus: '2.44',
            label: 'PT_AUSD_17DEC2026__Stablecoins',
            isolated: 'ENABLED',
            collateralAssets: ['PT_AUSD_17DEC2026'],
            borrowableAssets: ['USDT0', 'USDC', 'GHO', 'USDe'],
          },
        ],
      },
      cache: {blockNumber: 109055778},
    },
  },
};
