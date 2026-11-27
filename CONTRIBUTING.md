# Contributing a proposal

This file lists the conventions that reviewers check on proposal PRs. Apply them before you ask for a review. Most rules come from comments that maintainers repeated across earlier PRs.

For tooling, read the [README](./README.md), the [Generator Guide](./generator/README.md), the [Testing Guide](./docs/TESTING_GUIDE.md) and the [Glossary](./docs/GLOSSARY.md). The [PR template](./.github/PULL_REQUEST_TEMPLATE.md) has the short checklist. This file explains each checklist item and adds the rules that the checklist does not cover.

The section "Open decisions" at the end lists the points where maintainers asked for opposite things. Each one shows the rule this file uses until the maintainers decide.

## 1. Workflow and tooling

- Merge or rebase the latest `main` before you ask for a review. Then run `forge install` and `pnpm install`, and run the tests again. A red CI blocks the review.
- Run `pnpm lint:fix` and commit the result. CI runs `pnpm lint`.
- Run the tests of your proposal with `FOUNDRY_PROFILE=test make test-contract filter=<ContractName>`. CI uses the `test` profile too. For zkSync, use the command that the generator writes in the test file. All tests must pass.
- Do not add a git submodule or a package dependency for a proposal. Copy the interfaces that you need into `src/interfaces`.
- Keep `lib/aave-helpers`, `lib/aave-address-book` and `foundry.lock` at the latest pinned commit. Never move a submodule to an older commit. If your proposal needs a change in a dependency, merge that change first, and then bump the submodule here.
- If a diff report shows raw event topics, add the events of that contract to the aave-helpers events database. Then bump the package and generate the diff again before the merge.
- Commit only the files of your proposal. Do not commit editor backups, `package-lock.json`, script output, or changes to other proposals.
- Import through the remappings, for example `aave-v3-origin/...` and `aave-helpers/src/...`. Do not import through deep `lib/...` paths.
- Resolve every TODO, TBD and placeholder in code and text before you ask for a review.
- Remove unused imports, constants, variables, interfaces, functions and calls that change nothing.

## 2. Generator and config.ts

- Create the proposal with `pnpm generate`. Do not copy an old proposal folder.
- Keep `config.ts` in the proposal folder. It is the source of truth.
- After you change an input, generate again with `pnpm generate -- -c <path>/config.ts`.
- If the generator has a gap, fix the generator in a separate PR. If you must change a generated file by hand until that fix merges, name each manual change in the PR description.
- Keep `config.ts` equal to the final specification. It lists only the pools and chains that the payload changes. Fill every field. Use `votingNetwork: AVALANCHE`.
- Compare the generated tables in the AIP text with the payload. The generator can print wrong defaults, for example for isolation mode or collateral. Remove generated sections that do not apply.
- Use the features of the generator and of the config engine before you write a raw `POOL_CONFIGURATOR` call in a hook. Do not set the same value twice.
- `config.ts` uses the key `discussion`. The front matter of the AIP text uses the key `discussions`. This difference is by design.

Changes to the generator itself go in their own PR, not in a proposal PR. Such a PR updates the generator README and tests. The generator must not use silent defaults for risk parameters. It must throw on an unknown value. Generated Solidity must compile for every market type, zkSync and Aave V4 included.

## 3. Naming

- The `shortName` in `config.ts` sets the folder, file and contract names. Choose it once. Do not rename the generated files by hand.
- Write `shortName` in PascalCase with readable words, for example `OnboardUSATCoreHub`.
- Write acronyms in uppercase in proposal names, for example `GHO`, `GSM`, `ETH`, `CCIP`, `CAPO`, `USDC` and `LTV`. Write `EMode`, not `Emode`. Most merged proposals already use this style.
- A name that copies an upstream contract keeps the upstream spelling, for example `IGhoToken` and `IGsm`.
- Give each file the name of the contract in it.
- If a proposal has more than one part, use the suffix `_Part1`, `_Part2`.
- Use the token symbol from the address book exactly, for example `wPOL`, `USDT0` or a PT symbol.
- Give constants, helpers, tests and variables names that say what they hold or do. Start the name of an internal helper with `_` and a verb, for example `_setCaps`.
- When you rename a token or a contract, rename every constant, test and file that depends on it.
- Name an eMode label `<collaterals>__<borrowables>`. Join the assets on each side with `_`. Use `Stablecoins` when the borrowable side is a group of stablecoins, for example `USDe__Stablecoins`. Do not put the word "emode" in the label. Use the same label in `config.ts`, the payload, the AIP text and the diff.

## 4. Where code goes

