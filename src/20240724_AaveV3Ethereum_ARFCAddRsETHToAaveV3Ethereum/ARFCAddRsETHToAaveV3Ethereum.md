---
title: "[ARFC] Add rsETH to Aave V3 Ethereum"
author: "Karpatkey_Tokenlogic"
discussions: "https://governance.aave.com/t/arfc-add-rseth-to-aave-v3-ethereum/17696"
---

## Simple Summary

This AIP when implemented will onboard Kelp DAO's rsETH Liquid Re-staking Token (LRT) onto the Aave v3 Ethereum deployment as collateral.

## Motivation

[KelpDAO](https://www.kelpdao.xyz/restake/) is one of the largest liquid restaking protocol built on top of the Eigen Layer. Restakers on Kelp get access to multiple benefits like re-staking rewards, staking rewards and DeFi yields.

KelpDAO has undergone multiple security audits by top tier audit firms including Sigma Prime and Code4rena. More about KelpDAO’s security here: [Kelp DAO Audit reports](https://kelp.gitbook.io/kelp/audits)

The motivation for this proposal is to offer users a diverse range of LRTs as collateral on the Aave Protocol.

## Specification

The table below illustrates the configured risk parameters for **rsETH**:

| Parameter                          |  Value   |
| ---------------------------------- | :------: |
| Isolation Mode                     |  false   |
| Borrowable                         | ENABLED  |
| Collateral Enabled                 |   true   |
| Supply Cap (rsETH)                 |  8,000   |
| Borrow Cap (rsETH)                 |   800    |
| Debt Ceiling                       |  USD 0   |
| LTV                                |  72.5%   |
| LT                                 |  75.0%   |
| Liquidation Bonus                  |   7.5%   |
| Liquidation Protocol Fee           |   10%    |
| Reserve Factor                     |   15%    |
| Base Variable Borrow Rate          |    0%    |
| Variable Slope 1                   |    7%    |
| Variable Slope 2                   |   300%   |
| Uoptimal                           |   45%    |
| Stable Borrowing                   | DISABLED |
| Stable Slope1                      |    0%    |
| Stable Slope2                      |    0%    |
| Base Stable Rate Offset            |    0%    |
| Stable Rate Excess Offset          |    0%    |
| Optimal Stable To Total Debt Ratio |    0%    |
| Flashloanable                      | ENABLED  |
| Siloed Borrowing                   | DISABLED |
| Borrowable in Isolation            | DISABLED |
| E-Mode Category                    |   NONE   |
| Oracle                             |   TBD    |

## References

- Implementation: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20240724_AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum/AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724.sol)
- Tests: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20240724_AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum/AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724.t.sol)
- [Snapshot](TODO)
- [Discussion](https://governance.aave.com/t/arfc-add-rseth-to-aave-v3-ethereum/17696)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
