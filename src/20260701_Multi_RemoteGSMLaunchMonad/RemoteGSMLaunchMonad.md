---
title: "Remote GSM Launch: Monad"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/TODO-arfc-launch-remotegsm-on-monad"
snapshot: "https://snapshot.org/#/s:aavedao.eth/proposal/TODO"
---

## Simple Summary

Launch a GHO GSM on Monad (USDC) using the RemoteGSM architecture. The proposal mints 50M GHO via a dedicated `GhoDirectFacilitator` on Ethereum, bridges it to Monad over CCIP to seed the local `GhoReserve`, and wires up the Monad USDC GSM. Unlike the Arbitrum RemoteGSM launch, GHO CCIP lane capacities are left unchanged: only the Ethereum ↔ Monad lane is temporarily widened for the one-off seed transfer and then restored to its prior config.

## Motivation

The RemoteGSM upgrade refactors GHO's stability mechanism into a three-layer design (`GhoDirectFacilitator` → `GhoReserve` → `GSM`), removing the prior requirement that each GSM be its own GHO facilitator and unlocking GSM deployment on L2s, where GHO cannot be minted directly. Deploying a USDC GSM on Monad extends GHO's stability surface to a new network while keeping mint and bridge control under DAO governance.

## Specification

### Fund the Monad GHO Reserve

On Ethereum:

- Temporarily raise the GHO CCIP bridge limit and the Monad-lane outbound rate limiter to fit a one-off 50M GHO transfer.
- Register a Monad-scoped `GhoDirectFacilitator` on the GHO token with a 50M bucket capacity.
- Mint 50M GHO into the payload and bridge it to Monad via `AaveGhoCcipBridge` (configuring the Monad destination lane first).
- After bridging, restore the Ethereum ↔ Monad lane rate-limit config to its prior value. No other lane is modified.

On Monad:

- Temporarily raise the CCIP token-pool facilitator bucket capacity and the Ethereum-lane inbound rate limiter to receive the 50M GHO.
- On receipt, the `Collector` forwards the 50M GHO to the `GhoReserve`.
- After bridging, restore the Monad ↔ Ethereum lane rate-limit config to its prior value.

### Wire up Monad GSM (USDC)

For the GSM:

- Point it at the `GhoReserve`, enroll it as an entity with a 25M GHO reserve limit.
- Grant `SWAP_FREEZER_ROLE` to the asset's `OracleSwapFreezer` and to the Monad executor.
- Register it in the `GsmRegistry` and grant `CONFIGURATOR_ROLE` to the `GhoGsmSteward`.
- Set the initial exposure cap to 20M of the underlying (6 decimals) and attach the 0% mint / 0.10% burn fee strategy.

`LIMIT_MANAGER_ROLE` on the Monad `GhoReserve` is granted to the Monad Risk Council.

> TODO: The Monad GSM, GhoReserve, GhoGsmSteward, GsmRegistry, OracleSwapFreezer, fee strategy and Risk Council (and the Ethereum-side `GhoDirectFacilitator` and Monad counterpart bridge) are not deployed yet. Those addresses are left as `address(0)` in the payloads and must be filled in before deploy.

### GHO CCIP lane capacity

GHO CCIP lane rate-limit capacities are kept the same as before execution. The proposal only widens the Ethereum ↔ Monad lane temporarily to move the 50M seed, then restores it. The remaining networks (Arbitrum, Avalanche, Base, Gnosis, Mantle, Plasma, X-Layer, Ink) only increase their CCIP token-pool facilitator bucket capacity by 50M to account for the newly minted supply; their lane rate limits are not touched.

## References

- Implementation: [AaveV3Ethereum_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1.sol), [AaveV3Ethereum_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2.sol), [AaveV3Monad_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Monad_RemoteGSMLaunchMonad_20260701_Part1.sol), [AaveV3Monad_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Monad_RemoteGSMLaunchMonad_20260701_Part2.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Arbitrum_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Avalanche_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Base_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Gnosis_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Mantle_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Ink](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ink_RemoteGSMLaunchMonad_20260701.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Plasma_RemoteGSMLaunchMonad_20260701.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3XLayer_RemoteGSMLaunchMonad_20260701.sol)
- Tests: [AaveV3Ethereum_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part1.t.sol), [AaveV3Ethereum_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ethereum_RemoteGSMLaunchMonad_20260701_Part2.t.sol), [AaveV3Monad_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Monad_RemoteGSMLaunchMonad_20260701_Part1.t.sol), [AaveV3Monad_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Monad_RemoteGSMLaunchMonad_20260701_Part2.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Arbitrum_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Avalanche_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Base_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Gnosis_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Mantle_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Ink](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Ink_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3Plasma_RemoteGSMLaunchMonad_20260701.t.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260701_Multi_RemoteGSMLaunchMonad/AaveV3XLayer_RemoteGSMLaunchMonad_20260701.t.sol)
- [Snapshot](https://snapshot.org/#/s:aavedao.eth/proposal/TODO)
- [Discussion](https://governance.aave.com/t/TODO-arfc-launch-remotegsm-on-monad)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