- Put the payloads, tests and scripts of a proposal in its proposal folder. Put the tests next to the payload.
- Put interfaces in `src/interfaces`, never inline in a payload or a test. Look for an existing interface first. If you trim or adapt an upstream interface, say in its NatSpec where it comes from.
- Reuse what exists. The address book, aave-helpers and aave-v3-origin already have many interfaces, structs, libraries and helpers.
- Do not copy code between payloads. If more than one proposal needs a helper, put it in an existing shared helper or base contract, and extend that file before you add a new one.
- If payloads on different chains differ only in constants, write one base payload and one base test. Each chain then overrides the constants.
- Keep values and helpers that only tests use in the test files, not in a production constants library.
- Do not commit payloads, scripts or diffs for a network or an asset that the proposal does not change. When the scope gets smaller, delete the files that you do not need.

## 5. Payload code

### Values

- Check every value in the payload against the final forum post, the latest post of the risk provider and the Snapshot vote. This includes caps, rates, LTV, liquidation threshold and bonus, flags, fees, amounts, recipients and networks. If the sources do not agree, ask the author of the proposal before you write code.
- Read the live on-chain state on every network before you write a change. Remove updates that change nothing.
- If a call needs a precondition, add the call that sets it in the payload. Do not rely on a state that someone sets outside the payload.
- Use `EngineFlags.KEEP_CURRENT` for every field that the proposal does not change. Delete an update in which all fields are `KEEP_CURRENT`.
- Cover every network and instance that the proposal affects. If you leave one out, say why in the AIP text.
- A borrow cap of 0 means no limit. Use 1 when borrowing is disabled. Keep the debt ceiling at 0 unless the asset goes into isolation mode.
- For an asset that cannot be borrowed, still set non-zero interest rate parameters and a reserve factor. They protect the reserve if borrowing is enabled later.
- Follow the latest merged proposal of the same type for the feed type, label, symbol format, structure and seed.
- Use the price feed that the risk post names, and use the same address everywhere. Correlated assets use a CAPO adapter. Where Chainlink has an SVR feed, use it.
- For a swap, use the market USD feed of the asset. Do not use a capped feed, a fixed $1 feed or a feed in ETH.

### Structure

- Payloads run through `delegatecall`. A payload has constants only and no storage.
- Deploy and verify the contracts that the AIP needs before the AIP. The payload uses their addresses. A payload never deploys a copy of such a contract.
- Steps on other chains go in separate payloads of one AIP. For steps on one chain, see "Open decisions". Enforce the order of the payloads and test it.
- Put cancellations and removals before new grants. Put the hooks in the order in which they run.
- When you replace a steward, a controller or a contract, revoke every role of the old one in the same payload.
- Keep `execute()` easy to read. Use structs with named fields, not parallel arrays. Do not add empty functions or wrappers that only make one call. For other internal helpers, see "Open decisions".

### Token amounts

- Take token amounts from live balances with `balanceOf`. For aTokens you can use `type(uint256).max`. Never use `scaledBalanceOf`.
- Allow for rounding and for interest that accrues before execution. Check that the pool has the liquidity for a withdrawal. Leave a margin on the Collector.
- When you renew an allowance, add the new amount to the current allowance, and include pending claims. Use `forceApprove`. Do not approve 0 first, because the Collector already does a force approve. Do not transfer an amount of 0.
- For a stream, start at `block.timestamp`. Get the end and the rate from named constants. Make the amount an exact multiple of the duration. When you cancel a stream, include its unclaimed balance.

### Seeds for new listings

- Send the seed to `DUST_BIN`, not to the Collector, the executor or `address(0)`. Assert the `DUST_BIN` balance in the tests.
- Use 100 units for an asset with 6 decimals and 1 unit for an asset with 18 decimals. Ask the reviewers for a high-value asset such as BTC.
- Fund the executor before the AIP, and pin the fork block after that funding. Use `deal` in `setUp` only as a temporary measure.

## 6. Constants and the address book

- Take every address and ID from the address book. This includes assets, oracles, Chainlink feeds, executors, stewards, the Collector and eMode IDs. If the address book does not have a value, add it there and bump the address book.
- Read role IDs from the contract getter or the `Roles` library, for example `COLLECTOR.FUNDS_ADMIN()`. Do not write a `keccak256` literal.
- Give addresses, and values used more than once or asserted in tests, a name. Put the named constants at the top of the contract. For a value used once, see "Open decisions". Keep one source for each value. Do not copy a value that the address book or a shared library already has.
- If payloads on more than one chain share a constant, put it in one library.
- Write numbers with underscores, for example `1_000_000`, and basis points as `100_00`. Use the exponent form, for example `0.65e18`, and time units, for example `90 days`.
- Use the real decimals of the token. Use `ether` only for amounts in ETH.
- Write addresses with an EIP-55 checksum. Check each hard-coded address on the block explorer of its chain and against the forum post.

