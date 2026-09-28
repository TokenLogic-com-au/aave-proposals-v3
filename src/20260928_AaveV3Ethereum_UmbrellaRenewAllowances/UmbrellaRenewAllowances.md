---
title: "Umbrella - Renew Allowances"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-umbrella-renew-allowances/25700"
---

## Simple Summary

This AIP resizes the Umbrella reward allowances from the Aave Ethereum Collector to the Umbrella RewardsController to 500,000 aEthUSDT, 475,000 aEthUSDC and 160 aEthWETH, covering accrued unclaimed rewards and emissions through 2 December 2026. GHO is unchanged.

## Motivation

Umbrella reward allowances are due for renewal. As stakers claim rewards, the RewardsController draws on the allowances granted by the Ethereum Collector. Governance periodically renews these allowances to support reward payments, most recently for aEthUSDT and aEthUSDC through AIP 507.

This renewal accounts for rewards accrued by current and former stakers, together with emissions scheduled through 2 December 2026. The Collector holds sufficient balances of the reward assets to fund these payments.

## Specification

### Proposed Allowances

The allowances are sized using unclaimed rewards as of 25 September 2026 and the maximum emissions for the rest of the period, rounded up. The calculation uses each market's `maxEmissionPerSecond` to allow for deposits growing toward Target Liquidity. Current emissions are approximately 80% of that maximum for USDT and USDC, and 84% for WETH.

| Reward asset | Accrued, unclaimed | Emissions to 2 Dec 2026 (max rate) | Total required through 2 Dec 2026 | New allowance |
| ------------ | ------------------ | ---------------------------------- | --------------------------------- | ------------- |
| aEthUSDT     | 259,782            | 238,379                            | 498,162                           | 500,000       |
| aEthUSDC     | 242,001            | 227,194                            | 469,196                           | 475,000       |
| aEthWETH     | 67.26              | 87.53                              | 154.79                            | 160           |

These amounts replace the remaining allowances; they are not additional amounts.

GHO emissions ended with AIP 507. The existing allowance of 52,730 GHO covers the 22,663 GHO still claimable and remains unchanged.

A separate proposal will renew rewards ahead of 2 December 2026. That renewal will also account for any rewards still unclaimed at the time.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260928_AaveV3Ethereum_UmbrellaRenewAllowances/AaveV3Ethereum_UmbrellaRenewAllowances_20260928.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260928_AaveV3Ethereum_UmbrellaRenewAllowances/AaveV3Ethereum_UmbrellaRenewAllowances_20260928.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-umbrella-renew-allowances/25700)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
