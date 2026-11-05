---
title: "SVR Expansion (BNB)"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332"
snapshot: "TODO"
---

## Simple Summary

Enable SVR price feeds on BNB Chain.

## Motivation

After a successful implementation of SVR on Ethereum, Base and Arbitrum, we aim to expand its coverage to the BNB Chain network.

## Specification

- **BNB**: Grants the SVR Oracle Steward ([`0x65105C82DDd10Ad37DCBe7a3A137E008CC456754`](https://bscscan.com/address/0x65105C82DDd10Ad37DCBe7a3A137E008CC456754)) the `AssetListingAdmin` role and enables SVR oracles for the following 8 assets:
  WBNB, BTCB, USDT, USDC, ETH, wstETH, FDUSD, Cake.

- **Arbitrum**: Removes the SVR Oracle Steward's ([`0x94E54D858e9293964b4ACd6f8938c831827a31F4`](https://arbiscan.io/address/0x94E54D858e9293964b4ACd6f8938c831827a31F4)) `AssetListingAdmin` role, as the steward has already completed its work on Arbitrum and no longer needs elevated permissions.

- **Base**: Removes the SVR Oracle Steward's ([`0x4B09DAEAe857b93c9103392028294F0602C5fD5b`](https://basescan.org/address/0x4B09DAEAe857b93c9103392028294F0602C5fD5b)) `AssetListingAdmin` role, as the steward has already completed its work on Base and no longer needs elevated permissions.

## References

- Implementation: [AaveV3BNB](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3BNB_SVRExpansionBNB_20261012.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3Arbitrum_SVRExpansionBNB_20261012.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3Base_SVRExpansionBNB_20261012.sol)
- Tests: [AaveV3BNB](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3BNB_SVRExpansionBNB_20261012.t.sol), [AaveV3Arbitrum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3Arbitrum_SVRExpansionBNB_20261012.t.sol), [AaveV3Base](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionBNB/AaveV3Base_SVRExpansionBNB_20261012.t.sol)
- [Snapshot](TODO)
- [Discussion](https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
