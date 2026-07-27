---
title: "Aave V3 Mantle – XAUt Listing, WETH eMode Expansion and Isolation Removal"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-aave-v3-mantle-collateral-enablement-emode-expansion-and-isolation-updates-usdt0-usde-eth-xaut/24153"
---

## Simple Summary

This AIP lists XAUt (Tether Gold) on Aave V3 Mantle with a dedicated stablecoin eMode, and enables WETH as standard collateral with its own stablecoin eMode, completing the migration out of Isolation Mode introduced by v3.7.

## Motivation

Aave v3.7 ended support for Isolation Mode, requiring assets previously constrained by debt ceilings to transition to standard collateral configurations. Per the Chaos Labs recommendations in the discussion thread, WETH moves to standard collateral parameters with a dedicated WETH/stablecoin eMode, while its supply and borrow caps remain under Risk Steward control. The WMNT portion of the recommendations was already executed on-chain via the Aave V3 LTV and E-Mode Update AIP and is not repeated here.

XAUt is onboarded as a non-borrowable, eMode-only collateral, giving Mantle users exposure to tokenized gold as collateral against stablecoin debt. Per LlamaRisk, the asset launch is contingent on the Mantle team deploying the committed $5M of XAUt seed liquidity.

## Specification

**XAUt listing** (custom aToken/vToken implementations, priced via the Chainlink XAU/USD feed):

| Parameter         | Value           |
| ----------------- | --------------- |
| Borrowable        | No              |
| Collateral (core) | No (eMode only) |
| Supply Cap        | 4,000 XAUt      |
| Reserve Factor    | 20%             |

**Collateral update:**

| Asset | LTV | LT  | Liq. Bonus |
| ----- | --- | --- | ---------- |
| WETH  | 78% | 80% | 5.5%       |

**New eModes** (borrowables: USDT0, USDC, GHO):

| eMode            | Collateral | LTV   | LT  | Liq. Bonus |
| ---------------- | ---------- | ----- | --- | ---------- |
| XAUt Stablecoins | XAUt       | 70%   | 75% | 6%         |
| WETH Stablecoins | WETH       | 80.5% | 83% | 5.5%       |

WETH supply and borrow caps are not modified; they remain managed by the Risk Steward.

## References

- Implementation: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260611_AaveV3Mantle_MantleXAUtListingAndEModeExpansion/AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611.sol)
- Tests: [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260611_AaveV3Mantle_MantleXAUtListingAndEModeExpansion/AaveV3Mantle_MantleXAUtListingAndEModeExpansion_20260611.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-aave-v3-mantle-collateral-enablement-emode-expansion-and-isolation-updates-usdt0-usde-eth-xaut/24153)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