## 7. NatSpec and comments

- The payload header has `@title`, `@author`, and the Snapshot and discussion links. These values are the same as in the front matter of the AIP text.
- Use `@dev` for a key technical point only, for example an execution precondition, an allowance or an intended zero value. Keep it short. Put other explanations in the PR description.
- Add a comment with the block explorer link above each hard-coded address.
- A comment must be true. Fix chain names and numbers that you copied from another proposal. Delete commented-out code, placeholder comments, console logs and comments that a change made wrong.
- A test helper contract has `@title`, `@author` and `@notice`. Each of its functions has `@notice`, `@param` and `@return`.
- Make the command lines in the NatSpec of scripts and tests correct. Check the path, the chain ID and the profile. Keep the profile that the generator writes. This is `test` for tests, `zksync` for zkSync tests and `deploy` for verification.

## 8. Tests

### Scope

- Keep the default end-to-end test of the framework in every test contract. Run it on every network with a pool and for every Aave V4 spoke. If it fails, fix the cause. Do not turn it off.
- Test the payload itself. Assert the state before `executePayload` and after it. The test must fail if you remove a line of the payload.
- Execute the payload once in each test. Do not use `prank`, `hoax` or mocks to set the state that the payload must change.
- Assert every field that the payload writes. Where it writes in two directions, assert both. Also assert the state around it, for example the exact role members, roles that must be absent, and allowances that are left over. Assert that the parameters and assets that the payload does not touch stay the same.
- Check limits. For example, an allowance of 10M works and 10M + 1 reverts.
- Test the user flow after the payload. Examples are a supply and a borrow in a new eMode, a swap through a steward, a bridge transfer or a withdrawal.
- If the payload grants a temporary permission, test that the holder can revoke it.
- For a new price feed, assert its source, a sane price and the CAPO parameters. Use the CAPO test helpers.
- If one part depends on another part, execute Part 1, move time forward and execute Part 2. Add a test that Part 2 reverts without Part 1.

### Expected values

- Take expected values from an independent source. Use the address book, an on-chain read or a value that you computed by hand.
- Do not take an expected value from the payload under test. A test like that passes for any value.
- Use `assertEq` with exact values and `before + delta == after`. Assert the exact revert reason. Use a tolerance only for proven rounding or for a live price.

### Form

- Keep each test small and give it one purpose. Loop over the assets with an internal helper. Write separate tests instead of a snapshot and a revert.
- Put test functions first and internal helpers at the bottom.
- When you change the flags of `defaultTest`, use named arguments. Leave out arguments that have the default value. Set `runSeatbelt` and `testPositionManagers` as the other tests of the same instance do.
- Use `skip()` and `vm.getBlockTimestamp()`. Do not do arithmetic on `block.timestamp` with `vm.warp`.
- Set foundry options for one test inline, for example `/// forge-config: default.isolate = true`. Do not change `foundry.toml` for one proposal.
- Pin the fork block to a recent block, after the latest protocol upgrade and after any funding. Use the same block in `config.ts` and in the tests.

### Diff reports

- After any change to a payload, a dependency or the fork block, run the tests again and commit the new reports in `diffs/`.
- Commit one report for each chain, with the name of this proposal. Delete old, duplicate and empty reports.

## 9. AIP text

### Content

- Every number, address, role, chain and mechanism in the AIP text is the same as in the payload, `config.ts` and the diff.
- The Specification lists every on-chain action: the function, the contract, the network, the recipient, the amount and new addresses. For a listing, it lists all parameters, also the default values.
- The text describes only what the payload does. Remove claims about actions that happen somewhere else or do not happen.
- If the payload is different from the forum post or the risk post, say so in the AIP text. Ask the author to update the forum post before the AIP goes up.
- For every address that gets a role, say who controls it. Use the same addresses as the forum post.
- For an asset listing, add a section on the price feed. Give the feed name for each layer with a link, the CAPO parameters in a table, and the latest answer with its date.
- When eModes change, show them in a table with the category ID.
- For a parameter update, show only the parameters that change. Name the network on each row, or give each network its own table.

### Front matter and links

