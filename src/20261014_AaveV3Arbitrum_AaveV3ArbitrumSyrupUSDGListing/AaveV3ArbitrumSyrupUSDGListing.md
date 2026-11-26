---
title: "Onboard syrupUSDG to Aave V3 Arbitrum"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-arbitrum/25851"
---

## Simple Summary

This publication proposes onboarding syrupUSDG to Aave V3 Arbitrum. It would be collateral only inside a new E-Mode for borrowing stablecoins, and it would not be collateral outside that E-Mode. Input from the Risk and Technical Service Providers is requested.

## Motivation

### **syrupUSDG**

syrupUSDG is Maple Finance's yield-bearing USDG token. Users deposit USDG into Maple's Syrup pool on Ethereum and receive syrupUSDG. Maple lends the pooled USDG to institutional borrowers against overcollateralized loans. Interest accrues to the token's exchange rate against USDG, so the token is non-rebasing.

The token is an ERC-4626 vault on Ethereum. Chainlink CCIP bridges it to Robinhood Chain and Arbitrum: syrupUSDG is locked on Ethereum and minted on the destination chain. syrupUSDG is already deployed on Arbitrum, and it is listed as collateral on Aave V4 Ethereum, on the Maple SyrupUSDG spoke of the Global Dollar Hub.

### Supply and Adoption

Since supply started growing in late June 2026, syrupUSDG has reached 213.3M tokens across three chains:

- Robinhood Chain: 137.9M (65%)
- Ethereum: 51.5M (24%)
- Arbitrum: 24.0M (11%)

Supply has grown steadily, from about 90M in early July to over 200M by October.

Arbitrum is the newest deployment. The token contract went live on 10 Sep 2026, but bridged supply only started in early October. It then grew from under 0.5M on 5 Oct to 24.0M by 13 Oct. Most of that supply on Arbitrum is used as collateral on Morpho.

!_syrupUSDG Supply by Chain_

_syrupUSDG Supply by Chain_

### Yield Profile

syrupUSDG's yield has been stable since it began accruing on 26 Jun 2026. The trailing 30-day APY has stayed in a narrow ~4.7%–5.4% range.

!syrupusdg_apy_v3.png

Daily APY has a mean of 5.00%, a median of 5.01% and a standard deviation of 0.39pp over 97 days.

Because the yield is predictable and stable, syrupUSDG suits a stablecoin carry trade on Aave. Users can post syrupUSDG in the E-Mode and borrow stablecoins while the borrow rate stays below syrupUSDG's yield. That creates sustained borrowing demand for Arbitrum's stablecoin reserves.

### Loan Book and Collateral

The USDG Maple lends from the syrupUSDG pool goes mainly to institutional borrowers, against overcollateralized loans. Historically most of the book has been BTC-backed, now $164.4M of BTC collateral. Since mid-September Maple has also issued ETH-backed loans, now $30.6M of ETH collateral.

!syrupusdg_collateral_value_v4.png

As of 13 Oct 2026, the BTC- and ETH-backed loans total $105.2M of principal, secured by $195.6M of collateral. That is an average collateralization level of about 186%.

The pool also holds about $40M of intercompany loans. About $35M funds minting syrupUSDC and $5M funds syrupUSDT. Maple puts syrupUSDG's excess liquidity to work in its other Syrup products, so syrupUSDG holders are also indirectly exposed to syrupUSDC and syrupUSDT.

### Value Proposition

syrupUSDG's 30-day APY is ~4.9%, above the borrow rates of Arbitrum's main stablecoin markets: USDC 3.64% and USD₮0 4.31%. Users can loop that spread into a leveraged carry position. USDC is Arbitrum's deepest market, with $200.9M supplied, and gives a spread of +1pp.

This listing creates stable, sticky borrowing demand for Arbitrum's stablecoin reserves, which increases utilization. It also lets Aave capture syrupUSDG carry demand that already exists on Arbitrum.

syrupUSDG also has local liquidity on Arbitrum: a syrupUSDG/USDG Uniswap v4 pool with $1M of liquidity, created on 2 Oct 2026. That makes it easier for borrowers to enter and exit positions and for liquidators to close positions.

