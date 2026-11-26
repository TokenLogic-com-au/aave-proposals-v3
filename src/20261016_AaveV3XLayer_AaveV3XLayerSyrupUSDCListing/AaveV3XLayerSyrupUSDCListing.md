---
title: "Onboard syrupUSDC to Aave V3 X Layer"
author: "@TokenLogic"
discussions: https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdc-x-layer/25855
---

## Simple Summary

This publication proposes onboarding syrupUSDC to Aave V3 X Layer. It would be collateral only within a new E-Mode for borrowing stablecoins, and not collateral outside that E-Mode. Input from the Risk and Technical Service Providers is requested.

## Motivation

### **syrupUSDC**

syrupUSDC is Maple Finance's yield-bearing USDC token. Users deposit USDC into Maple's Syrup pool on Ethereum and receive syrupUSDC. Maple lends the pooled USDC to institutional borrowers through overcollateralized loans. Interest accrues to the token's exchange rate against USDC.

The token is an ERC-4626 vault on Ethereum. Chainlink CCIP bridges it to Solana, Monad, Arc, Base and Arbitrum, among other chains: syrupUSDC is locked on Ethereum and minted on the destination chain.

syrupUSDC is already listed on Aave V3 Monad and Aave V3 Base, as collateral within a syrupUSDC / Stablecoins E-Mode, and on Aave V4 Arc, on the Maple SyrupUSDC spoke of the Core Hub.

### **Supply and Adoption**

As of 16 Oct 2026, syrupUSDC has 889.7M tokens outstanding (about $1.06B at the current exchange rate) across six chains.

Supply grew from about 60M in March 2025 to over 1B by October 2025, and peaked at 1.66B in March 2026. It has since settled at 0.8–0.9B. Since mid-2026, new supply has come mainly from Monad, where syrupUSDC grew from launch in May 2026 to 136.1M, and from Arc, live since September 2026.

### **Yield Profile**

syrupUSDC has accrued yield since June 2024. Over the past 12 months, its trailing 30-day APY eased from 6.8% in October 2025 to a low of 4.3% in April 2026. Since then it has stayed in a narrow ~4.4%–5.2% range, and it now stands at 5.1%.

Over the past three months, daily APY has a mean of 5.02%, a median of 4.98% and a standard deviation of 0.22pp.

The yield is predictable and stable, which makes syrupUSDC a good fit for a stablecoin carry trade on Aave. Users can post syrupUSDC in the E-Mode and borrow stablecoins while the borrow rate stays below syrupUSDC's yield. That creates sustained borrowing demand for X Layer's stablecoin reserves.

### Loan Book and Collateral

The syrupUSDC pool lends USDC to institutional borrowers through overcollateralized loans. As of 16 Oct 2026, it has $1,036M of loans outstanding:

- BTC-backed: $797.8M (20 loans)
- XRP-backed: $96.6M (2 loans)
- ETH-backed: $50.8M (3 loans)
- T-Bills (Superstate USTB and PYUSD): $71.0M
- AMM: $20.0M

These loans are backed by $1,749M of collateral, 78% of it BTC.

The BTC-, ETH- and XRP-backed loans total $945.2M of principal, secured by $1,657.8M of collateral. That is an average collateralization level of about 175%. Over half of that principal sits at a collateralization level of 190% or more; 29% ($277M) sits between 119% and 150%.

### Value Proposition

syrupUSDC's 30-day APY is ~5.1%, above the borrow rates of X Layer's main stablecoin markets. Users can loop that spread into a leveraged carry position.

This listing creates stable, sticky borrowing demand for X Layer's stablecoin reserves, which increases utilization and supply rates and attracts additional stablecoin deposits.

Maple has also committed to seeding $2M in syrupUSDC liquidity on X Layer. Local liquidity makes it easier for borrowers to enter and exit positions and enables liquidators to close positions without bridge delays, supporting the market from launch.

## Specification

**Asset Details**

