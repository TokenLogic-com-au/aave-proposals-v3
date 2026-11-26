---
title: "Mainnet GSM migration"
author: "TokenLogic"
discussions: "TODO"
snapshot: "TODO"
---

## Simple Summary

This publication starts moving the Ethereum USDC and USDT GSMs from Aave V3 to Aave V4. It launches new USDC and USDT GSMs whose underlyings are the Aave V4 Core USDC and USDT TokenizationSpokes (waCoreUSDC and waCoreUSDT).

- **USDC:** the current USDC GSM, backed by stataUSDC, is seized and removed from the GhoReserve and the GsmRegistry.
- **USDT:** the current USDT GSM, backed by stataUSDT, stops minting GHO (USDT → GHO) but keeps redeeming GHO for USDT (GHO → USDT). Its backing stays in place and can only decrease, so a later proposal can migrate a smaller amount.

No funds move into Aave V4 within this proposal. The new GSMs are left ready to use.

## Motivation

A TokenizationSpoke is an ERC-4626 vault over one asset of an Aave V4 Hub. The GSM holds the vault shares as a plain ERC-20 balance and prices them through `FixedPriceStrategy4626`, the same as it does for stataTokens. The existing `Gsm4626` and `FixedPriceStrategy4626` contracts are therefore reused without changes.

The USDC GSM is almost empty, so its GHO usage is repaid from the treasury and it is closed.

The USDT GSM backs about 22.4M GHO with about 18.9M stataUSDT, worth about 22.4M USDT (block 26485342). Moving all of it into the Aave V4 Core Hub at once would sharply lower the Hub's USDT utilisation. Instead, the current USDT GSM's exposure cap is set to zero:

- `sellAsset` (USDT → GHO) requires the exposure after the sale to stay within the cap, so it reverts.
- `buyAsset` (GHO → USDT) does not check the cap, so GHO holders can still redeem USDT.
- The GhoGsmSteward can change an exposure cap by at most 100% of its current value, so it cannot raise the cap from zero. Only governance can reopen minting.

New USDT → GHO demand goes to the new USDT GSM instead.

## Specification

The proposal executes two independent payloads on Ethereum. Their order does not matter.

### 1. Aave V4 payload

Raise the add caps of the Core Hub TokenizationSpokes so that the new GSMs have room for their shares:

