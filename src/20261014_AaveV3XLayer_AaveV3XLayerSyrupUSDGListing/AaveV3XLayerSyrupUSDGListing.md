---
title: "Onboard syrupUSDG to Aave V3 X Layer"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-x-layer/25855"
---

## Simple Summary

This publication proposes onboarding syrupUSDG to Aave V3 X Layer. It would be collateral only inside a new E-Mode for borrowing stablecoins, and it would not be collateral outside that E-Mode. Input from the Risk and Technical Service Providers is requested.

## Motivation

### **syrupUSDG**

syrupUSDG is Maple Finance's yield-bearing USDG token. Users deposit USDG into Maple's Syrup pool on Ethereum and receive syrupUSDG. Maple lends the pooled USDG to institutional borrowers against overcollateralized loans. Interest accrues to the token's exchange rate against USDG, so the token is non-rebasing.

The token is an ERC-4626 vault on Ethereum. Chainlink CCIP bridges it to Robinhood Chain and Arbitrum: syrupUSDG is locked on Ethereum and minted on the destination chain.

syrupUSDG is already listed as collateral on Aave V4 Ethereum, on the Maple SyrupUSDG spoke of the Global Dollar Hub.

### **Supply and Adoption**

Since supply started growing in late June 2026, syrupUSDG has reached 213.3M tokens across three chains:

- Robinhood Chain: 137.9M (65%)
- Ethereum: 51.5M (24%)
- Arbitrum: 24.0M (11%)

Supply has grown steadily, from about 90M in early July to over 200M by October. Most of the growth has come from Robinhood Chain.

!_syrupUSDG Supply by Chain_

_syrupUSDG Supply by Chain_

### **Yield Profile**

syrupUSDG's yield has been stable since it began accruing on 26 Jun 2026. The trailing 30-day APY has stayed in a narrow ~4.7%–5.4% range.

!_syrupUSDG APY_

_syrupUSDG APY_

Daily APY has a mean of 5.00%, a median of 5.01% and a standard deviation of 0.39pp over 97 days.

The yield is predictable and stable, which makes syrupUSDG a good fit for a stablecoin carry trade on Aave. Users can post syrupUSDG in the E-Mode and borrow stablecoins while the borrow rate stays below syrupUSDG's yield. That creates sustained borrowing demand for X Layer's stablecoin reserves.

### Loan Book and Collateral

The USDG Maple lends from the syrupUSDG pool goes mainly to institutional borrowers, against overcollateralized loans. Historically most of the book has been BTC-backed, now $164.4M of BTC collateral. Since mid-September Maple has also issued ETH-backed loans, now $30.6M of ETH collateral.

!_syrupUSDG Collateral Value_

_syrupUSDG Collateral Value_

As of 13 Oct 2026, the BTC- and ETH-backed loans total $105.2M of principal, secured by $195.6M of collateral. That is an average collateralization level of about 186%.

The pool also holds about $40M of intercompany loans. About $35M funds minting syrupUSDC and $5M funds syrupUSDT. Maple puts syrupUSDG's excess liquidity to work in its other Syrup products, so syrupUSDG holders are also indirectly exposed to syrupUSDC and syrupUSDT.

### Value Proposition

syrupUSDG's 30-day APY is ~4.9%, so it earns more than every stablecoin borrow rate above on X Layer. Users can loop that spread into a leveraged carry position.

This listing benefits by creating stable borrowing demand that increases utilization, attracting additional stablecoin deposits through higher supply rates, and strengthening X Layer’s USDG ecosystem by complementing the existing USDG and PT-USDG markets with a non-expiring yield source that enables users to maintain a USDG carry trade without rolling over positions at maturity.

Maple has also committed to seeding $[X]M in syrupUSDG liquidity on X Layer. Local liquidity makes it easier for borrowers to enter and exit positions and enables liquidators to close positions without bridge delays, supporting the market from launch.

## Specification

**Asset Details**

| Field                       | Value                                                  |
| --------------------------- | ------------------------------------------------------ |
| Asset                       | syrupUSDG                                              |
| Network                     | X Layer                                                |
| syrupUSDG Address (X Layer) | TBD, pending deployment                                |
| Token Standard              | ERC-4626 vault on Ethereum, bridged via Chainlink CCIP |

