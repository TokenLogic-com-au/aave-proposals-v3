---
title: "Remote GSM Launch: Mantle"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240"
snapshot: "TODO"
---

## Simple Summary

Launch GHO GSMs on Mantle (stataUSDT0 and stataUSDC) using the new RemoteGSM architecture. The proposal mints 50M GHO via a dedicated `GhoDirectFacilitator` on Ethereum, bridges it to Mantle over CCIP to seed the local `GhoReserve`, wires up the two Mantle GSMs, and increases the GHO facilitator bucket capacity on every other supported network to account for the new outstanding GHO.

## Motivation

The RemoteGSM upgrade refactors GHO's stability mechanism into a three-layer design (`GhoDirectFacilitator` → `GhoReserve` → `GSM`), removing the prior requirement that each GSM be its own GHO facilitator and unlocking GSM deployment on L2s, where GHO cannot be minted directly. Following the Arbitrum Remote GSM launch, this proposal extends the same setup to Mantle, where USDT0 is the canonical Tether deployment, broadening GHO's stability surface while keeping mint and bridge control under DAO governance.

## Specification

The starting state assumed by this proposal is that every GHO CCIP lane (Arbitrum, Avalanche, Base, Gnosis, Mantle, Plasma) is configured with the canonical defaults of **capacity 5,000,000 GHO/day, refill 1,000 GHO/sec** on both inbound and outbound legs. The temporary boost applied to the Mantle lane to seed the 50M GHO transfer is restored to those same defaults in the same payloads. No CCIP rate-limit config is touched on the other networks.

### Fund the Mantle GHO Reserve

On Ethereum:

- Temporarily raise the GHO CCIP bridge limit and the Mantle-lane outbound rate limiter to fit a one-off 50M GHO transfer.
- Register a Mantle-scoped `GhoDirectFacilitator` on the GHO token with a 50M bucket capacity.
- Mint 50M GHO into the payload and bridge it to Mantle via `AaveGhoCcipBridge` (configuring the Mantle destination lane first).
- Restore the Mantle-lane CCIP rate-limit config to the canonical defaults (5M GHO/day, 1k GHO/sec).

On Mantle:

- Temporarily raise the CCIP token-pool facilitator bucket capacity and the Ethereum-lane inbound rate limiter to receive the 50M GHO.
- On receipt, the `Collector` forwards the 50M GHO to the `GhoReserve`.
- Restore the Ethereum-lane CCIP rate-limit config to the canonical defaults.

### Wire up Mantle GSMs (stataUSDT0, stataUSDC)

For each GSM:

- Point it at the `GhoReserve`, enroll it as an entity with a 15M GHO reserve limit.
- Grant `SWAP_FREEZER_ROLE` to the asset's `OracleSwapFreezer` and to the Mantle executor.
- Register it in the `GsmRegistry` and grant `CONFIGURATOR_ROLE` to the `GhoGsmSteward`.
- Set the initial exposure cap to 15M of the underlying (6 decimals) and attach the 0% mint / 0.10% burn fee strategy.

`LIMIT_MANAGER_ROLE` on the Mantle `GhoReserve` is granted to the Mantle Risk Council.

### Increase GHO facilitator bucket capacity on L2 networks

On every other GHO-deployed network — Arbitrum, Avalanche, Base, Gnosis, Plasma — increase the local CCIP token-pool facilitator bucket capacity by the 50M GHO bridged out of Ethereum in this proposal. No CCIP rate-limit config is touched on these networks.

## References

- Implementation: [AaveV3Ethereum_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Ethereum_RemoteGSMLaunchMantle_20260521_Part1.sol), [AaveV3Ethereum_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Ethereum_RemoteGSMLaunchMantle_20260521_Part2.sol), [AaveV3Mantle_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1.sol), [AaveV3Mantle_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part2.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Arbitrum_RemoteGSMLaunchMantle_20260521.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Avalanche_RemoteGSMLaunchMantle_20260521.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Base_RemoteGSMLaunchMantle_20260521.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Gnosis_RemoteGSMLaunchMantle_20260521.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Plasma_RemoteGSMLaunchMantle_20260521.sol)
- Tests: [AaveV3Ethereum_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Ethereum_RemoteGSMLaunchMantle_20260521_Part1.t.sol), [AaveV3Ethereum_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Ethereum_RemoteGSMLaunchMantle_20260521_Part2.t.sol), [AaveV3Mantle_Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part1.t.sol), [AaveV3Mantle_Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Mantle_RemoteGSMLaunchMantle_20260521_Part2.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Arbitrum_RemoteGSMLaunchMantle_20260521.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Avalanche_RemoteGSMLaunchMantle_20260521.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Base_RemoteGSMLaunchMantle_20260521.t.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Gnosis_RemoteGSMLaunchMantle_20260521.t.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260521_Multi_RemoteGSMLaunchMantle/AaveV3Plasma_RemoteGSMLaunchMantle_20260521.t.sol)
- [Snapshot](TODO)
- [Discussion](https://governance.aave.com/t/remotegsm-upgrade-enabling-l2-gsms-for-gho/24240)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