| TokenizationSpoke                                                                                                                 | Current add cap | New add cap |
| --------------------------------------------------------------------------------------------------------------------------------- | :-------------: | :---------: |
| Core USDC [`0x531E90a2376902DE8915789Fcc1075e3B0c153E7`](https://etherscan.io/address/0x531E90a2376902DE8915789Fcc1075e3B0c153E7) |       2M        |    100M     |
| Core USDT [`0x5eC44a70F309854fe04d495cFE1B5dA63DD1cc73`](https://etherscan.io/address/0x5eC44a70F309854fe04d495cFE1B5dA63DD1cc73) |       1M        |    100M     |

TODO: re-check the add caps with the risk providers before going live.

### 2. Aave V3 payload

- On the current USDC GSM:
  - Distribute the accrued fees to the treasury.
  - Grant the Executor `LIQUIDATOR_ROLE`, then `seize()`. The stataUSDC dust goes to the Collector.
- On the GhoReserve, add the new GSMs as entities and set their limits.
- On the new GSMs:
  - Set the exposure caps.
  - Grant `SWAP_FREEZER_ROLE` to their OracleSwapFreezers and to the Executor.
  - Grant `CONFIGURATOR_ROLE` to the GhoGsmSteward.
- Add the new GSMs to the GsmRegistry.
- Reuse the fee strategies of the current GSMs on the new GSMs.
- Call `burnAfterSeize()` on the current USDC GSM with GHO from the treasury, to bring its GHO used to zero. The amount is read at execution, and the payload reverts if the treasury holds less GHO than that. The Risk Council must therefore set the current USDC GSM's exposure cap to zero before this proposal is created, so that the amount cannot grow.
- Set the current USDT GSM's exposure cap to zero. This blocks USDT → GHO and keeps GHO → USDT open. The current USDT GSM stays in the GhoReserve (limit unchanged) and in the GsmRegistry, and keeps all its roles.
- Set the current USDC GSM's GhoReserve limit to zero and remove it as an entity. Remove it from the GsmRegistry.
- On the current USDC GSM, revoke the roles of its OracleSwapFreezer, the Executor (swap freezer and liquidator) and the GhoGsmSteward.
- Withdraw to the Collector the LINK left in the current USDC and USDT OracleSwapFreezer keepers. The Chainlink Automation registry owner already cancelled these keepers.

The new GSMs and OracleSwapFreezers are deployed with the Executor as `DEFAULT_ADMIN` and ProxyAdmin owner, so there is no deployer role to revoke.

| Parameter            |           waCoreUSDC GSM            |           waCoreUSDT GSM            |
| -------------------- | :---------------------------------: | :---------------------------------: |
| Address              |                TODO                 |                TODO                 |
| Underlying           | Aave V4 Core USDC TokenizationSpoke | Aave V4 Core USDT TokenizationSpoke |
| Draw Limit (GHO)     |               100.00M               |               100.00M               |
| Exposure Capacity    |               90.00M                |               85.00M                |
| Price Strategy       |           1:1 (ERC-4626)            |           1:1 (ERC-4626)            |
| Freeze Lower Bound   |               $0.990                |               $0.990                |
| Freeze Upper Bound   |               $1.010                |               $1.010                |
| Unfreeze Lower Bound |               $0.995                |               $0.995                |
| Unfreeze Upper Bound |               $1.005                |               $1.005                |
| Mint GHO Fee         |                0.00%                |                0.10%                |
| Burn GHO Fee         |                0.15%                |                0.10%                |

The fee strategies are copied from the current GSMs at execution. The fees above are those of the current GSMs at block 26485342.

The exposure capacity counts waCoreUSDC and waCoreUSDT shares, not underlying. A share is worth more than one unit of underlying and gains value over time: at block 26485342, 90M waCoreUSDC is about 92.4M USDC and 85M waCoreUSDT is about 86.8M USDT.

TODO: re-check exposure caps and draw limits with the risk providers before going live.

### Known limitations

- **Keepers:** Chainlink disabled automatic approval on the Automation registrar used by the Aave robot operator, so the payload does not register keepers for the new OracleSwapFreezers. The freezers hold `SWAP_FREEZER_ROLE` and their `performUpkeep` is permissionless. A keeper must be set up outside this proposal. The current GSMs' keepers have been cancelled since 2026-05-01.
- **Unfreezing:** the freezers are allowed to unfreeze. A keeper therefore reverses a manual freeze (for example after an Aave V4 Hub halt or bad debt) whenever the stablecoin price is within the unfreeze bounds.
- **V4 bad debt:** a TokenizationSpoke share keeps its quoted value when the Hub records bad debt (deficit), so the GSM does not see the loss. A bad-debt policy is needed.
- **Halted or deactivated TokenizationSpoke:** when the Hub halts or deactivates a TokenizationSpoke, its deposits and withdrawals revert, but its shares remain transferable. The GSM does not check the spoke's state, so it keeps buying the shares at their full quoted value. Holders who cannot redeem on Aave V4 can then sell their shares to the GSM for GHO, up to the GSM's remaining exposure capacity and draw limit. GHO becomes their exit route, and the GSM is left holding shares that cannot be redeemed. The OracleSwapFreezer only watches the stablecoin price, so it does not react. Only the Executor holds `SWAP_FREEZER_ROLE` besides the freezer, so a manual freeze needs a governance proposal, and the freezer can reverse it (see **Unfreezing**). A faster way to freeze is needed, for example a guardian with `SWAP_FREEZER_ROLE` or a freezer that also checks the spoke's state.
- **Hub liquidity:** a user who buys waCoreUSDC or waCoreUSDT from a GSM can redeem it only while the V4 Core Hub has free liquidity.
- **USDT drain pace:** the current USDT GSM's stataUSDT can only decrease, but it only decreases when users redeem GHO for USDT. That happens mostly when GHO trades below peg, so the backing can stay in place for a long time. Closing the current USDT GSM needs a future proposal (seize, migrate the remaining backing, `burnAfterSeize`).
- **Integrations:** routers that mint GHO through the current USDT GSM will see `sellAsset` revert with `EXOGENOUS_ASSET_EXPOSURE_TOO_HIGH`. `getAvailableUnderlyingExposure()` returns zero.
- **Two USDT GSMs:** moving liquidity from the current USDT GSM to the new one (buy stataUSDT, redeem on Aave V3, deposit into Aave V4, sell to the new GSM) pays the burn fee of the current GSM and the mint fee of the new one. If both fees were set to zero, this route would let anyone move the whole backing into Aave V4 at no cost.

## References

- Implementation: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV3Ethereum_MainnetGSMMigration_20261022.sol), [AaveV4Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV4Ethereum_MainnetGSMMigration_20261022.sol)
- Tests: [AaveV3Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV3Ethereum_MainnetGSMMigration_20261022.t.sol), [AaveV4Ethereum](https://github.com/aave-dao/aave-proposals-v3/blob/main/src/20261022_Multi_MainnetGSMMigration/AaveV4Ethereum_MainnetGSMMigration_20261022.t.sol)
- [Snapshot](TODO)
- [Discussion](TODO)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
