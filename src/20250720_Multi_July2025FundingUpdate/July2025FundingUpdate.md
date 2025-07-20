---
title: "July 2025 - Funding Update"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/direct-to-aip-july-2025-funding-update/22555"
---

## Simple Summary

This publication presents the July Funding Update, consisting of the following key activities:

- Bridge funds to Ethereum from Arbitrum and Polygon;
- Renew Fluid incentive allocation; // TODO CHECK
- Extend EURe incentive campaign and,
- Swap LUSD, PYUSD and DAI to USDC.
- Gas costs reimbursement to ACI.

## Motivation

This publication combines near term operational needs and migrating assets held on L2s and side chains to Ethereum.

The below outlines the objectives of this publication:

- Consolidating funds to Ethereum; and,
- Support near term operational requirements.

## Specification

### Bridge the following assets to Ethereum.

| Network  | Token  | Amount |
| -------- | ------ | ------ |
| Polygon  | USDT   | All    |
| Polygon  | DAI    | All    |
| Polygon  | USDC.e | All    |
| Polygon  | LINK   | All    |
| Polygon  | wETH   | All    |
| Arbitrum | USDT   | All    |
| Arbitrum | DAI    | All    |
| Arbitrum | USDC.e | All    |

### Swap the following assets as outlined in the table below:

| Token | Amount | Swap |
| ----- | ------ | ---- |
| DAI   | All    | USDS |
| LUSD  | All    | USDC |
| PYUSD | All    | USDC |

## References

- Implementation: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Ethereum_July2025FundingUpdate_20250720.sol), [AaveV3Polygon](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Polygon_July2025FundingUpdate_20250720.sol), [AaveV3Arbitrum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Arbitrum_July2025FundingUpdate_20250720.sol)
- Tests: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Ethereum_July2025FundingUpdate_20250720.t.sol), [AaveV3Polygon](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Polygon_July2025FundingUpdate_20250720.t.sol), [AaveV3Arbitrum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20250720_Multi_July2025FundingUpdate/AaveV3Arbitrum_July2025FundingUpdate_20250720.t.sol)
- Snapshot: Direct-to-AIP
- [Discussion](https://governance.aave.com/t/direct-to-aip-july-2025-funding-update/22555)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
