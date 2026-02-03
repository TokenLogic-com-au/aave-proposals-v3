---
title: "Gho X-Layer Activation"
author: "@TokenLogic"
discussions: TODO
snapshot: TODO
---

## Simple Summary

## Motivation

## Specification

This AIP includes a series of actions required to launch GHO on Mantle:

1. Configure new Chainlink CCIP lanes between Mantle and the chains where GHO is launched with a rate limit of 1.5M GHO capacity and 300 GHO per second rate.
2. Configure GhoCcipSteward.
3. Configure GhoBucketSteward

   The table below lists the address of the new **Mantle** deployments

   | Contract           | Address                                                                                                                 |
   | :----------------- | :---------------------------------------------------------------------------------------------------------------------- |
   | GhoToken           | [0xfc421aD3C883Bf9E7C4f42dE845C4e4405799e73](https://mantlescan.xyz/address/0xb0e1c7830aa781362f79225559aa068e6bdaf1d1) |
   | GhoTokenPool       | [0xDe6539018B095353A40753Dc54C91C68c9487D4E](https://mantlescan.xyz/address/0xde6539018b095353a40753dc54c91c68c9487d4e) |
   | GhoBucketSteward   | [0x2Ce400703dAcc37b7edFA99D228b8E70a4d3831B](https://mantlescan.xyz/address/0x2ce400703dacc37b7edfa99d228b8e70a4d3831b) |
   | GhoCcipSteward     | [0x20fd5f3FCac8883a3A0A2bBcD658A2d2c6EFa6B6](https://mantlescan.xyz/address/0x20fd5f3FCac8883a3A0A2bBcD658A2d2c6EFa6B6) |
   | GhoAavecoreSteward | [0xA5Ba213867E175A182a5dd6A9193C6158738105A](https://mantlescan.xyz/address/0xA5Ba213867E175A182a5dd6A9193C6158738105A) |

## References

- Implementation: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Ethereum_GhoXLayerActivation_20260203.sol), [AaveV3Avalanche](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Avalanche_GhoXLayerActivation_20260203.sol), [AaveV3Arbitrum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Arbitrum_GhoXLayerActivation_20260203.sol), [AaveV3Base](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Base_GhoXLayerActivation_20260203.sol), [AaveV3Gnosis](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Gnosis_GhoXLayerActivation_20260203.sol), [AaveV3Plasma](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Plasma_GhoXLayerActivation_20260203.sol)
- Tests: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Ethereum_GhoXLayerActivation_20260203.t.sol), [AaveV3Avalanche](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Avalanche_GhoXLayerActivation_20260203.t.sol), [AaveV3Arbitrum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Arbitrum_GhoXLayerActivation_20260203.t.sol), [AaveV3Base](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Base_GhoXLayerActivation_20260203.t.sol), [AaveV3Gnosis](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Gnosis_GhoXLayerActivation_20260203.t.sol), [AaveV3Plasma](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20260203_Multi_GhoXLayerActivation/AaveV3Plasma_GhoXLayerActivation_20260203.t.sol)
  [Snapshot](TODO)
- [Discussion](https://governance.aave.com/t/arfc-launch-gho-on-x-layer-set-aci-as-emissions-manager-for-rewards/23178)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