**Proposed Market Configuration**

We propose the following initial configuration for syrupUSDG, subject to final recommendations from Aave's Risk Service Providers.

| Parameter                | Value                   |
| ------------------------ | ----------------------- |
| Asset                    | syrupUSDG               |
| Isolation Mode           | No                      |
| Borrowable               | No                      |
| Collateral Enabled       | No                      |
| Supply Cap               | 20,000,000              |
| Borrow Cap               | -                       |
| Debt Ceiling             | -                       |
| LTV                      | -                       |
| LT                       | -                       |
| Liquidation Bonus        | -                       |
| Liquidation Protocol Fee | 10%                     |
| Flashloanable            | No                      |
| Variable Base            | -                       |
| Variable Slope 1         | -                       |
| Variable Slope 2         | -                       |
| Uoptimal                 | -                       |
| Reserve Factor           | -                       |
| E Mode Category          | syrupUSDG / Stablecoins |

**E-Mode Configuration**

E-Mode: syrupUSDG / Stablecoins

| Parameter             | syrupUSDG | USD₮0 | USDG | USDC | GHO |
| --------------------- | --------- | ----- | ---- | ---- | --- |
| Collateral            | Yes       | No    | No   | No   | No  |
| Borrowable            | No        | Yes   | Yes  | Yes  | Yes |
| Max LTV               | 90.00%    | -     | -    | -    | -   |
| Liquidation Threshold | 92.00%    | -     | -    | -    | -   |
| Liquidation Bonus     | 4.00%     | -     | -    | -    | -   |

## Oracle

syrupUSDG would be priced through a Dynamic CAPO adapter. The adapter takes the syrupUSDG/USDG exchange rate and multiplies it by a capped USDG/USD price.

The adapter has two components:

**USDG/USD price**

A Chainlink USDG/USD feed is live on X Layer at `0x385C6bDDE06b0E438319bF4ddBfFe51C521ABf3D`. Aave V3 X Layer already uses it for the USDG reserve, through the Capped USDG/USD adapter `0xe00b2732396a1f047d4a00e0165025a9cf400245` with a 1.04 price cap. We propose reusing that adapter as the base price feed.

**syrupUSDG/USDG exchange rate (prerequisite)**

syrupUSDG's exchange rate lives in the ERC-4626 vault on Ethereum, so X Layer has no on-chain source for it. Before listing, Chainlink needs to provide a syrupUSDG/USDG exchange-rate feed on X Layer that reads the rate from the Ethereum vault and relays it to X Layer.

| Parameter                   | Value                                                            |
| --------------------------- | ---------------------------------------------------------------- |
| Oracle                      | Dynamic CAPO Adapter (TBD, pending deployment)                   |
| Base Price Feed             | Capped USDG/USD (`0xe00b2732396a1f047d4a00e0165025a9cf400245`)   |
| Ratio Provider              | Chainlink syrupUSDG/USDG Exchange Rate (TBD, pending deployment) |
| maxYearlyRatioGrowthPercent | TBD (Risk Service Provider)                                      |
| MINIMUM_SNAPSHOT_DELAY      | TBD (Risk Service Provider)                                      |

The CAPO parameters will be set by the Risk Service Providers. The final oracle contracts and configuration remain subject to confirmation by Aave's Risk and Technical Service Providers.

## **Next Steps**

1. Gather feedback from the community.
2. Using the Direct-to-AIP process, incorporate feedback from the Risk Service Provider and the Technical Service Provider.
3. Confirm the following are deployed on X Layer:
   - the Chainlink syrupUSDG/USDG exchange-rate feed
   - syrupUSDG liquidity seeded on a DEX
4. Deposit at least $150 worth of syrupUSDG into the Aave Short Executor on X Layer before the market goes live, as required by Aave Governance Framework v2.
5. Escalate to the AIP Voting stage.

## References

- Implementation: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261014_AaveV3XLayer_AaveV3XLayerSyrupUSDGListing/AaveV3XLayer_AaveV3XLayerSyrupUSDGListing_20261014.sol)
- Tests: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261014_AaveV3XLayer_AaveV3XLayerSyrupUSDGListing/AaveV3XLayer_AaveV3XLayerSyrupUSDGListing_20261014.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-x-layer/25855)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
