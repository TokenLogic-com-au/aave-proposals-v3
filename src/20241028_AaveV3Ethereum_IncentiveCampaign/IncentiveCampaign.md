---
title: "Incentive Campaign"
author: "karpatkey_TokenLogic"
discussions: "https://governance.aave.com/t/arfc-pyusd-reserve-configuration-update-incentive-campaign/19573"
snapshot: "https://snapshot.org/#/aave.eth/proposal/0xcd73f17361c7757cd94ec758b4d9f160b7cecefa7f4cb23b0b4ee49b5eb1b8b2"
---

## Simple Summary

This publication proposes amendments to the PYUSD Reserve in preparation for an upcoming incentive campaign.

Additionally, a co-incentive campaign is to be implemented to improve the PYUSD and GHO liquidity.

## Motivation

Trident Digital with support from PayPal, presents the Aave DAO with an opportunity to promote the adoption of PYUSD on Aave Protocol and PYUSD/GHO liquidity on Balancer for an initial 6 month period.

Eligible Aave Protocol users are expected to receive up to 4.00% APR in Liquidity Mining (LM) rewards made available by Trident Digital on behalf of PayPal.

The incentive program seeks to increase PYUSD deposits into Aave Protocol, targeting total deposits of 75M units. After achieving 75M units of aEthPYUSD circulating supply, the rewards budget is to be distributed pro-rata.

To prevent undesired rewards farming, an eligibility requirement is to be applied to discourage undesired behaviour.

Rewards are to be distributed as aEthPYUSD on a monthly basis via a merkle contract administered by the ACI team.

### PYUSD Rewards

PYUSD rewards are to be distributed at a fixed rate of 4.00% to eligible user on Aave v3 on Ethereum up to a threshold of 75M aEthPYUSD. After this threshold is achieved, rewards are to be distributed pro-rata to eligible users.

Eligible users can expect to earn the following rewards:

- Deposit Yield from Aave Protocol
- Additional 4.00% of [aEthPYUSD](https://etherscan.io/address/0x0C0d01AbF3e6aDfcA0989eBbA9d6e85dD58EaB1E)

Users actions are tracked with users to receive 4.00% APR x `Eligible Holding`

_Note: This incentive program differs from others projects that measure Net PYUSD (deposits - debt) by inclusion of all aEthPYUSD in circulating supply._

**Eligibility Criteria**

Users are subject to the following eligibility criteria:

`Eligible Holding` = `PYUSD aToken Holding` - `Undesired Debt Token Holding` / `PYUSD Liquidation Threshold`

Undesired Debt Token(s):

- variableDebtEthPYUSD

Users who hold both the [aEthPYUSD](https://etherscan.io/address/0x0C0d01AbF3e6aDfcA0989eBbA9d6e85dD58EaB1E) deposit receipt token and the [variableDebtEthPYUSD](https://etherscan.io/address/0x57B67e4DE077085Fd0AF2174e9c14871BE664546) will be adversley affected as determine by the formula shown above.

Upon launch of the program, the only `Undesired Debt Token Holding` is the PYUSD variable debt token.

**Rewards Amendments**

Trident Digital and PayPal reserve the right to amend the list of Undesired Debt Token(s). If any change is made, a comment will be shared below in the comments section informing users of the amendment to the rewards program.

Updates can only be made during the last week of each calendar month and are effective from the start of the following month.

**Distribution of Rewards**

During the first week of each new month, the ACI team will distribute [aEthPYUSD](https://etherscan.io/address/0x0C0d01AbF3e6aDfcA0989eBbA9d6e85dD58EaB1E) rewards via a Merkle contract. This approach follows the same rational as the Merit program.

**PYUSD Reserve Parameter Adjustments**

To streamline communication, any risk or borrow rate parameter adjustment affecting the PYUSD reserve are to be agreed ahead of any change being implemented. Trident Digital is to represent PayPal's interest in providing the incentive budget.

Aave DAO's Risk Service Providers remain the ultimate decision maker(s) as to if the DAO supports any proposed amendment.

### PYUSD/GHO Liquidity

As part of the PYUSD growth iniative, a 8M PYUSD/GHO Elliptic Liquidity Pool (ECLP) with an asymmetric concentrated liquidity profile will be used on Balancer.

The pool will be funded and supported for an initial 6 month period.

**Budget**

The 8M of liquidity is expected to cost ~14% APR. This cost is to be split 50/50 with the Aave DAO to provide up to 300k GHO.

Early discussions with prospective Liquidity Provider(s) (LP) has indicated a preference for direct payment outside of the Balancer and Aura Gauges. Some prospective LPs are considering holding GHO debt whilst providing liquidity. If this was to occur the net cost to Aave DAO would be less than otherwise.

This proposal requests an additional 300k GHO be made available to the ALC and for payments to be made directly to LP(s).

### Key Performance Indicator

This proposal intends to attract PYUSD deposits on Aave Protocol, measured by aEthPYUSD circulating supply.

**Aave Protocol Phase I**

| Detail        |                        Amount                        |
| ------------- | :--------------------------------------------------: |
| Target        |              75M aEthPYUSD Circ. Supply              |
| Rewards       |                      aEthPYUSD                       |
| Emission Rate |      4% APR, when 0 < aEthPYUSD Circ. Sup.< 75M      |
| Emission Rate | 250k/month pro-rata, when aEthPYUSD Circ. Sup. >75M, |
| Duration      |                       6 months                       |

Note: 75M x 4.00% is equivalent to 250k monthly budget.

**PYUSD/GHO Liquidity Phase I**

| Detail    |                 Amount                 |
| --------- | :------------------------------------: |
| Target    |                 8M USD                 |
| DEX       |                Balancer                |
| Pool Type |           ECLP by Gyroscope            |
| Rewards   | Direct payment nominated GHO and PYUSD |

## Specification

The following PYUSD Reserve parameters are to be updated:

| Parameter                | PYUSD  |
| ------------------------ | ------ |
| Borrowable               | Yes    |
| Collateral               | Yes    |
| Borrow Cap               | 15M    |
| LTV                      | 75.00% |
| LT                       | 78.00% |
| Liquidation Penalty      | 7.50%  |
| Liquidation Protocol Fee | 10.00% |

Create 300k GHO Allowance for the ALC SAFE.

ALC SAFE: `0xA1c93D2687f7014Aaf588c764E3Ce80aF016229b`
GHO: `0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f`

Whilst not expected to be needed, in case aEthPYUSD Liquidity Mining rewards are to be distributed across Aave v3, the ACI is to be granted sufficient permission to do so.

EMISSION_MANAGER.setEmissionAdmin(`aEthPYUSD`,`ACI Treasury`)

aEthPYUSD: `0x0C0d01AbF3e6aDfcA0989eBbA9d6e85dD58EaB1E`
ACI Treasury: `0xac140648435d03f784879cd789130F22Ef588Fcd`

## References

- Implementation: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20241028_AaveV3Ethereum_IncentiveCampaign/AaveV3Ethereum_IncentiveCampaign_20241028.sol)
- Tests: [AaveV3Ethereum](https://github.com/bgd-labs/aave-proposals-v3/blob/main/src/20241028_AaveV3Ethereum_IncentiveCampaign/AaveV3Ethereum_IncentiveCampaign_20241028.t.sol)
- [Snapshot](https://snapshot.org/#/aave.eth/proposal/0xcd73f17361c7757cd94ec758b4d9f160b7cecefa7f4cb23b0b4ee49b5eb1b8b2)
- [Discussion](https://governance.aave.com/t/arfc-pyusd-reserve-configuration-update-incentive-campaign/19573)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
