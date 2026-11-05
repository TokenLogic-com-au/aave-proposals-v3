---
title: "Asset Listing - Pendle PT-sUSDe-28JAN2027 Plasma"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-onboard-pt-susde-28jan2027-to-aave-v3-plasma-instance/25902"
---

## Simple Summary

This AIP lists PT-sUSDe-28JAN2027, the Pendle Principal Token for sUSDe maturing on 28 January 2027, on the Aave V3 Plasma instance as a non-borrowable asset, and creates two new isolated eModes with sUSDe and PT-sUSDe-28JAN2027 as collateral.

## Motivation

PT-sUSDe-22OCT2026 matured on 22 October 2026. Pendle has launched PT-sUSDe-28JAN2027 as the follow-up maturity, which lets users continue using fixed-yield sUSDe positions as collateral on Aave against stablecoin debt.

PT-sUSDe-22OCT2026 remains listed with its existing parameters and eModes; this AIP does not change it.

The PT is priced via a new linear discount oracle for the 28 January 2027 maturity (`PT Capped sUSDe USDT/USD linear discount 28JAN2027`), which applies a discount that decreases to zero at maturity on top of the Capped USDT0/USD feed.

The listing parameters and eModes follow the PT-sUSDe-22OCT2026 listing.

## Specification

| Field         | Value                                                                                                                  |
| ------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Asset         | [PT-sUSDe-28JAN2027](https://plasmascan.to/address/0x257561233419039BeC3a28be717d14B4f490883D)                         |
| PT token      | [0x257561233419039BeC3a28be717d14B4f490883D](https://plasmascan.to/address/0x257561233419039BeC3a28be717d14B4f490883D) |
| Pendle market | [0xDb96B529D19FF4a7d711E6E082172c77cfe88ed8](https://plasmascan.to/address/0xDb96B529D19FF4a7d711E6E082172c77cfe88ed8) |
| SY token      | [0x9838B0450e311962Aed969BA7d0fe0BB9D8620eB](https://plasmascan.to/address/0x9838B0450e311962Aed969BA7d0fe0BB9D8620eB) |
| YT token      | [0x40Eb4A62ACf1Fa0676732B62C4E55548Ee7B819F](https://plasmascan.to/address/0x40Eb4A62ACf1Fa0676732B62C4E55548Ee7B819F) |
| Underlying    | [sUSDe](https://plasmascan.to/address/0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2)                                      |
| Maturity      | 28 January 2027                                                                                                        |

**New eModes.** The existing PT-sUSDe-22OCT2026 eModes are not modified.

| eMode                                   | Collateral                | Borrowable       | LTV    | LT     | Liq. Bonus | Isolated |
| --------------------------------------- | ------------------------- | ---------------- | ------ | ------ | ---------- | -------- |
| sUSDe_PT_sUSDe_28JAN2027\_\_Stablecoins | sUSDe, PT-sUSDe-28JAN2027 | USDT0, USDe, GHO | 87.71% | 89.71% | 4.87%      | Yes      |
| sUSDe_PT_sUSDe_28JAN2027\_\_USDe        | sUSDe, PT-sUSDe-28JAN2027 | USDe             | 90.35% | 92.35% | 1.87%      | Yes      |

The table below illustrates the configured risk parameters for **PT-sUSDe-28JAN2027**

| Parameter                 | PT-sUSDe-28JAN2027 |
| ------------------------- | -----------------: |
| Isolation Mode            |                 No |
| Borrowable                |                 No |
| Collateral Enabled        |   No (E-Mode only) |
| Supply Cap                |        150,000,000 |
| Borrow Cap                |                  1 |
| Debt Ceiling              |                N/A |
| LTV                       |                 0% |
| Liquidation Threshold     |                 0% |
| Liquidation Bonus         |                 0% |
| Liquidation Protocol Fee  |                10% |
| Reserve Factor            |                45% |
| Base Variable Borrow Rate |                 0% |
| Variable Rate Slope 1     |                10% |
| Variable Rate Slope 2     |               300% |
| Optimal Utilization       |                45% |
| Flashloanable             |                 No |
| Oracle                    | Pending deployment |

**Linear Discount Rate Oracle**

The price feed applies a linear discount, decreasing to zero at maturity, on top of the Capped USDT0/USD feed.

| Parameter                  | Value                                                                                        |
| -------------------------- | -------------------------------------------------------------------------------------------- |
| initialDiscountRatePerYear | 4.37%                                                                                        |
| maxDiscountRatePerYear     | 12.27%                                                                                       |
| Underlying feed            | [Capped USDT0/USD](https://plasmascan.to/address/0xdBbB0b5DD13E7AC9C56624834ef193df87b022c3) |
| Oracle                     | Pending deployment                                                                           |

**Seed deposit.** The Aave Short Executor is funded with 160 PT-sUSDe-28JAN2027 before execution. The payload supplies them to the Aave DustBin.

## References

- Implementation: [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma/AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022.sol)
- Tests: [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma/AaveV3Plasma_AssetListingPendlePTsUSDe28JAN2027Plasma_20261022.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-onboard-pt-susde-28jan2027-to-aave-v3-plasma-instance/25902)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
