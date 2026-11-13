---
title: "Permissioned GSM: USAT on Aave V4 Avalanche"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852"
snapshot: "TBA"
---

## Simple Summary

Launch a permissioned GHO Stability Module (GSM) on Avalanche backed by USAT supplied to Aave V4 (waCoreUSAT). The proposal mints 65M GHO through a new `GhoDirectFacilitator` on Ethereum, bridges it over CCIP to fund a new `GhoReserve` on Avalanche, and wires up a `PermissionedGsm4626` where only approved addresses can swap.

## Motivation

Some institutional arrangements require GHO liquidity restricted to approved counterparties. The permissioned GSM keeps the existing GSM exchange functionality and adds per-direction access control, while the USAT stays supplied to Aave V4. The GSM draws GHO from a `GhoReserve` on Avalanche, funded once from Ethereum, following the RemoteGSM architecture used for Plasma, Monad and Arbitrum.

## Specification

### Fund the Avalanche GHO Reserve

On Ethereum:

- Part 1: raise the GHO CCIP bridge limit by 65M to 265M (the bridged amount stays locked in the token pool) and temporarily set the Ethereum to Avalanche outbound rate limiter to 71,500,000 GHO capacity (initial funding * 110%) with a refill rate of 64,999,999 GHO/s. The inbound side stays at 5M capacity and 1,000 GHO/s.
- Part 2: register a new `GhoDirectFacilitator` with a 65M bucket, mint 65M GHO, configure the Avalanche destination on the `AaveGhoCcipBridge` (gas limit 450,000), bridge the 65M GHO to the Avalanche `AaveGhoCcipBridge` (fee paid in LINK held by the bridge), then set every GHO lane of the Ethereum token pool to the ongoing configuration.

On Avalanche:

- Part 1: raise the CCIP token pool facilitator bucket by 65M to 265M and temporarily set the Ethereum to Avalanche inbound rate limiter to the same 71,500,000 GHO capacity and 64,999,999 GHO/s refill rate. The Avalanche `AaveGhoCcipBridge` forwards the received GHO to the Collector.
- Part 2: move the 65M GHO from the Collector to the `GhoReserve`, then set every GHO lane of the Avalanche token pool to the ongoing configuration.

On Arbitrum, Base, Gnosis, Ink, Mantle, Plasma, X Layer and Monad: raise the CCIP token pool facilitator bucket by 65M to 265M and set every GHO lane of the token pool to the ongoing configuration.

The ongoing configuration of every lane, in both directions, is 5,000,000 GHO capacity and 1,000 GHO/s refill rate (the current values).

| Parameter                                       | Value            |
| ----------------------------------------------- | ---------------- |
| Initial outbound capacity, Ethereum → Avalanche | 71,500,000 GHO   |
| Initial refill rate                             | 64,999,999 GHO/s |
| Ongoing inbound / outbound capacity             | 5,000,000 GHO    |
| Ongoing refill rate                             | 1,000 GHO/s      |
| Bridge bucket capacity, every chain             | 265,000,000 GHO  |
| `GhoDirectFacilitator` bucket                   | 65,000,000 GHO   |

### Wire up the USAT Permissioned GSM

The GSM, its `GhoReserve`, the `GhoGsmSteward` and a `GsmRegistry` are deployed beforehand with the Avalanche executor as admin. The GSM is deployed with waCoreUSAT as underlying, already pointing at the `GhoReserve`, with a 20M waCoreUSAT exposure cap and the `FixedPriceStrategy4626` pricing strategy. The price of USAT is hardcoded to 1 and a waCoreUSAT share converts at its `convertToAssets()` rate.

On Avalanche, Part 2:

- Add the GSM as an entity of the `GhoReserve` with a 25M GHO limit, and grant `LIMIT_MANAGER_ROLE` on the reserve to the GHO Risk Council.
- Grant `SWAP_FREEZER_ROLE` to the Avalanche executor.
- Register the GSM in the Avalanche `GsmRegistry`.
- Grant `CONFIGURATOR_ROLE` to the `GhoGsmSteward`, so the GHO Risk Council can adjust the exposure cap.
- Grant `SWAP_ACCESS_MANAGER_ROLE` to the Avalanche executor and to the GHO Risk Council. This role administers `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE`.
- Grant `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE` to the Aave DAO Safe controlled by the Aave Finance Committee.

