---
title: "Gho Monad Activation"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/arfc-deploy-aave-protocol-on-monad/24943"
snapshot: "https://snapshot.box/#/s:aavedao.eth/proposal/0x24f105bd023c476a9b85fa87ff795bfeec769fa799ce6ada8e2724c9738049f6"
---

## Simple Summary

This AIP proposes activating CCIP Lanes for GHO on the Monad blockchain.

## Motivation

Monad’s pipelined EVM architecture delivers fast, high-throughput performance while remaining fully compatible with Ethereum, making it ideal for real-time financial applications.
This directly supports the needs of neobanks and fintech platforms, which rely on quick transaction finality, scalability, and predictable costs.

Deploying GHO concurrently with the Aave instance on Monad ensures that GHO has every chance of becoming foundational to DeFi and payments infrastructure on a chain optimized for performance.

The goal is to establish GHO as a key stablecoin within Monad’s ecosystem from inception, facilitating reward programs, liquidity incentives, and seamless integration with the upcoming Aave deployment.

## Specification

This AIP includes a series of actions required to launch GHO on Monad:

1. Configure new Chainlink CCIP lanes between Monad and the chains where GHO is launched with a rate limit of (TODO) GHO capacity and (TODO) GHO per second rate.
2. Configure GhoCcipSteward.
3. Configure GhoBucketSteward

   The table below lists the address of the new **Monad** deployments

   | Contract           | Address                                                                                                                |
   | :----------------- | :--------------------------------------------------------------------------------------------------------------------- |
   | GhoToken           | [0xa5ae05b71c3f170e12e7620fdf7679721aec1ec8](https://monadscan.com/address/0xa5ae05b71c3f170e12e7620fdf7679721aec1ec8) |
   | GhoTokenPool       | [0xfc421ad3c883bf9e7c4f42de845c4e4405799e73](https://monadscan.com/address/0xfc421ad3c883bf9e7c4f42de845c4e4405799e73) |
   | GhoBucketSteward   | [0xDe6539018B095353A40753Dc54C91C68c9487D4E](https://monadscan.com/address/0xDe6539018B095353A40753Dc54C91C68c9487D4E) |
   | GhoCcipSteward     | [0x360d8aa8F6b09B7BC57aF34db2Eb84dD87bf4d12](https://monadscan.com/address/0x360d8aa8F6b09B7BC57aF34db2Eb84dD87bf4d12) |
   | GhoAavecoreSteward | [TODO](https://monadscan.com/address/TODO)                                                                             |

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Ethereum_GhoMonadActivation_20260518.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Avalanche_GhoMonadActivation_20260518.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Arbitrum_GhoMonadActivation_20260518.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Base_GhoMonadActivation_20260518.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Gnosis_GhoMonadActivation_20260518.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Plasma_GhoMonadActivation_20260518.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3XLayer_GhoMonadActivation_20260518.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Ethereum_GhoMonadActivation_20260518.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Avalanche_GhoMonadActivation_20260518.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Arbitrum_GhoMonadActivation_20260518.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Base_GhoMonadActivation_20260518.t.sol), [AaveV3Gnosis](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Gnosis_GhoMonadActivation_20260518.t.sol), [AaveV3Plasma](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3Plasma_GhoMonadActivation_20260518.t.sol), [AaveV3XLayer](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260518_Multi_GhoMonadActivation/AaveV3XLayer_GhoMonadActivation_20260518.t.sol)
  [Snapshot](https://snapshot.box/#/s:aavedao.eth/proposal/0x24f105bd023c476a9b85fa87ff795bfeec769fa799ce6ada8e2724c9738049f6)
- [Discussion](https://governance.aave.com/t/arfc-deploy-aave-protocol-on-monad/24943)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