- Follow the template for the front matter: `title`, `author`, `discussions` and, if a vote exists, `snapshot`. Put each value in quotes. Do not repeat a key, and do not add a second title.
- The title says what the AIP changes, for example "Onboard X on Aave V3 Y". Use the same title in the front matter, `config.ts` and `@title`. Write it with spaces, and do not add a prefix such as `[Direct-to-AIP]`.
- The author is the real requester in the form `Org (@handle)`. If another team wrote the code, add `(implemented by Org)`. Use the same string in the AIP text and in `@author`.
- The discussion link points to the exact forum post, with the post number. The Snapshot link points to the vote with the executed parameters. Use the same links in the AIP text, the NatSpec and `config.ts`.
- For a Direct-to-AIP proposal, see "Open decisions".
- Link every address to the block explorer of its chain. Link only verified contracts.
- Link files of this repo on `main`. Link a file in another repo at a commit, not at a branch. Use the `aave-dao` organization. Never link a PR. Add the audit and the code of each new contract to References.
- Refer to an earlier AIP by its number, as `[AIP-NNN](<vote link>)`, not by its payload ID.

### Form

- Use the template sections in this order: Simple Summary, Motivation, Specification, References, Copyright. Remove forum sections such as Next Steps.
- Call the document "AIP", not "ARFC".
- Run a spell check. When you fix a typo, fix it in every place where it occurs.
- Use one term for each concept in the whole text. Use the official chain names, for example BNB and Ethereum. Write "eMode", "Aave V3" and "V3.x". Use the same casing for a contract name everywhere.
- Use one number format in an AIP. Use the same precision, and use either full amounts or M and k. Write `7.5%`, with no space. Escape `$`.
- Put contract names, functions, roles and raw addresses in backticks. Do not use bold for emphasis in prose.
- Write a lane direction as `source → destination`. Keep temporary limits apart from permanent limits.
- Check the rich diff of the Markdown file on GitHub. Do not keep forum formatting or links to images that the AIP does not include.

## 10. Scripts

- The proposal creation script includes every payload. The array size is the real number of payloads. Indices start at 0.
- Use the correct voting network and the correct path to the AIP text. Use the `build<Chain>Payload` helper of each chain.
- Use one deploy contract for each proposal.
- On chains that need it, such as zkSync, deploy and register the payload first. Then put the payload ID in the creation script. Register it again if it expires.
- On zkSync, deploy the payload with the salt that `CreateProposal` expects, `v1`. With another salt, the creation script reverts with `CannotFindPayload`.

## 11. PR description

- Say what each payload does. Keep the description current when the PR changes.
- If the proposal has more than one payload, give the execution order.
- Give the payload calldata, and list the steps that must happen off-chain or after execution.
- Give evidence for external dependencies, for example official documentation, test transactions or risk assessments.
- Give the test evidence, with the command and its result.
- Add the explanations that do not belong in `@dev`.
- Complete the checklist of the PR template.
- Keep a payload PR without its AIP text as a draft. Merge PRs to dependencies, such as the address book or aave-helpers, before you create the AIP.
- If a later PR replaces your PR, close it and name the replacement.

## 12. Open decisions

Maintainers asked for opposite things on these points. Until they decide, this file uses the rule after each point.

1. Text of the AIP. One view is to copy the forum post word for word. The other view is to write a short new text. Until a decision, copy the forum post and adapt it only to the template sections. Say where the AIP is different.
2. Shared helpers. One view is to put them in aave-helpers. The other view is to keep them in this repo until a second user exists. Until a decision, put them in `src/helpers` here.
3. Liquidity mining admin. Earlier listings set an emission admin. Recent listings do not. Until a decision, do not set one unless the forum post asks for it.
4. Tokenization spoke on Aave V4 for assets that cannot be borrowed. The maintainers still need to decide.
5. Default owner of a new proxy admin in the generator. Until a decision, the input is required and has no default.
6. Values used once. One view is to write them inline. The other view is to name every value. Until a decision, make addresses and values used more than once, or asserted in tests, constants.
7. Internal helpers in short payloads. Until a decision, add a helper only when it removes repeated code.
8. Assert messages. Until a decision, add a message where a loop or a helper makes the failed case unclear.
9. A Disclaimer section in the AIP text. Until a decision, leave it out, unless the forum post has a disclosure.
10. One payload or several payloads for steps on one chain. One view is to use one payload, so the order is certain. The other view is to use several payloads, for example when one transaction is too large for aDI. Until a decision, use one payload when the steps must run in one transaction. Otherwise use several payloads.
11. The Direct-to-AIP marker. One view is to leave the `snapshot` key out. The other view is to write `Direct-to-AIP` as its value. Until a decision, set `snapshot: 'Direct-to-AIP'` in `config.ts`. The generator then writes `Direct-to-AIP` in the NatSpec and leaves the `snapshot` key out of the front matter.
12. `constant` or `immutable` for addresses and values. Until a decision, use `constant`.
