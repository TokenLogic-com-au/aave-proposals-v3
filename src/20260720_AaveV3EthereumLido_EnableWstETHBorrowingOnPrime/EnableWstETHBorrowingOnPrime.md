---
title: "Enable wstETH Borrowing on Prime"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-aave-v3-ltv-and-e-mode-update/25067"
---

## Simple Summary

This AIP re-enables wstETH borrowing on the Aave V3 Ethereum Prime instance, completing the borrow cap restoration approved in the [Aave V3 LTV and E-Mode Update](https://github.com/aave-dao/aave-proposals-v3/tree/main/src/20260707_Multi_AaveV3LTVAndEModeUpdate) proposal.

## Motivation

Following the oracle misconfiguration incident, wstETH borrowing on Prime was suspended: the borrow cap was reduced to 1 and the reserve's borrowing flag was disabled (previously enabled with a 280,000 cap). The Aave V3 LTV and E-Mode Update proposal restores the borrow cap to 18,000 as recommended by LlamaRisk, but does not re-enable the borrowing flag, so wstETH would remain non-borrowable after its execution. This AIP re-enables the flag.

## Specification

| Instance       | Asset  | Parameter       | Current  | New     |
| -------------- | ------ | --------------- | -------- | ------- |
| Ethereum Prime | wstETH | enabledToBorrow | DISABLED | ENABLED |

The borrow cap is not modified by this payload; it is restored from 1 to 18,000 by the Aave V3 LTV and E-Mode Update AIP.

## References

- Implementation: [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260720_AaveV3EthereumLido_EnableWstETHBorrowingOnPrime/AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720.sol)
- Tests: [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260720_AaveV3EthereumLido_EnableWstETHBorrowingOnPrime/AaveV3EthereumLido_EnableWstETHBorrowingOnPrime_20260720.t.sol)
- [Discussion](https://governance.aave.com/t/direct-to-aip-aave-v3-ltv-and-e-mode-update/25067)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
