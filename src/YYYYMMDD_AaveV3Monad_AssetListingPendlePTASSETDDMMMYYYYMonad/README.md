# Pendle PT rollover skeleton

Template for listing a new maturity of a Pendle PT that is already listed (a rollover). A rollover is a new listing: Direct-to-AIP, a new oracle deployment, a new dedicated eMode. The expiring PT is left unchanged through maturity.

Based on the final tree of aave-dao/aave-proposals-v3#1210 (PT-AUSD-17DEC2026, Monad). Every per-maturity value is a placeholder: zero addresses, `0` numbers, `<...>` text, `YYYYMMDD` / `DDMMMYYYY` / `ASSET` in names. Placeholders are chosen to fail a test, not to pass review.

Copy the folder to `src/<YYYYMMDD>_AaveV3<Network>_AssetListingPendlePT<ASSET><DDMMMYYYY><Network>/`, delete this README, and rename every `YYYYMMDD`, `ASSET` and `DDMMMYYYY` in file names, contract names and constants.

## Values to fill, in order

1. Forum post (Direct-to-AIP) with the final parameters and the seed amount. Put the live thread URL (`https://governance.aave.com/t/<slug>/<id>`, no post number, no `?u=`) in `config.ts` `discussion`, the payload header, the `.md` frontmatter `discussions:` and References.
2. Asset: PT token, Pendle market, SY, YT, underlying, maturity (`config.ts` `asset` and `assetSymbol`, the `.sol` `PT_ASSET_DDMMMYYYY` constant, the test `_expectedListings`, the `.md` specification table). Network: swap `AaveV3Monad` / `MonadScript` / `buildMonadPayload` / `AaveV3PayloadMonad` everywhere if not Monad.
3. Oracle: deploy the PT linear discount adapter, then set `priceFeed` (`config.ts`), `PT_ASSET_DDMMMYYYY_PRICE_FEED` (`.sol`), `priceFeed` in `_expectedListings`, the `.md` oracle rows. In `test_priceFeedReturnsSanePrice` set `discountRatePerYear`, `MAX_DISCOUNT_RATE_PER_YEAR`, `MATURITY` (unix) and the underlying's address-book constants (`AUSD_UNDERLYING`, `AUSD_ORACLE` are the PT-AUSD example).
4. Caps and seed: `supplyCap` (`config.ts`, `.sol`, `_expectedListings`, `.md`), `PT_ASSET_DDMMMYYYY_SEED_AMOUNT` (`100e6` for 6 decimals) and `decimals`. Reserve factor, rates and flash-loan flags are the #1210 defaults; change only if the forum post does.
5. eMode: `ltv`, `liqThreshold`, `liqBonus`, `isolated`, label `PT_<SYM>__Stablecoins`, borrowable list (`config.ts`, `eModeCategoryCreations()`, `test_eModeConfiguration`, `.md` eMode table). The borrowables shown are the PT-AUSD example.
6. `.md`: title, summary, motivation (old maturity, new maturity, old PT stays listed), dates, rates, tables, implementation and test links (commit hash). Frontmatter carries no `snapshot:` line; References carries `Snapshot: Direct-to-AIP` as text.
7. `.s.sol`: only paths and contract names; the voting portal is `VOTING_PORTAL_ETH_AVAX` (voting network AVALANCHE).
8. Fork block last: the seed must already be at the executor, and the block must be after any oracle redeploy. Set it in `config.ts` `cache.blockNumber` and in the test `setUp()`. Any later bump needs a fresh diff report.

## Tests

The test file keeps the PT oracle asserts (`discountRatePerYear`, `MAX_DISCOUNT_RATE_PER_YEAR`, `MATURITY`, `PENDLE_PRINCIPAL_TOKEN`, `ASSET_TO_USD_AGGREGATOR`, PT price below the underlying's) and the borrow-outside-eMode revert (`Errors.LtvValidationFailed`).

For Monad, move the commented `forge-config` lines (`default.networks.network = "monad"`, `default.hardfork = "monad:MonadTen"`) into the NatSpec block above the contract. Run on a Foundry nightly with the foundry-rs/foundry#17165 fix, or locally with `FOUNDRY_PROFILE=test forge test --network monad --match-path=<dir>/*.t.sol -vv`.

## Before pushing

`pnpm lint`. The generated `diffs/` report is not part of the skeleton; `defaultTest()` writes it at the final fork block.