| Parameter                 | Value                                                                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Underlying asset          | USAT [`0x9A5926fd88F747c357738b1e82aFB46AB80f0A6b`](https://snowscan.xyz/address/0x9A5926fd88F747c357738b1e82aFB46AB80f0A6b)                           |
| GSM asset                 | waCoreUSAT [`0x653F2541E7d51a846e92fA6F7866bA92e465a379`](https://snowscan.xyz/address/0x653F2541E7d51a846e92fA6F7866bA92e465a379)                     |
| GSM                       | [`0xF6b70344b92cAb2D23c96eA834bbb45ADbdd6c40`](https://snowscan.xyz/address/0xF6b70344b92cAb2D23c96eA834bbb45ADbdd6c40)                                |
| GhoReserve                | [`0x15f22f39FD7b3612840cF0De49b6f9C4879Aa642`](https://snowscan.xyz/address/0x15f22f39FD7b3612840cF0De49b6f9C4879Aa642)                                |
| Pricing strategy          | [`0x863F2106C5543266b43991Fe842551B0E30FBF0d`](https://snowscan.xyz/address/0x863F2106C5543266b43991Fe842551B0E30FBF0d)                                |
| GhoReserve limit          | 25,000,000 GHO                                                                                                                                         |
| Exposure cap              | 20,000,000 waCoreUSAT                                                                                                                                  |
| Sell fee / Buy fee        | 0% / 0%, no fee strategy                                                                                                                               |
| Automatic freeze strategy | none                                                                                                                                                   |
| Approved swappers         | Aave DAO Safe [`0x22740deBa78d5a0c24C58C740e3715ec29de1bFa`](https://snowscan.xyz/address/0x22740deBa78d5a0c24C58C740e3715ec29de1bFa), both directions |
| Fee and yield recipient   | Avalanche Collector                                                                                                                                    |

### Access management after execution

The GHO Risk Council holds `SWAP_ACCESS_MANAGER_ROLE`. Without a governance vote, it can give or remove buy access, sell access, or both, for any address, including the commercial counterparty, and open buys or sells to all addresses and close them again. Aave Governance keeps the same role and can revoke it from the GHO Risk Council at any time. The commercial counterparty is approved in a follow-up GHO Risk Council transaction.

The GHO Risk Council also holds `LIMIT_MANAGER_ROLE` on the `GhoReserve` and calls the `GhoGsmSteward`, which can change the exposure cap by up to 100% per update.

### Fees, freezing and seizure

- The GSM has no fee strategy and charges no fees. Introducing a non-zero fee requires an AIP to deploy and configure a fee strategy. After that, the `GhoGsmSteward` can adjust fees by up to 0.5 percentage points per direction.
- There is no automatic freeze strategy. The Avalanche executor holds `SWAP_FREEZER_ROLE`, so swaps are frozen through governance.
- Seizure requires an AIP that grants `LIQUIDATOR_ROLE` and seizes. This proposal does not grant that role.

### Risks and dependencies

- The USAT onboarding to Aave V4 Avalanche (aave-proposals-v3 PR 1236) creates waCoreUSAT and must execute before this proposal.
- PR 1236 sets the waCoreUSAT tokenization cap to 1.5M USAT. Until that cap is raised, it limits the effective size of the GSM, not the 20M exposure cap.
- The exposure cap is counted in waCoreUSAT shares. As the share price grows, the GHO value of a full 20M cap drifts above 20M GHO.
- The GHO Risk Council can raise the GSM limit on the `GhoReserve` from 25M up to the 65M funded without a vote.
- To wind the GSM down, first set the exposure cap to 0 with `updateExposureCap(0)`, then lower the reserve limit.
- Avalanche Part 2 can be retried only until the payload expires. If the bridged GHO has not reached the Collector by then, a new payload is needed.

### Execution Order

1. Ethereum Part 1 raises the bridge limit and the outbound rate limiter.
2. Ethereum Part 2 mints and bridges 65M GHO. The outbound bucket refills at 64,999,999 GHO/s, so if it is empty when Part 1 executes, Part 2 needs up to 2 seconds after Part 1.
3. Avalanche Part 1 must execute before the CCIP message arrives. Otherwise the inbound rate limiter rejects the mint and the delivery has to be retried manually on https://ccip.chain.link/.
4. Avalanche Part 2 reverts until the bridged GHO has reached the Collector.
5. The payloads on the other chains are independent of the Ethereum and Avalanche payloads.

### Security reviews

- Pashov: TBA
- Certora: TBA

## References

- Implementation: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.sol), [AaveV3Avalanche Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.sol), [AaveV3Avalanche Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Arbitrum_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Base_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Gnosis_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Ink](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ink_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Mantle_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Plasma_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3XLayer_PermissionedGSMUSATAvalanche_20261109.sol), [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Monad_PermissionedGSMUSATAvalanche_20261109.sol)
- Tests: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.t.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol), [AaveV3Avalanche Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.t.sol), [AaveV3Avalanche Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Arbitrum_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Base_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Gnosis_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Ink](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ink_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Mantle_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Plasma_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3XLayer_PermissionedGSMUSATAvalanche_20261109.t.sol), [AaveV3Monad](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Monad_PermissionedGSMUSATAvalanche_20261109.t.sol)
- Snapshot: TBA
- [Discussion](https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
