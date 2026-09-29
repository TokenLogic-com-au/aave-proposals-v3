---
title: "Onboard PT-AUSD-17DEC2026 to Aave V3 Monad"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-onboard-pt-ausd-17dec2026-to-aave-v3-monad/25999"
snapshot: "Direct-to-AIP"
---

## Simple Summary

This AIP lists PT-AUSD-17DEC2026, the Pendle Principal Token for AUSD maturing on 17 December 2026, on the Aave V3 Monad instance as a non-borrowable asset, usable as collateral exclusively within a dedicated PT-AUSD-17DEC2026/stablecoin eMode.

## Motivation

PT-AUSD-8OCT2026 matures on 8 October 2026. This AIP lists the next maturity, PT-AUSD-17DEC2026, with the same launch parameters, so that users can roll fixed-yield AUSD positions used as collateral against stablecoin debt into the new maturity. PT-AUSD-8OCT2026 remains listed through its maturity, unchanged.

The PT is priced by a new linear discount oracle for the 17 December 2026 maturity (`PT Capped AUSD AUSD/USD linear discount 17DEC2026`), with `initialDiscountRatePerYear` 6.661% and `maxDiscountRatePerYear` 8.829%.

## Specification

| Field             | Value                                                                                                                  |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Asset             | PT-AUSD-17DEC2026                                                                                                      |
| PT token          | [0x8B562578b2f9Aa8C14cCda3c5d6CBCEaD3B06a57](https://monadscan.com/address/0x8B562578b2f9Aa8C14cCda3c5d6CBCEaD3B06a57) |
| Pendle market     | [0x9cbc42eff240ad2e43bbdc3c0562a9b4ce842a5a](https://monadscan.com/address/0x9cbc42eff240ad2e43bbdc3c0562a9b4ce842a5a) |
| SY token          | [0xE99f124109752f8e62B4fd5c7E3C01C1BBF58B24](https://monadscan.com/address/0xE99f124109752f8e62B4fd5c7E3C01C1BBF58B24) |
| YT token          | [0x211EDf350b927C6EAE808a63D5f6318Bac5A7e5e](https://monadscan.com/address/0x211EDf350b927C6EAE808a63D5f6318Bac5A7e5e) |
| Underlying (AUSD) | [0x00000000eFE302BEAA2b3e6e1b18d08D69a9012a](https://monadscan.com/address/0x00000000eFE302BEAA2b3e6e1b18d08D69a9012a) |
| Maturity          | 17 December 2026                                                                                                       |

**New eMode**:

| eMode                            | Collateral        | Borrowable             | LTV | LT  | Liq. Bonus | Isolated |
| -------------------------------- | ----------------- | ---------------------- | --- | --- | ---------- | -------- |
| PT_AUSD_17DEC2026\_\_Stablecoins | PT-AUSD-17DEC2026 | USDT0, USDC, GHO, USDe | 93% | 95% | 2.44%      | Yes      |

The table below illustrates the configured risk parameters for **PT_AUSD_17DEC2026**

| Parameter                 |                                                                                                      PT-AUSD-17DEC2026 |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------: |
| Isolation Mode            |                                                                                                                     No |
| Borrowable                |                                                                                                                     No |
| Collateral Enabled        |                                                                                                       No (E-Mode only) |
| Supply Cap                |                                                                                                             20,000,000 |
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
| Oracle                    | [0x608250bbc11eeaeD31794f976946399eB49bd57c](https://monadscan.com/address/0x608250bbc11eeaeD31794f976946399eB49bd57c) |

**Linear Discount Rate Oracle**

| Parameter                  | Value                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| initialDiscountRatePerYear | 6.661%                                                                                                                 |
| maxDiscountRatePerYear     | 8.829%                                                                                                                 |
| Oracle                     | [0x608250bbc11eeaeD31794f976946399eB49bd57c](https://monadscan.com/address/0x608250bbc11eeaeD31794f976946399eB49bd57c) |

## References

- Implementation: [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260929_AaveV3Monad_AssetListingPendlePTAUSD17DEC2026Monad/AaveV3Monad_AssetListingPendlePTAUSD17DEC2026Monad_20260929.sol)
- Tests: [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260929_AaveV3Monad_AssetListingPendlePTAUSD17DEC2026Monad/AaveV3Monad_AssetListingPendlePTAUSD17DEC2026Monad_20260929.t.sol)
- [Snapshot](Direct-to-AIP)
- [Discussion](https://governance.aave.com/t/direct-to-aip-onboard-pt-ausd-17dec2026-to-aave-v3-monad/25999)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
