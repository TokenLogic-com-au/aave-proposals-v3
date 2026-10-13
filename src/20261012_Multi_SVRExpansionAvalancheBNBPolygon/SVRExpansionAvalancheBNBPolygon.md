---
title: "SVR Expansion (Avalanche, BNB, Polygon)"
author: "TokenLogic"
discussions: "https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332"
snapshot: "TODO"
---

## Simple Summary

Enable SVR price feeds on Avalanche, BNB Chain and Polygon.

## Motivation

After a successful implementation of SVR on Ethereum, Base and Arbitrum, we aim to expand its coverage to the Avalanche, BNB Chain and Polygon networks.

## Specification

- **Avalanche**: Grants the SVR Oracle Steward (TODO) the `AssetListingAdmin` role and enables SVR oracles for the following 15 assets:
  BTC.b, WAVAX, sAVAX, USDC, WETH.e, USDt, DAI.e, EURC, LINK.e, AUSD, AAVE.e, WBTC.e, sUSDe, FRAX, USDe.

- **Polygon**: Grants the SVR Oracle Steward (TODO) the `AssetListingAdmin` role and enables SVR oracles for the following 12 assets:
  WBTC, USDT0, USDCn, WETH, wstETH, WPOL, USDC, DAI, AAVE, EURS, LINK, MaticX.

- **BNB**: Grants the SVR Oracle Steward ([`0x65105C82DDd10Ad37DCBe7a3A137E008CC456754`](https://bscscan.com/address/0x65105C82DDd10Ad37DCBe7a3A137E008CC456754)) the `AssetListingAdmin` role and enables SVR oracles for the following 8 assets:
  WBNB, BTCB, USDT, USDC, ETH, wstETH, FDUSD, Cake.

## References

- Implementation: [AaveV3Polygon](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012.sol), [AaveV3BNB](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012.sol)
- Tests: [AaveV3Polygon](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3Polygon_SVRExpansionAvalancheBNBPolygon_20261012.t.sol), [AaveV3Avalanche](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3Avalanche_SVRExpansionAvalancheBNBPolygon_20261012.t.sol), [AaveV3BNB](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261012_Multi_SVRExpansionAvalancheBNBPolygon/AaveV3BNB_SVRExpansionAvalancheBNBPolygon_20261012.t.sol)
- [Snapshot](TODO)
- [Discussion](https://governance.aave.com/t/arfc-svr-expansion-next-phase-of-multi-network-expansion/25332)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
