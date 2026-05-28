---
title: "[ARFC] TokenLogic Phase II - Extension"
author: "@TokenLogic"
discussions: "https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846"
snapshot: "https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69"
---

## Simple Summary

This AIP extends TokenLogic's engagement with the Aave DAO, recognising TokenLogic as the team responsible for managing Aave's finances and supporting operations across the protocol.

In response to the launch of Aave V4 and the recent restructuring of Aave's service provider landscape, TokenLogic's mandate is broadened to cover finance, GHO development, incentive design, tooling maintenance, V4 feature development, and business development.

Upon implementation, TokenLogic will be responsible for:

- **Finances:** Treasury management, budgeting, KPI monitoring, user acquisition cost analysis, and investor relations.
- **Market Structure:** Capital-efficiency and interest-rate analyses, including Borrow Rate parameter recommendations and incentive campaign design across Aave V3 and V4.
- **GHO Stablecoin:** GSM upgrades for off-chain yield sources (RWAs), cross-chain sGHO, and GHO growth initiatives.
- **Tooling:** Maintain Aave Seatbelt, Aave Robot (Chainlink CRE), bridging, and swap tooling for V3 and V4.
- **Liquidation Engine:** Support Chainlink's SVR rollout, V4 liquidation parameter configuration, and related quantitative analysis.
- **Aave V4:** Research and develop at least one Spoke unlocking new collateral types or enabling cross-network liquidity via CRE, lead the reinvestment feature strategy, and provide operational support.
- **Business Development:** Drive institutional adoption, strategic partnerships, and ecosystem growth.

The compensation structure approved through the ARFC and Snapshot process is:

| Component        |                Amount | Payment Method                        |
| ---------------- | --------------------: | ------------------------------------- |
| Allowance        | 2,000,000 aEthLidoGHO | Additive top-up to existing allowance |
| Streamed payment | 2,500,000 aEthLidoGHO | Linear stream over 12 months          |
| Streamed payment |            5,000 AAVE | Linear stream over 12 months          |

The current `aEthLidoGHO` stream with ID `100072` will be cancelled. The existing KPI program remains unchanged.

## Motivation

This proposal renews TokenLogic's engagement with the Aave DAO following community discussion and Snapshot approval.

The launch of Aave V4, combined with the recent restructuring of Aave's service provider landscape, has materially expanded the scope of work expected from remaining providers. TokenLogic has consistently delivered across treasury management, GHO development, incentive design, analytics, and business development - in many cases beyond its original mandate. With fewer service providers in place, this proposal ensures TokenLogic is resourced to continue delivering across finance, GHO, tooling, V4 development, and business development at the pace Aave's growth requires.

The full scope, rationale, and budget were discussed through the ARFC process and approved by Snapshot. This AIP implements the approved renewal terms.

## Specification

The payload performs the following actions on Ethereum mainnet:

- Cancel the existing `aEthLidoGHO` stream (ID `100072`) on `AaveV3EthereumLido.COLLECTOR`.
- Increase the `aEthLidoGHO` allowance from `AaveV3EthereumLido.COLLECTOR` to the TokenLogic-controlled multisig at `0xAA088dfF3dcF619664094945028d44E779F19894` by `2,000,000`. The top-up is additive: any existing unclaimed allowance is preserved on top of the new amount.
- Create a new `aEthLidoGHO` stream of `2,500,000` over `365 days` to the same recipient, via `CollectorUtils.stream()` on `AaveV3EthereumLido.COLLECTOR`.
- Create a new `AAVE` stream of `5,000` over `365 days` to the same recipient, via `AAVE_ECOSYSTEM_RESERVE_CONTROLLER.createStream()` on `MiscEthereum.ECOSYSTEM_RESERVE`. The stream amount is rounded down to the nearest multiple of the duration to avoid revert in the underlying controller.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526.sol), [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3Ethereum_ARFCTokenLogicPhaseIIExtension_20260526.t.sol), [AaveV3EthereumLido](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20260526_Multi_ARFCTokenLogicPhaseIIExtension/AaveV3EthereumLido_ARFCTokenLogicPhaseIIExtension_20260526.t.sol)
- [Snapshot](https://snapshot.org/#/s:aavedao.eth/proposal/0x6c2814dc5da68698105894f1c450c80aa2296243ff737843cf9e869eecd8fa69)
- [Discussion](https://governance.aave.com/t/arfc-tokenlogic-phase-ii-extension/24846)

## Disclaimer

TokenLogic is an active service provider to the Aave DAO and the beneficiary of the streams and allowance created by this AIP. TokenLogic supports and maintains an independent delegate voting platform within the Aave community. TokenLogic and associated entities have no undisclosed material conflicts of interest at the time of submission.

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
