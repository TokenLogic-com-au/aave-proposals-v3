---
title: "Mainnet GSM migration"
author: "TokenLogic"
discussions: "TODO"
snapshot: "TODO"
---

## Simple Summary

This publication moves the Ethereum USDC GSM from Aave V3 to Aave V4. It launches a new USDC GSM whose underlying is the Aave V4 Core USDC TokenizationSpoke (waCoreUSDC), and closes the current USDC GSM, backed by stataUSDC: it is seized and removed from the GhoReserve and the GsmRegistry.

No funds move into Aave V4 within this proposal. The new GSM is left ready to use. The USDT GSM is not changed.

## Motivation

A TokenizationSpoke is an ERC-4626 vault over one asset of an Aave V4 Hub. The GSM holds the vault shares as a plain ERC-20 balance and prices them through `FixedPriceStrategy4626`, the same as it does for stataTokens. The existing `Gsm4626` and `FixedPriceStrategy4626` contracts are therefore reused without changes.

The current USDC GSM is almost empty, so its GHO usage is repaid from the treasury and it is closed.

## Specification

The proposal executes two independent payloads on Ethereum. Their order does not matter.

### 1. Aave V4 payload

Raise the add cap of the Core Hub USDC TokenizationSpoke so that the new GSM has room for its shares:

| TokenizationSpoke                                                                                                                 | Current add cap | New add cap |
| --------------------------------------------------------------------------------------------------------------------------------- | :-------------: | :---------: |
| Core USDC [`0x531E90a2376902DE8915789Fcc1075e3B0c153E7`](https://etherscan.io/address/0x531E90a2376902DE8915789Fcc1075e3B0c153E7) |       2M        |    100M     |

TODO: re-check the add cap with the risk providers before going live.

### 2. Aave V3 payload

- On the current USDC GSM:
  - Distribute the accrued fees to the treasury.
  - Grant the Executor `LIQUIDATOR_ROLE`, then `seize()`. The stataUSDC dust goes to the Collector.
- On the GhoReserve, add the new GSM as an entity and set its limit.
- On the new GSM:
  - Set the exposure cap.
  - Grant `SWAP_FREEZER_ROLE` to its OracleSwapFreezer and to the Executor.
  - Grant `CONFIGURATOR_ROLE` to the GhoGsmSteward.
- Add the new GSM to the GsmRegistry.
- Reuse the fee strategy of the current USDC GSM on the new GSM.
- Call `burnAfterSeize()` on the current USDC GSM with GHO from the treasury, to bring its GHO used to zero. The amount is read at execution, and the payload reverts if the treasury holds less GHO than that. The Risk Council must therefore set the current USDC GSM's exposure cap to zero before this proposal is created, so that the amount cannot grow.
- Set the current USDC GSM's GhoReserve limit to zero and remove it as an entity. Remove it from the GsmRegistry.
- On the current USDC GSM, revoke the roles of its OracleSwapFreezer, the Executor (swap freezer and liquidator) and the GhoGsmSteward.
- Withdraw to the Collector the LINK left in the current USDC OracleSwapFreezer keeper. The Chainlink Automation registry owner already cancelled this keeper.

The new GSM and OracleSwapFreezer are deployed with the Executor as `DEFAULT_ADMIN` and ProxyAdmin owner, so there is no deployer role to revoke.

| Parameter            |                                                     waCoreUSDC GSM                                                      |
| -------------------- | :---------------------------------------------------------------------------------------------------------------------: |
| Address              | [`0x382b8431B4b141A7420F0E01229B005309246fEe`](https://etherscan.io/address/0x382b8431B4b141A7420F0E01229B005309246fEe) |
| OracleSwapFreezer    | [`0x20621b503918Fc293ddaeb1A7CcDB93881939289`](https://etherscan.io/address/0x20621b503918Fc293ddaeb1A7CcDB93881939289) |
| Underlying           |                                           Aave V4 Core USDC TokenizationSpoke                                           |
| Draw Limit (GHO)     |                                                         100.00M                                                         |
| Exposure Capacity    |                                                         90.00M                                                          |
| Price Strategy       |                                                     1:1 (ERC-4626)                                                      |
| Freeze Lower Bound   |                                                         $0.990                                                          |
| Freeze Upper Bound   |                                                         $1.010                                                          |
| Unfreeze Lower Bound |                                                         $0.995                                                          |
| Unfreeze Upper Bound |                                                         $1.005                                                          |
| Mint GHO Fee         |                                                          0.00%                                                          |
| Burn GHO Fee         |                                                          0.15%                                                          |

The fee strategy is copied from the current USDC GSM at execution. The fees above are those of the current USDC GSM at block 26494707.

The exposure capacity counts waCoreUSDC shares, not USDC. A share is worth more than one USDC and gains value over time: at block 26494707, 90M waCoreUSDC is about 92.4M USDC.

TODO: re-check the exposure cap and draw limit with the risk providers before going live.

### Known limitations

- **Keepers:** Chainlink disabled automatic approval on the Automation registrar used by the Aave robot operator, so the payload does not register a keeper for the new OracleSwapFreezer. The freezer holds `SWAP_FREEZER_ROLE` and its `performUpkeep` is permissionless. A keeper must be set up outside this proposal. The current USDC GSM keeper has been cancelled since 2026-05-01.
- **Unfreezing:** the freezer is allowed to unfreeze. A keeper therefore reverses a manual freeze (for example after an Aave V4 Hub halt or bad debt) whenever the stablecoin price is within the unfreeze bounds.
- **V4 bad debt:** a TokenizationSpoke share keeps its quoted value when the Hub records bad debt (deficit), so the GSM does not see the loss. A bad-debt policy is needed.
- **Halted or deactivated TokenizationSpoke:** when the Hub halts or deactivates a TokenizationSpoke, its deposits and withdrawals revert, but its shares remain transferable. The GSM does not check the spoke's state, so it keeps buying the shares at their full quoted value. Holders who cannot redeem on Aave V4 can then sell their shares to the GSM for GHO, up to the GSM's remaining exposure capacity and draw limit. GHO becomes their exit route, and the GSM is left holding shares that cannot be redeemed. The OracleSwapFreezer only watches the stablecoin price, so it does not react. Only the Executor holds `SWAP_FREEZER_ROLE` besides the freezer, so a manual freeze needs a governance proposal, and the freezer can reverse it (see **Unfreezing**). A faster way to freeze is needed, for example a guardian with `SWAP_FREEZER_ROLE` or a freezer that also checks the spoke's state.
- **Hub liquidity:** a user who buys waCoreUSDC from the GSM can redeem it only while the V4 Core Hub has free liquidity.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV3Ethereum_MainnetGSMMigration_20261022.sol), [AaveV4Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV4Ethereum_MainnetGSMMigration_20261022.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV3Ethereum_MainnetGSMMigration_20261022.t.sol), [AaveV4Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV4Ethereum_MainnetGSMMigration_20261022.t.sol)
- [Snapshot](TODO)
- [Discussion](TODO)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
