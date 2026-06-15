---
title: "[AIP] TokenLogic Service Provider Renewal"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846"
snapshot: "https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69"
---

## Simple Summary

This proposal renews and expands TokenLogic's mandate as an Aave Service Provider.

Upon approval, TokenLogic is authorised to perform the services set out in the Scope of Work below. This mandate constitutes a governance-approved authorisation for TokenLogic to execute defined operational, analytical, and development responsibilities across the Aave Protocol, including Aave V3 and Aave V4 systems.

## Motivation

TokenLogic has progressively expanded its scope of execution within the Aave ecosystem from treasury operations to responsibilities spanning market structure, incentive systems, GHO infrastructure, protocol tooling, and Aave V4 feature development.

This expansion reflects the increasing integration of TokenLogic into the operational layer of the Aave Protocol, where its work directly supports protocol functioning, parameter configuration, and feature delivery.

This proposal formalises TokenLogic's role as a Service Provider, with clearly defined responsibilities tied to specific Aave system components and upcoming Aave V4 functionality.

## Scope of Work

Upon approval of this proposal, TokenLogic shall be responsible for the design, analysis, implementation, support, and operational maintenance of the following protocol systems and features.

A high-level overview of TokenLogic's responsibilities is shown below:

- **Finances:** Responsible for managing Aave's finances, budget, reporting, KPI monitoring, user acquisition cost monitoring, popular use case analysis and investor relations insights in alignment with key stakeholders.
- **Market Structure:** Provide market structure recommendations; perform capital-efficiency and interest-rate analysis, including recommendations for the Borrow Rate parameter; and design all incentive campaigns across Aave V3 and V4 in collaboration with other Service Providers.
- **GHO Stablecoin:** In conjunction with Aave Labs' oversight, upgrade the GSMs to facilitate allocating to off-chain yield sources such as RWAs, develop cross-chain sGHO, and continue to lead the growth efforts supporting Aave's GHO stablecoin.
- **Tooling:** Provide and maintain tooling, such as Aave Seatbelt, Aave Robot (using Chainlink's CRE), bridging, and swaps, among others, for Aave V3 and V4.
- **Liquidation Engine:** Support Chainlink's SVR rollout and upgrades; contribute quantitative analysis; present recommendations; collaborate with other service providers; and support the configuration of Aave V4 liquidation parameters to balance risk and expand revenue.
- **Aave V4:** Research and develop at least one feature that unlocks a new type of collateral, or that allows liquidity to move between networks using CRE. Responsible for leading efforts to develop the reinvestment feature strategy implementation and provide general operational support with asset onboardings and parameter updates via AIP.
- **Business Development and Growth:** Focusing on driving institutional adoption, strategic partnerships, and ecosystem growth across Aave Protocol.

The full description of the scope is available on the Snapshot pre-approved ARFC and on the Aave Governance Forum, both linked under References.

### Execution and Coordination

TokenLogic shall execute the above scope in coordination with Aave Labs, the primary protocol development team, and in collaboration with other Service Providers, including, but not limited to, Chainlink, LlamaRisk, Certora, and governance contributors.

## Specification

The payload performs the following actions on Ethereum mainnet:

- Cancel the existing `aEthLidoGHO` stream (ID `100072`) on `AaveV3EthereumLido.COLLECTOR`.
- Increase the `aEthLidoGHO` allowance from `AaveV3EthereumLido.COLLECTOR` to the TokenLogic-controlled multisig at `0xAA088dfF3dcF619664094945028d44E779F19894` by `2,000,000`. The top-up is additive: any existing unclaimed allowance is preserved on top of the new amount.
- Create a new `aEthLidoGHO` stream of `2,500,000` over `365 days` to the same recipient, via `CollectorUtils.stream()` on `AaveV3EthereumLido.COLLECTOR`.
- Create a new `AAVE` stream of `5,000` over `365 days` to the same recipient, via `AAVE_ECOSYSTEM_RESERVE_CONTROLLER.createStream()` on `MiscEthereum.ECOSYSTEM_RESERVE`. The stream amount is rounded down to the nearest multiple of the duration to avoid revert in the underlying controller.
- The existing KPI program remains unchanged.

## References

- Implementation: [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension/AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.sol)
- Tests: [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension/AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.t.sol)
- [Snapshot](https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69)
- [Discussion](https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846)

## Disclaimer

TokenLogic is an active service provider to the Aave DAO and the beneficiary of the streams and allowance created by this AIP. TokenLogic supports and maintains an independent delegate voting platform within the Aave community. TokenLogic and associated entities have no undisclosed material conflicts of interest at the time of submission.

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
