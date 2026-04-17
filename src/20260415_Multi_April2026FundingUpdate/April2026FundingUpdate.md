---
title: "April 2026 - Funding Update"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-april-2026-funding-update/24447"
---

## Simple Summary

This publication presents the April Funding Update, consisting of the following key activities:

- Acquire GHO to support the runway; and,
- Create Allowances to support Operations,
- Paying out bug bounties and reimbursements.

## Motivation

This publication addresses near-term operational requirements, consolidates asset holdings, and refreshes the MainnetSwapSteward’s Allowances to support buyback and runway initiatives.

The MainnetSwapSteward will continue executing a rolling GHO acquisition strategy to maintain adequate runway, support AAVE buybacks, and preserve sufficient budget to fund ongoing growth initiatives.

Reimburse TokenLogic for costs incurred in facilitating the audit of one PR intended to streamline the UX for moving from USDC or USDT to GHO or sGHO. The Gho Router contract allows users to swap routes, use GSMs (Gho Stability Modules), and enter/exit sGHO. The total cost of ChainSecurity’s audit was 21,322 GHO.

## Specification

### Runway

Deposit idle ETH on the Collector into the Aave v3 Core instance.

### Merit Program

Create an allowance for Merit of 2M aEthLidoGHO from Aave V3 Prime on Ethereum, sufficient to cover slightly more than 7 weeks of duration at the current 275k/week spend rate:

Asset: aEthLidoGHO: `0x18eFE565A5373f430e2F809b97De30335B3ad96A`
Amount: 2M
Spender: Merit `0xdeadD8aB03075b7FBA81864202a2f59EE25B312b`
Method: `approve() aEthLidoGHO` on the Aave Collector contract to the Merit address

### Avalanche

To support asset bridging, an Allowance will be created, enabling the AFC to bridge the following assets from Avalanche to Ethereum.

Amount: 1.55M aAvaUSDT `0x6ab707Aca953eDAeFBc4fD23bA73294241490620`
Amount: 650k avUSDT `0x532E6537FEA298397212F09A61e03311686f548e`
Amount: 2.25M avUSDC `0x46A51127C3ce23fb7AB1DE06226147F446e4a857`
Amount: 3.5M aAvaUSDC `0x625E7708f30cA75bfd92586e17077590C60eb4cD`
Amount: 2.75M aAvaDAI `0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE`
Amount: 335 aAvaWETH `0xe50fA9b3c56FfB159cB0FCA61F5c9D750e8128c8`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`

Method: `approve()` the above assets on the Aave Collector contract to the AFC address.
The holdings shall be consolidated into USDT, USDC and WETH before being deposited into the Ethereum Core instance.

### Ethereum

To support the continued success of the friendly Tydro deployment, an AAVE Allowance from the Ecosystem Reserve will be created to fund an upcoming incentive campaign.

Amount: 30,000 AAVE `0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` the above assets on the Ecosystem Reserve contract to the AFC address from which it will be routed to the Ink Network.

### Token Budget

| Token | Amount |
| ----- | ------ |
| ETH   | 5k     |
| USDC  | 10M    |
| USDT  | 10M    |
| USDe  | 10M    |
| USDS  | 10M    |
| DAI   | 5M     |

Reference: [MainnetSwapSteward forum post](https://governance.aave.com/t/arfc-steward-deployment-mainnetswapsteward-and-rewardssteward/23070).

### Reimbursements

Reimburse 21,322 GHO to TokenLogic for GhoRouter audit expenses incurred.

Asset: GHO: `0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f`
Amount: 21,322
Spender: TokenLogic `0xAA088dfF3dcF619664094945028d44E779F19894`

Create 1M aEthLidoGHO allowance to Aave Labs in order to reimburse for on-going audit costs.

Asset: aEthLidoGHO: `0x18eFE565A5373f430e2F809b97De30335B3ad96A`
Amount: 1M
Spender: TokenLogic `0xaaf400e4bbc38b5e2136c1a36946bf841a357307`
Method: `approve()` the above assets on the Collector.

### Bug Bounty

- 5,000 GHO to `0xa9E6B917F3e0a89664d648B6DF474AB88D0D15ff`
- $500 GHO to `0x7119f398b6C06095c6E8964C1f58e7C1BAa79E18` (immunefi.eth).
  This is the fee corresponding to 10% of the previous bounty.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260415_Multi_April2026FundingUpdate/AaveV3Ethereum_April2026FundingUpdate_20260415.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260415_Multi_April2026FundingUpdate/AaveV3Avalanche_April2026FundingUpdate_20260415.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260415_Multi_April2026FundingUpdate/AaveV3Ethereum_April2026FundingUpdate_20260415.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260415_Multi_April2026FundingUpdate/AaveV3Avalanche_April2026FundingUpdate_20260415.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-april-2026-funding-update/24447)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
