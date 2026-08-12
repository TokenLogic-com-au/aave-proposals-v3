---
title: "Aave V3 Mantle – mETH Listing"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/arfc-onboard-mnt-meth-cmeth-as-collateral-assets-on-aave-v3-mantle-instance/21772"
---

## Simple Summary

This AIP lists mETH (Mantle Staked ETH) on Aave V3 Mantle as a non-borrowable asset, usable as collateral exclusively within a dedicated mETH/WETH correlated eMode.

## Motivation

mETH is Mantle's native liquid staking token and one of the deepest assets on the network. Listing it as eMode-only collateral against WETH enables staked-ETH looping strategies on Aave's Mantle instance, mirroring the treatment of wrsETH.

This listing revisits the original onboarding ARFC, where Chaos Labs declined mETH pending improvements to its pricing infrastructure and on-chain liquidity. Both conditions have since progressed: Chainlink's mETH/ETH exchange rate feed is live on Mantle (July 2026), and market-making liquidity is being deployed. Updated risk parameters from the risk providers are expected before this proposal is submitted on-chain.

## Specification

**mETH listing (PROVISIONAL):**

| Parameter         | Value           |
| ----------------- | --------------- |
| Borrowable        | No              |
| Collateral (core) | No (eMode only) |
| Supply Cap        | 5,000 mETH      |
| Reserve Factor    | 20%             |

**New eMode (PROVISIONAL)** (borrowable: WETH):

| eMode           | Collateral | LTV | LT  | Liq. Bonus |
| --------------- | ---------- | --- | --- | ---------- |
| mETH Correlated | mETH       | 93% | 95% | 1%         |

## References

- Implementation: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260806_AaveV3Mantle_AaveV3MantleMETHListing/AaveV3Mantle_AaveV3MantleMETHListing_20260806.sol)
- Tests: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260806_AaveV3Mantle_AaveV3MantleMETHListing/AaveV3Mantle_AaveV3MantleMETHListing_20260806.t.sol)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
