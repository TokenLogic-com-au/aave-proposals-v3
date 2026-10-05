---
title: "Onboard PT-ASSET-DDMMMYYYY to Aave V3 Monad"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/<slug>/<id>"
---

## Simple Summary

This AIP lists PT-ASSET-DDMMMYYYY, the Pendle Principal Token for <UNDERLYING> maturing on <DD Month YYYY>, on the Aave V3 Monad instance as a non-borrowable asset, usable as collateral exclusively within a dedicated PT-ASSET-DDMMMYYYY/stablecoin eMode.

## Motivation

PT-ASSET-<PREVIOUS-MATURITY> matures on <DD Month YYYY>. This AIP lists the next maturity, PT-ASSET-DDMMMYYYY, with the launch parameters recommended by LlamaRisk, so that users can roll fixed-yield <UNDERLYING> positions used as collateral against stablecoin debt into the new maturity. PT-ASSET-<PREVIOUS-MATURITY> remains listed through its maturity, unchanged.

The PT is priced by a new linear discount oracle for the <DD Month YYYY> maturity (`<oracle description>`), with `initialDiscountRatePerYear` <x.xxx>% and `maxDiscountRatePerYear` <x.xxx>%.

## Specification

| Field                     | Value                                                                                                                  |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Asset                     | PT-ASSET-DDMMMYYYY                                                                                                     |
| PT token                  | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |
| Pendle market             | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |
| SY token                  | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |
| YT token                  | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |
| Underlying (<UNDERLYING>) | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |
| Maturity                  | <DD Month YYYY>                                                                                                        |

**New eMode**:

| eMode                             | Collateral         | Borrowable                   | LTV | LT  | Liq. Bonus | Isolated |
| --------------------------------- | ------------------ | ---------------------------- | --- | --- | ---------- | -------- |
| PT_ASSET_DDMMMYYYY\_\_Stablecoins | PT-ASSET-DDMMMYYYY | USDT0, USDC, GHO, USDe, mUSD | 0%  | 0%  | 0%         | No       |

The table below illustrates the configured risk parameters for **PT_ASSET_DDMMMYYYY**

| Parameter                 |                                                                                                     PT-ASSET-DDMMMYYYY |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------: |
| Isolation Mode            |                                                                                                                     No |
| Borrowable                |                                                                                                                     No |
| Collateral Enabled        |                                                                                                       No (E-Mode only) |
| Supply Cap                |                                                                                                                      0 |
| Borrow Cap                |                                                                                                                      1 |
| Debt Ceiling              |                                                                                                                    N/A |
| LTV                       |                                                                                                                     0% |
| Liquidation Threshold     |                                                                                                                     0% |
| Liquidation Bonus         |                                                                                                                     0% |
| Liquidation Protocol Fee  |                                                                                                                    10% |
| Reserve Factor            |                                                                                                                    20% |
| Base Variable Borrow Rate |                                                                                                                     0% |
| Variable Rate Slope 1     |                                                                                                                    10% |
| Variable Rate Slope 2     |                                                                                                                   300% |
| Optimal Utilization       |                                                                                                                    45% |
| Flashloanable             |                                                                                                                    Yes |
| Oracle                    | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |

**Linear Discount Rate Oracle**

| Parameter                  | Value                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| initialDiscountRatePerYear | <x.xxx>%                                                                                                               |
| maxDiscountRatePerYear     | <x.xxx>%                                                                                                               |
| Oracle                     | [0x0000000000000000000000000000000000000000](https://monadscan.com/address/0x0000000000000000000000000000000000000000) |

## References

- Implementation: [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/<commit>/src/YYYYMMDD_AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad/AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD.sol)
- Tests: [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/<commit>/src/YYYYMMDD_AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad/AaveV3Monad_AssetListingPendlePTASSETDDMMMYYYYMonad_YYYYMMDD.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/<slug>/<id>)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
