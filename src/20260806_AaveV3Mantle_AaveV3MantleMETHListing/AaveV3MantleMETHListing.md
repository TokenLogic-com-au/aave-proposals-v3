---
title: "Aave V3 Mantle – mETH Listing"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/arfc-onboard-mnt-meth-cmeth-as-collateral-assets-on-aave-v3-mantle-instance/21772"
---

## Simple Summary

This AIP lists mETH (Mantle Staked ETH) on Aave V3 Mantle as a non-borrowable asset, usable as collateral exclusively within a dedicated mETH/WETH correlated eMode.

## Motivation

mETH is Mantle's native liquid staking token and one of the deepest assets on the network. Listing it as eMode-only collateral against WETH enables staked-ETH looping strategies on Aave's Mantle instance, mirroring the treatment of wrsETH.

This listing revisits the original onboarding ARFC, where it was requested that mETH improve its pricing infrastructure and on-chain liquidity before listing. Both conditions have since progressed: Chainlink's mETH/ETH exchange rate feed is live on Mantle (July 2026), and market-making liquidity is being deployed. Updated risk parameters from the risk providers are expected before this proposal is submitted on-chain.

## Specification

**mETH listing (PROVISIONAL):**

| Parameter                 |                                       mETH |
| ------------------------- | -----------------------------------------: |
| Isolation Mode            |                                         No |
| Borrowable                |                                         No |
| Collateral Enabled        |                           No (E-Mode only) |
| Supply Cap                |                                      5,000 |
| Borrow Cap                |                                          1 |
| Debt Ceiling              |                                        N/A |
| LTV                       |                                         0% |
| Liquidation Threshold     |                                         0% |
| Liquidation Bonus         |                                         0% |
| Liquidation Protocol Fee  |                                        10% |
| Reserve Factor            |                                        20% |
| Base Variable Borrow Rate |                                         0% |
| Variable Rate Slope 1     |                                        10% |
| Variable Rate Slope 2     |                                       300% |
| Optimal Utilization       |                                        45% |
| Flashloanable             |                                        Yes |
| Oracle                    | Placeholder — pending mETH/ETH/USD adapter |

**New eMode (PROVISIONAL):**

| eMode           | Collateral | Borrowable | LTV | LT  | Liq. Bonus |
| --------------- | ---------- | ---------- | --- | --- | ---------- |
| mETH Correlated | mETH       | WETH       | 93% | 95% | 1%         |

## References

- Implementation: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260806_AaveV3Mantle_AaveV3MantleMETHListing/AaveV3Mantle_AaveV3MantleMETHListing_20260806.sol)
- Tests: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260806_AaveV3Mantle_AaveV3MantleMETHListing/AaveV3Mantle_AaveV3MantleMETHListing_20260806.t.sol)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
