---
title: "Permissioned GSM: USAT on Aave V4 Avalanche"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852"
snapshot: "TBA"
---

## Simple Summary

Launch a permissioned GHO Stability Module (GSM) on Avalanche backed by USAT deposited in Aave V4 (waCoreUSAT). The proposal mints 65M GHO through a dedicated `GhoDirectFacilitator` on Ethereum, bridges it to Avalanche over CCIP to fund a new `GhoReserve`, and wires up a `PermissionedGsm4626` where only approved addresses can swap.

## Motivation

The permissioned GSM lets the Aave DAO offer GHO liquidity against USAT to a known set of counterparties while the underlying earns yield in Aave V4. Swap access is limited by role, so the DAO controls who can mint and redeem through this module. The GSM draws GHO from a `GhoReserve` on Avalanche, funded once from Ethereum, following the RemoteGSM architecture used for the Monad GSM.

## Specification

### Fund the Avalanche GHO Reserve

On Ethereum:

- Part 1: raise the GHO CCIP bridge limit by 65M (the bridged amount stays locked in the token pool) and temporarily widen the Ethereum to Avalanche outbound rate limiter to 66M capacity with a refill rate of the capacity minus 1 wei per second.
- Part 2: register a `GhoDirectFacilitator` with a 65M bucket, mint 65M GHO, configure the Avalanche destination on the `AaveGhoCcipBridge` (gas limit 450,000), bridge the 65M GHO to the Avalanche `AaveGhoCcipBridge` (fee paid in LINK held by the bridge), then restore the Ethereum to Avalanche lane to 5M capacity and 1,000 GHO/s refill in both directions.

On Avalanche:

- Part 1: raise the CCIP token pool facilitator bucket by 65M and temporarily widen the Ethereum to Avalanche inbound rate limiter to 66M capacity with a refill rate of the capacity minus 1 wei per second. The Avalanche `AaveGhoCcipBridge` forwards the received GHO to the Collector.
- Part 2: move the 65M GHO from the Collector to the `GhoReserve`, then restore the Avalanche to Ethereum lane to 5M capacity and 1,000 GHO/s refill in both directions.

No other CCIP lane is modified.

### Wire up the USAT Permissioned GSM

The GSM, its `GhoReserve`, the `GhoGsmSteward` and a `GsmRegistry` are deployed beforehand with the Avalanche executor as admin. The GSM is deployed already pointing at the `GhoReserve` with a 20M waCoreUSAT exposure cap (6 decimals).

On Avalanche, Part 2:

- Add the GSM as an entity of the `GhoReserve` with a 25M GHO limit, and grant `LIMIT_MANAGER_ROLE` on the reserve to the GHO Risk Council.
- Grant `SWAP_FREEZER_ROLE` to the Avalanche executor.
- Register the GSM in the Avalanche `GsmRegistry`.
- Grant `CONFIGURATOR_ROLE` to the `GhoGsmSteward`, so the GHO Risk Council can adjust the exposure cap.
- Grant `SWAP_ACCESS_MANAGER_ROLE` to the Avalanche executor and to the GHO Risk Council. This role administers `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE`.
- Grant `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE` to the Aave DAO Safe and to the approved counterparty.

| Parameter          | Value                                |
| ------------------ | ------------------------------------ |
| Underlying         | waCoreUSAT (Aave V4 tokenized USAT)  |
| GhoReserve limit   | 25,000,000 GHO                       |
| Exposure cap       | 20,000,000 waCoreUSAT                |
| Sell fee / Buy fee | 0% / 0%                              |
| Approved swappers  | Aave DAO Safe, approved counterparty |

### Deviations from the ARFC

- No fee strategy. Swap fees are 0% on both sides, and `FixedFeeStrategy` rejects a 0/0 configuration, so the GSM runs with no fee strategy and charges no fees. The `GhoGsmSteward` can only change fees on a GSM that already has a fee strategy, so any future fee change first needs a governance proposal that calls `updateFeeStrategy`.
- No `OracleSwapFreezer`. The freezer reads the Aave V3 Avalanche oracle, which has no USAT price source, and the USAT feed returns a constant 1 USD, so 0.99 / 1.01 freeze bands could never trigger. There is no fast freezer: the Avalanche executor holds `SWAP_FREEZER_ROLE`, so swaps can only be frozen through a full governance vote.
- The GHO Risk Council receives `SWAP_ACCESS_MANAGER_ROLE`. This is an addition to the ARFC.
- Open item, Avalanche token pool bucket: the ARFC states 250M. The on-chain bucket is 200M today, and Avalanche Part 1 adds 65M, giving 265M. To be confirmed before Snapshot.

### Risks and dependencies

- The USAT listing on Aave V4 Avalanche (aave-proposals-v3 PR 1236) is a prerequisite: it creates waCoreUSAT and must execute before this proposal.
- PR 1236 sets the waCoreUSAT tokenization cap to 1.5M USAT. Until that cap is raised, it limits the effective size of the GSM, not the 20M exposure cap.
- The exposure cap is counted in waCoreUSAT shares. As the share price grows, the GHO value of a full 20M cap drifts above 20M GHO.
- The GHO Risk Council holds `LIMIT_MANAGER_ROLE` on the `GhoReserve`, so it can raise the GSM limit from 25M up to the 65M funded without a vote.
- To wind the GSM down, first set the exposure cap to 0 with `updateExposureCap(0)`, then lower the reserve limit (Pashov I-03).
- Avalanche Part 2 can be retried only until the payload expires. If the bridged GHO has not reached the Collector by then, a new payload is needed.

### Access management after execution

The GHO Risk Council holds `SWAP_ACCESS_MANAGER_ROLE`. It can add or remove approved counterparties, and open buy or sell access to everyone, without a governance vote. The Risk Council and the Aave DAO Safe on Avalanche have the same three signers with a threshold of two.

### Execution Order

1. Ethereum Part 1: raises the bridge limit and the outbound rate limiter.
2. Ethereum Part 2: mints and bridges 65M GHO. It reverts if executed in the same second as Part 1 (the outbound bucket needs about 1 second to refill).
3. Avalanche Part 1 must execute before the CCIP message arrives. Otherwise the inbound rate limiter rejects the mint and the delivery has to be retried manually on https://ccip.chain.link/.
4. Avalanche Part 2 reverts until the bridged GHO has reached the Collector.

### Security reviews

- Pashov: TBA
- Certora: TBA

## References

- Implementation: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.sol), [AaveV3Avalanche Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.sol), [AaveV3Avalanche Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.sol)
- Tests: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part1.t.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Ethereum_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol), [AaveV3Avalanche Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part1.t.sol), [AaveV3Avalanche Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261109_Multi_PermissionedGSMUSATAvalanche/AaveV3Avalanche_PermissionedGSMUSATAvalanche_20261109_Part2.t.sol)
- Snapshot: TBA
- [Discussion](https://governance.aave.com/t/arfc-permissioned-gsm-usat-aave-v4-avalanche/25852)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
