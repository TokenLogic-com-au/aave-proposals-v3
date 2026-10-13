---
title: "Umbrella - Renew Allowances"
author: "@TokenLogic"
discussions: "<...>"
---

## Simple Summary

<...>

## Motivation

<...>

### Proposed Allowances

<...>

| Reward asset | Accrued, unclaimed | Emissions to <...> (max rate) | Total required through <...> | New allowance |
| ------------ | ------------------ | ----------------------------- | ---------------------------- | ------------- |
| aEthUSDT     | <...>              | <...>                         | <...>                        | <...>         |
| aEthUSDC     | <...>              | <...>                         | <...>                        | <...>         |
| aEthWETH     | <...>              | <...>                         | <...>                        | <...>         |

<...>

## Specification

The AIP will call `approve` on the Aave Ethereum Collector (`0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c`) to set the following allowances for the Umbrella RewardsController (`0x4655Ce3D625a63d30bA704087E52B4C31E38188B`):

| Reward asset | Address                                      | Current allowance | New allowance |
| ------------ | -------------------------------------------- | ----------------- | ------------- |
| aEthUSDT     | `0x23878914EFE38d27C4D67Ab83ed1b93A74D4086a` | <...>             | <...>         |
| aEthUSDC     | `0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c` | <...>             | <...>         |
| aEthWETH     | `0x4d5F47FA6A74757f35C14fD3a6Ef8E3C9BC514E8` | <...>             | <...>         |

Current allowances are shown as of <...>.

## References

- Implementation: [AaveV3Ethereum](...)
- Tests: [AaveV3Ethereum](...)
- Snapshot: Direct-to-AIP
- [Discussion](...)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
