---
title: "Asset Listing - Pendle PT-USDG-25FEB2027 X Layer"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-onboard-pt-usdg-25feb2027-on-x-layer/25733"
---

## Simple Summary

This AIP lists PT-USDG-25FEB2027, the Pendle Principal Token for USDG maturing on 25 February 2027, on the Aave V3 X Layer instance as a non-borrowable asset, and adds it as collateral to the existing PT_USDG\_\_Stablecoins eMode alongside PT-USDG-29OCT2026.

## Motivation

PT-USDG-29OCT2026 matures on 29 October 2026. Pendle has launched a new USDG PT maturing on 25 February 2027, which lets users continue using fixed-yield USDG positions as collateral on Aave.

Most PT-USDG positions on X Layer borrow stablecoins such as USDT0 against their PT collateral. Keeping both maturities in the same eMode during the rollover period lets OKX build a rollover flow that moves users to the new PT in a single transaction while keeping their stablecoin borrowing position. This proposal covers the Aave listing and eMode configuration needed for that flow; OKX develops the rollover integration separately.

The listing uses the initial parameters recommended by LlamaRisk for PT-USDG-29OCT2026, including the linear discount oracle rates `initialDiscountRatePerYear` 3.106% and `maxDiscountRatePerYear` 11.080%. PT-USDG-29OCT2026 keeps its existing parameters during the migration period; its LTV will be reduced to 0% after maturity in a separate proposal.

## Specification

| Field             | Value                                                                                                                           |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Asset             | PT-USDG-25FEB2027                                                                                                               |
| PT token          | [0x5eA1F184af5Ced57725213D8267B5c4C834557D4](https://www.oklink.com/x-layer/address/0x5eA1F184af5Ced57725213D8267B5c4C834557D4) |
| Pendle market     | [0xb70BE417526707C8EBf5f1a79E4876557639B01d](https://www.oklink.com/x-layer/address/0xb70BE417526707C8EBf5f1a79E4876557639B01d) |
| SY token          | [0x1F336F899f77B084133bc14a81170837ED618D1b](https://www.oklink.com/x-layer/address/0x1F336F899f77B084133bc14a81170837ED618D1b) |
| YT token          | [0x5b4308e22aB59AAE80CBf37089C528A125d2a34d](https://www.oklink.com/x-layer/address/0x5b4308e22aB59AAE80CBf37089C528A125d2a34d) |
| Underlying (USDG) | [0x4ae46a509F6b1D9056937BA4500cb143933D2dc8](https://www.oklink.com/x-layer/address/0x4ae46a509F6b1D9056937BA4500cb143933D2dc8) |
| Maturity          | 25 February 2027                                                                                                                |

**eMode update**: PT-USDG-25FEB2027 is added as collateral to the existing PT_USDG\_\_Stablecoins eMode. The eMode parameters and the PT_USDG\_\_USDG eMode are not modified.

| eMode                  | Collateral                           | Borrowable             | LTV    | LT     | Liq. Bonus | Isolated |
| ---------------------- | ------------------------------------ | ---------------------- | ------ | ------ | ---------- | -------- |
| PT_USDG\_\_Stablecoins | PT-USDG-29OCT2026, PT-USDG-25FEB2027 | USDT0, USDG, GHO, USDC | 92.66% | 94.66% | 2.34%      | Yes      |

The table below illustrates the configured risk parameters for **PT_USDG_25FEB2027**

| Parameter                 |                                                                                                               PT-USDG-25FEB2027 |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------: |
| Isolation Mode            |                                                                                                                              No |
| Borrowable                |                                                                                                                              No |
| Collateral Enabled        |                                                                                                                No (E-Mode only) |
| Supply Cap                |                                                                                                                      35,000,000 |
| Borrow Cap                |                                                                                                                               1 |
| Debt Ceiling              |                                                                                                                             N/A |
| LTV                       |                                                                                                                              0% |
| Liquidation Threshold     |                                                                                                                              0% |
| Liquidation Bonus         |                                                                                                                              0% |
| Liquidation Protocol Fee  |                                                                                                                             10% |
| Reserve Factor            |                                                                                                                             20% |
| Base Variable Borrow Rate |                                                                                                                              0% |
| Variable Rate Slope 1     |                                                                                                                             10% |
| Variable Rate Slope 2     |                                                                                                                            300% |
| Optimal Utilization       |                                                                                                                             45% |
| Flashloanable             |                                                                                                                             Yes |
| Oracle                    | [0x6052839E52ab454F164ee5668e5B523cF5A389Fc](https://www.oklink.com/x-layer/address/0x6052839E52ab454F164ee5668e5B523cF5A389Fc) |

**Linear Discount Rate Oracle**

| Parameter                  | Value                                                                                                                           |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| initialDiscountRatePerYear | 3.106%                                                                                                                          |
| maxDiscountRatePerYear     | 11.080%                                                                                                                         |
| Oracle                     | [0x6052839E52ab454F164ee5668e5B523cF5A389Fc](https://www.oklink.com/x-layer/address/0x6052839E52ab454F164ee5668e5B523cF5A389Fc) |

## References

- Implementation: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260930_AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer/AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930.sol)
- Tests: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260930_AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer/AaveV3XLayer_AssetListingPendlePTUSDG25FEB2027XLayer_20260930.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-onboard-pt-usdg-25feb2027-on-x-layer/25733)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
