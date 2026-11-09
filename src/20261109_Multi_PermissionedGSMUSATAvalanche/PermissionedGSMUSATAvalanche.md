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

- Part 1: raise the GHO CCIP bridge limit by 65M (the bridged amount stays locked in the token pool) and temporarily widen the Ethereum to Avalanche outbound rate limiter to 66M.
- Part 2: register a `GhoDirectFacilitator` with a 65M bucket, mint 65M GHO, configure the Avalanche destination on the `AaveGhoCcipBridge` (gas limit 450,000), bridge the 65M GHO to the Avalanche `AaveGhoCcipBridge` (fee paid in LINK held by the bridge), then restore the Ethereum to Avalanche lane to 5M capacity and 1,000 GHO/s refill in both directions.

On Avalanche:

- Part 1: raise the CCIP token pool facilitator bucket by 65M and temporarily widen the Ethereum to Avalanche inbound rate limiter to 66M. The Avalanche `AaveGhoCcipBridge` forwards the received GHO to the Collector.
- Part 2: move the 65M GHO from the Collector to the `GhoReserve`, then restore the Avalanche to Ethereum lane to 5M capacity and 1,000 GHO/s refill in both directions.

No other CCIP lane is modified.

### Wire up the USAT Permissioned GSM

On Avalanche, Part 2:

- Point the GSM at the `GhoReserve`, add it as an entity with a 25M GHO limit, and grant `LIMIT_MANAGER_ROLE` on the reserve to the GHO Risk Council.
- Grant `SWAP_FREEZER_ROLE` to the USAT `OracleSwapFreezer` and to the Avalanche executor.
- Register the GSM in the `GsmRegistry` and grant `CONFIGURATOR_ROLE` to the `GhoGsmSteward`.
- Set the exposure cap to 20M waCoreUSAT (6 decimals).
- Swap fees are 0% on both sides, so no fee strategy is attached.
- Grant `SWAP_ACCESS_MANAGER_ROLE` to the Avalanche executor and to the GHO Risk Council. This role administers `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE`.
- Grant `BUY_ASSET_ROLE` and `SELL_ASSET_ROLE` to the Aave DAO Safe and to the approved counterparty.

| Parameter          | Value                                |
| ------------------ | ------------------------------------ |
| Underlying         | waCoreUSAT (Aave V4 tokenized USAT)  |
| GhoReserve limit   | 25,000,000 GHO                       |
| Exposure cap       | 20,000,000 waCoreUSAT                |
| Sell fee / Buy fee | 0% / 0%                              |
| Approved swappers  | Aave DAO Safe, approved counterparty |

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
