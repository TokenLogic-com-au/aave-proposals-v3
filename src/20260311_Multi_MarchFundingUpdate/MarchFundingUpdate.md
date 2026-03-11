---
title: "March Funding Update"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-march-2026-funding-update/24225"
---

## Simple Summary

This publication presents the March Funding Update, consisting of the following key activities:

- Acquire GHO to support runway;
- Consolidate assets on Ethereum and,
- Create Allowances to support Operations.

## Motivation

This publication addresses near-term operational requirements, consolidates asset holdings, and facilitates enabling the MainnetSwapSteward to utilise ETH to acquire AAVE and/or GHO to support buyback and runway initiatives.

The MainnetSwapSteward will continue executing a rolling GHO acquisition strategy to maintain adequate runway and support AAVE buybacks, while preserving sufficient budget to fund ongoing growth initiatives.

Reimburse TokenLogic for costs incurred facilitating the audit of two PRs intended to support the sGHO upgrade. The first PR reviewed was sGHO developed by kpk, which received updates to address outstanding comments, and a follow-up order was issued. The second PR was sGhoSteward, developed by BGD Labs to manage the rate at which GHO interest accrues on the sGho contract. The total cost of Sherlock’s audit was 24,900 USDC.

## Specification

### Mainnet

Update Aave Swapper Permission
To support continued AAVE and GHO Buybacks, extend the following permissions to the SwapStewardContract contract.

Swap From Asset: `wETH`
Swap To Aaset: `GHO`, `AAVE`, `USDC`, `USDT`
Increase WETH budget by 3,000 WETH
Increase USDT budget by 2,000,000 USDT

Create an Allowance that enables the AFC to receive bridged EURC and convert to USDC.

Amount: 82,000 EURC `0x38d693cE1dF5AaDF7bC62595A37D667aD57922e5`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` above assets on the Aave Collector contract to the AFC address

Reimburse 24,900 GHO to TokenLogic for sGHO audit expenses incurred.

Asset: GHO: 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f
Amount: 24,900
Spender: TokenLogic 0xAA088dfF3dcF619664094945028d44E779F19894

### Polygon

With EURS trading above the peg, EURS will be withdrawn from Aave on Polygon and bridged to mainnet.

Create an Allowance that enables the AFC to receive EURS, convert it to USDC, and bridge the proceeds to Ethereum.

Amount: 80,000 EURS `0x38d693cE1dF5AaDF7bC62595A37D667aD57922e5`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` above assets on the Aave Collector contract to the AFC address

Bridge all of the following via the AavePolygonEthereumBridge:

- DAI
- WBTC
- USDC.e
- WETH

To support bridging assets not supported by the above, an allowance will be created, enabling the AFC to bridge the following assets from Polygon to Ethereum.

Amount: 125,000 USDCn `0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359`
Amount: 210,000 USDT0 `0xc2132D05D31c914a87C6611C10748AEb04B58e8F`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` the above assets on the Aave Collector contract to the AFC address

### Base

To support asset bridging, an Allowance will be created, enabling the AFC to bridge the following assets from Base to Ethereum.

Amount: 1,300,000 USDC `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` the above assets on the Aave Collector contract to the AFC address

### Arbitrum

To support asset bridging, an Allowance will be created, enabling the AFC to bridge the following assets from Arbitrum to Ethereum.

Amount: 3,300,000 USDCn `0xaf88d065e77c8cC2239327C5EDb3A432268e5831`
Amount: 1,300,000 USDT0 `0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` the above assets on the Aave Collector contract to the AFC address.

Bridge all of the following via the AaveArbitrumEthereumBridge:

- DAI
- LINK
- wstETH
- USDC.e

### Ink

To support the continued success of the friendly Tydro deployment, several Allowances are to be created, enabling revenue to be distributed to users as part of the Ahab program.

Amount: 80,000 aInkWlGHO `0xC629140A8aA21F8f319A21F41b2DC1b0431693C1`
Amount: 200 aInkWlWETH `0x2B35eF056728BaFFaC103e3b81cB029788006EF9`
Amount: 350,000 aInkWlUSDT `0x99cBF1Ff4527675Ed3301671105C9F7748fb8a04`
Amount: 165,000 aInkWlUSDG `0x4cd13ce4edbB5523fd4849252b5f1bF215129D10`
Amount: 70,000 aInkWlUSDC `0x70A38B0c90441e991346B7A0Cd98C8528dD1c234`
Spender: AFC `0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`
Method: `approve()` the above assets on the Aave Collector contract to the AFC address.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Ethereum_MarchFundingUpdate_20260311.sol), [AaveV3Polygon](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Polygon_MarchFundingUpdate_20260311.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Arbitrum_MarchFundingUpdate_20260311.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Base_MarchFundingUpdate_20260311.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Ethereum_MarchFundingUpdate_20260311.t.sol), [AaveV3Polygon](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Polygon_MarchFundingUpdate_20260311.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Arbitrum_MarchFundingUpdate_20260311.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260311_Multi_MarchFundingUpdate/AaveV3Base_MarchFundingUpdate_20260311.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-march-2026-funding-update/24225)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
