---
title: "Increase GHO GSM Capacity on Plasma"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327"
---

## Simple Summary

This publication proposes minting an additional 50M GHO from the GhoDirectFacilitator on Ethereum and bridging it to the Plasma GSM via Chainlink CCIP, bringing the total GHO bridged to Plasma to 100M. Additionally, this proposal will increase rate limits of GHO bridges across any network from 1.5M to 5.0M and a refill rate from 300 to 1,000 GHO per second.

## Motivation

Since the initial deployment of GHO on Plasma (AIP-452), the RemoteGSM has seen strong demand. The full 50M GHO minted into the GhoReserve on Plasma has been consumed, indicating healthy adoption with almost 30M of net GHO swapped via the remoteGSM in the first 2 weeks, representing sustained demand for GHO on the Plasma network.

Plasma’s active incentive program continues to drive growth, and further expansion of GHOs is expected. Without additional GHO supply in the RemoteGSM reserve, users cannot mint GHO via the GSM, limiting the network’s ability to absorb demand and maintain GHO’s peg stability on Plasma.

## Specification

1. Mint 50,000,000 GHO

Mint 50M GHO from the GhoDirectFacilitator into the GhoReserve on Ethereum.

| Parameter             | Value                                      |
| --------------------- | ------------------------------------------ |
| Facilitator           | 0x2bd010Ab5393AB51b601B99C4B33ba148d9466e9 |
| GhoReserve (Ethereum) | 0x54C58157DeF387A880AE62332D1445f03adbE7E9 |
| Mint Amount           | 50,000,000 GHO                             |

New Facilitator Bucket Level 100,000,000 GHO (100% of capacity)

2. Bridge 50,000,000 GHO to Plasma via CCIP

Bridge the minted GHO from the Ethereum GhoReserve to the Plasma Collector using Chainlink CCIP.

| Parameter                      | Value                                       |
| ------------------------------ | ------------------------------------------- |
| Source Chain                   | Ethereum                                    |
| Destination Chain              | Plasma (CCIP selector: 9335212494177455608) |
| GHO CCIP Token Pool (Ethereum) | 0x06179f7C1be40863405f374E7f5F8806c728660A  |
| GHO CCIP Token Pool (Plasma)   | 0x360d8aa8F6b09B7BC57aF34db2Eb84dD87bf4d12  |
| Destination (Plasma GSM)       | 0x6aC541605b0317dE076C9FeC2842902c844dEa74  |
| Amount                         | 50,000,000 GHO                              |

Additionally, after a trial period with a maximum bridge amount of 1.5M across any networks, and a refill rate of 300 GHO per second, we are increasing the amounts to a maximum bridge amount of 5.0M and a refill rate of 1,000 GHO per second.

Set new bridgeLimit across all networks to 150M to align with current amounts of GHO on L2s.

## References

- Implementation: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Arbitrum_IncreaseGHOGSMCapacityOnPlasma_20260325.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325.sol), [AaveV3Plasma Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1.sol), [AaveV3Plasma Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325.sol)
- Tests: [AaveV3Ethereum Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1.t.sol), [AaveV3Ethereum Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Ethereum_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Avalanche_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Arbitrum_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Base_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol), [AaveV3Plasma Part 1](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part1.t.sol), [AaveV3Plasma Part 2](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Plasma_IncreaseGHOGSMCapacityOnPlasma_20260325_Part2.t.sol), [AaveV3Mantle](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3Mantle_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260325_Multi_IncreaseGHOGSMCapacityOnPlasma/AaveV3XLayer_IncreaseGHOGSMCapacityOnPlasma_20260325.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-increase-gho-gsm-capacity-on-plasma/24327)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