## Specification

**Asset Details**

| Field                        | Value                                                  |
| ---------------------------- | ------------------------------------------------------ |
| Asset                        | syrupUSDG                                              |
| Network                      | Arbitrum                                               |
| syrupUSDG Address (Arbitrum) | `0xE1B0dC5A21b10f1634fBfbE9976fBA2Ee2e1c762`           |
| Token Standard               | ERC-4626 vault on Ethereum, bridged via Chainlink CCIP |

**Proposed Market Configuration**

We propose the following initial configuration for syrupUSDG, subject to final recommendations from Aave's Risk Service Providers.

| Parameter                | Value                   |
| ------------------------ | ----------------------- |
| Asset                    | syrupUSDG               |
| Isolation Mode           | No                      |
| Borrowable               | No                      |
| Collateral Enabled       | No                      |
| Supply Cap               | 10,000,000              |
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

| Parameter             | syrupUSDG | USDC | USD₮0 | GHO | USDG\* |
| --------------------- | --------- | ---- | ----- | --- | ------ |
| Collateral            | Yes       | No   | No    | No  | No     |
| Borrowable            | No        | Yes  | Yes   | Yes | Yes    |
| Max LTV               | 90.00%    | -    | -     | -   | -      |
| Liquidation Threshold | 92.00%    | -    | -     | -   | -      |
| Liquidation Bonus     | 4.00%     | -    | -     | -   | -      |

\*_USDG would be added as a borrowable asset in this E-Mode subject to the approval and execution of the ongoing [[Direct-to-AIP] Asset Listing USDG Arbitrum](https://governance.aave.com/t/direct-to-aip-asset-listing-usdg-arbitrum/25811) proposal._

## Oracle

syrupUSDG would be priced through a Dynamic CAPO adapter. The adapter multiplies the syrupUSDG/USDG exchange rate by a capped USDG/USD price.

The adapter has two components, both based on Chainlink feeds already live on Arbitrum:

**USDG/USD price**

A Chainlink USDG/USD feed is live on Arbitrum at `0xE9Bd4Ca2CDacb56cd06c9C4C5231e69c33340B3c`. The ongoing USDG Arbitrum listing proposal prices USDG with this feed through a Capped USDG/USD adapter with a 1.04 price cap, matching other Aave instances. We propose using that adapter as the base price feed.

**syrupUSDG/USDG exchange rate**

A Chainlink syrupUSDG/USDG Exchange Rate feed is live on Arbitrum at `0x6b1aBf37cFB16deedD27D7C23168e7dF4feD8AFF`. It relays the exchange rate from the syrupUSDG vault on Ethereum.

| Parameter                   | Value                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------- |
| Oracle                      | Dynamic CAPO Adapter (TBD, pending deployment)                                        |
| Base Price Feed             | Capped USDG/USD (TBD, deployed with the USDG Arbitrum listing)                        |
| Ratio Provider              | Chainlink syrupUSDG/USDG Exchange Rate (`0x6b1aBf37cFB16deedD27D7C23168e7dF4feD8AFF`) |
| maxYearlyRatioGrowthPercent | TBD (Risk Service Provider)                                                           |
| MINIMUM_SNAPSHOT_DELAY      | TBD (Risk Service Provider)                                                           |

The CAPO parameters will be set by the Risk Service Providers. The final oracle contracts and configuration remain subject to confirmation by Aave's Risk and Technical Service Providers.

## **Next Steps**

1. Gather feedback from the community.
2. Using the Direct-to-AIP process, incorporate feedback from the Risk Service Provider and the Technical Service Provider.
3. Deposit at least $150 worth of syrupUSDG into the Aave Short Executor on Arbitrum before the market goes live, as required by Aave Governance Framework v2.
4. Escalate to the AIP Voting stage.

## References

- Implementation: [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261014_AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing/AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014.sol)
- Tests: [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261014_AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing/AaveV3Arbitrum_AaveV3ArbitrumSyrupUSDGListing_20261014.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdg-arbitrum/25851)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