| Field                       | Value                                                  |
| --------------------------- | ------------------------------------------------------ |
| Asset                       | syrupUSDC                                              |
| Network                     | X Layer                                                |
| syrupUSDC Address (X Layer) | TBD, pending deployment                                |
| Token Standard              | ERC-4626 vault on Ethereum, bridged via Chainlink CCIP |

**Proposed Market Configuration**

We propose the following initial configuration for syrupUSDC, subject to final recommendations from Aave's Risk Service Providers.

| Parameter                | Value                   |
| ------------------------ | ----------------------- |
| Asset                    | syrupUSDC               |
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
| E-Mode Category          | syrupUSDC / Stablecoins |

**E-Mode Configuration**

E-Mode: syrupUSDC / Stablecoins

| Parameter             | syrupUSDC | USD₮0 | USDG | USDC | GHO |
| --------------------- | --------- | ----- | ---- | ---- | --- |
| Collateral            | Yes       | No    | No   | No   | No  |
| Borrowable            | No        | Yes   | Yes  | Yes  | Yes |
| Max LTV               | 90.00%    | -     | -    | -    | -   |
| Liquidation Threshold | 92.00%    | -     | -    | -    | -   |
| Liquidation Bonus     | 4.00%     | -     | -    | -    | -   |

## Oracle

syrupUSDC would be priced through a Dynamic CAPO adapter. The adapter takes the syrupUSDC/USDC exchange rate and multiplies it by a capped USDC/USD price.

The adapter has two components:

**USDC/USD price**

A Chainlink USDC/USD feed is live on X Layer at `0xB8a08c178D96C315FbFB5661ABD208477391BC40`. Aave V3 X Layer already uses it for the USDC reserve, through the Capped USDC/USD adapter `0x26ad1207eaa39f74fac725599ce1c431c80ef6cc` with a 1.04 price cap. We propose reusing that adapter as the base price feed.

**syrupUSDC/USDC exchange rate**

A Chainlink syrupUSDC/USDC Exchange Rate feed is live on X Layer at `0x04c00259887Cc94764DF190c8D3663c765618204`. It relays the exchange rate from the syrupUSDC vault on Ethereum.

| Parameter                     | Value                                                                                 |
| ----------------------------- | ------------------------------------------------------------------------------------- |
| Oracle                        | Dynamic CAPO Adapter (TBD, pending deployment)                                        |
| Base Price Feed               | Capped USDC/USD (`0x26ad1207eaa39f74fac725599ce1c431c80ef6cc`)                        |
| Ratio Provider                | Chainlink syrupUSDC/USDC Exchange Rate (`0x04c00259887Cc94764DF190c8D3663c765618204`) |
| `maxYearlyRatioGrowthPercent` | TBD (Risk Service Provider)                                                           |
| `MINIMUM_SNAPSHOT_DELAY`      | TBD (Risk Service Provider)                                                           |

The CAPO parameters will be set by the Risk Service Providers. The final oracle contracts and configuration remain subject to confirmation by Aave's Risk and Technical Service Providers.

## **Next Steps**

1. Gather feedback from the community.
2. Using the Direct-to-AIP process, incorporate feedback from the Risk Service Provider and the Technical Service Provider.
3. Confirm the following are deployed on X Layer:
   - syrupUSDC, with X Layer added to the Chainlink CCIP lane
   - syrupUSDC liquidity seeded on a DEX
4. Deposit at least $150 worth of syrupUSDC into the Aave Short Executor on X Layer before the market goes live, as required by [Aave Governance Framework v2](https://governance.aave.com/t/arfc-governance-framework-v2/25348).
5. Escalate to the AIP Voting stage.

## References

- Implementation: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261016_AaveV3XLayer_AaveV3XLayerSyrupUSDCListing/AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016.sol)
- Tests: [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261016_AaveV3XLayer_AaveV3XLayerSyrupUSDCListing/AaveV3XLayer_AaveV3XLayerSyrupUSDCListing_20261016.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-asset-listing-syrupusdc-x-layer/25855)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
