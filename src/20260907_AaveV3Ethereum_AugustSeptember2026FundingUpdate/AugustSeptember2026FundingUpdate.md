---
title: "August/September 2026 Funding Update"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-august-september-2026-funding-update/25597"
---

## Simple Summary

This publication presents the August Funding Update, consisting of the following key activities:

- Acquire GHO to support the runway;
- Create Allowances to support Operations; and
- Fund initial Asset Backed Private Credit trial deployments.

## Motivation

This publication addresses near-term operational requirements, consolidates asset holdings, and refreshes the MainnetSwapSteward's Allowances to support operations and future growth opportunities.

The MainnetSwapSteward and Aave Finance Committee (AFC) will continue executing a rolling GHO acquisition strategy to maintain adequate runway and preserve sufficient budget to fund ongoing growth initiatives.

### Reimburse Audit Costs

Reimburse TokenLogic for costs incurred in facilitating a second audit of the GHO ↔ sGHO two-way swap layer. The value of the Audit performed by Trail of Bits was 25,000 aEthLidoGHO.

Reimburse Aave Labs for Aave V4 and Aave App audit costs, along with legal costs related to handling the Kelp and LayerZero bridge exploit. The combined value of the associated costs is 1,818,102 aAvaDAI on the Avalanche Network.

### Asset Backed Private Credit

Asset-backed private credit represents a potential growth opportunity for GHO and the Aave ecosystem. TokenLogic will support the assessment, implementation, monitoring and reporting of these arrangements, in coordination with Aave Labs and within the authority and parameters established through the applicable governance process. Specialist third parties will originate and service the underlying assets.

## Specification

### Ethereum

#### Runway

Deposit idle ETH on the Collector into the Aave v3 Core instance on Ethereum.

Use the MainnetSwapSteward to acquire 4M of GHO to be deposited into the Prime instance.

#### Refresh MainnetSwapSteward Allowances

To support the acquisition of GHO, wETH and AAVE, replenish token budgets on the MainnetSwapSteward to the absolute values listed in the table below.

| Token | Budget | Acquirable Asset |
| ----- | ------ | ---------------- |
| ETH   | 5k     | GHO, AAVE        |
| USDC  | 10M    | GHO, AAVE, wETH  |
| USDT  | 10M    | GHO, AAVE, wETH  |
| USDe  | 1M     | GHO, AAVE, wETH  |
| USDS  | 0.2M   | GHO, AAVE, wETH  |
| DAI   | 0.2M   | GHO, AAVE, wETH  |
| rlUSD | 0.2M   | GHO, AAVE, wETH  |
| pyUSD | 0.2M   | GHO, AAVE, wETH  |

Upon implementation, the budgets for each token will be as shown above; any higher budgets will be marked lower, and any lower budgets will be increased to reflect the values presented in the table.

#### Asset Backed Private Credit

To prepare for creating an asset backed Private Credit Investment Mandate, this publication enables the Aave Finance Committee (AFC) to allocate funds to initial pilot-stage deployments. The AFC will use the existing wETH allowance in the Ahab Safe and assets held on the AFC or Ahab Safe(s) to source the liquidity supporting the initial allocations. The initial phase is expected to result in between $5M and $10M allocated to pilot-stage deployments of asset-backed private credit products.

#### Reimbursements

Reimburse 25,000 aEthLidoGHO to TokenLogic for the second GHO ↔ sGHO two-way swap layer audit expenses incurred.

Asset: aEthLidoGHO `0x18eFE565A5373f430e2F809b97De30335B3ad96A`
Amount: 25,000
Spender: TokenLogic `0xAA088dfF3dcF619664094945028d44E779F19894`

Reimburse 1,818,102 to Aave Labs for the Aave V4 audit, Aave App audit and rsETH related legal expenses. To complete this reimbursement, the Aave Finance Committee will transfer DAI to the Aave Labs controlled address listed below.

Network: Avalanche
From Safe: Aave Finance Committee `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Amount: 1,818,102
To Safe: Aave Labs `0x4aD8bF8e4FBaf415d51Eb394a2e097fF150353c2`

Cancel/Remove the following Allowance:

Network: Ethereum
Asset: aEthLidoWETH `0xfa1fdbbd71b0aa16162d76914d69cd8cb3ef92da`
Spender: Ahab `0xAA2461f0f0A3dE5fEAF3273eAe16DEF861cf594e`

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260907_AaveV3Ethereum_AugustSeptember2026FundingUpdate/AaveV3Ethereum_AugustSeptember2026FundingUpdate_20260907.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260907_AaveV3Ethereum_AugustSeptember2026FundingUpdate/AaveV3Ethereum_AugustSeptember2026FundingUpdate_20260907.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-august-september-2026-funding-update/25597)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
