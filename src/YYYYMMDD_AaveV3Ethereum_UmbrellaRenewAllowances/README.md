# Umbrella reward allowance renewal skeleton

Template for renewing the Umbrella reward allowances: the Aave Ethereum Collector approves the UmbrellaRewardsController once per reward asset (aEthUSDT, aEthUSDC, aEthWETH), so stakers can keep claiming and emissions continue. Direct-to-AIP, one Ethereum payload, no Snapshot.

Based on the final tree of aave-dao/aave-proposals-v3#1212 (`src/20260928_AaveV3Ethereum_UmbrellaRenewAllowances/`); the earlier renewal is #914 (commit 80995ab). Every per-event value is a placeholder: `0` numbers, `<...>` text, `YYYYMMDD` in names. Placeholders are chosen to fail a test, not to pass review.

Copy the folder to `src/<YYYYMMDD>_AaveV3Ethereum_UmbrellaRenewAllowances/`, delete this README, and rename every `YYYYMMDD` in file names, contract names, the `.s.sol` paths and the test command.

## Values to fill, in order

1. Forum post (Direct-to-AIP) with the amounts and the amount rule. Put the live thread URL (`https://governance.aave.com/t/<slug>/<id>`, no post number, no `?u=`) in the payload header, the `.md` frontmatter `discussions:` and References.
2. Reward assets: state in the post which to renew and which not. Add or remove the matching constant, `approve` call, test asserts, claim test and staker list; the #1212 tree renews USDT, USDC and WETH and leaves GHO untouched.
3. Amounts: from the live allowance, the unclaimed backlog (`*_UNCLAIMED` in the test, sum of `calculateCurrentUserReward` over all stake token holders) and the forward buffer (`maxEmissionPerSecond * (distributionEnd - now)`), all at a stated block. Fill `USDT_ABSOLUTE_ALLOWANCE`, `USDC_ABSOLUTE_ALLOWANCE`, `WETH_ABSOLUTE_ALLOWANCE` in the `.sol` and the `*_UNCLAIMED` constants in the test. Refresh the `_usdtStakers`, `_usdcStakers`, `_wethStakers` lists (top stakers with unclaimed rewards at that block).
4. `.md`: summary, motivation, the amounts table (accrued, unclaimed, emissions, total required, new allowance), current allowances, dates, implementation and test links (commit hash). Frontmatter carries no `snapshot:` line; References carries `Snapshot: Direct-to-AIP` as text.
5. `.s.sol`: only paths and contract names; the voting portal is `VOTING_PORTAL_ETH_AVAX`.
6. Fork block last: set it in the test `setUp()` and the `block <...>` comment. Then run the tests so `defaultTest()` regenerates the diff report; any later bump needs a fresh report.

## Amount rule

Absolute (default, #1212): the payload sets each allowance to the stated target, replacing the remaining allowance.

```solidity
AaveV3Ethereum.COLLECTOR.approve(IERC20(AaveV3EthereumAssets.USDT_A_TOKEN), rewardsController, USDT_ABSOLUTE_ALLOWANCE);
```

Added (80995ab / #914): the payload adds the stated amount to the allowance at execution time. Rename the constants to `*_RENEWAL_ALLOWANCE`, declare `address collector = address(AaveV3Ethereum.COLLECTOR);` in `execute()`, and change the third argument:

```solidity
IERC20(AaveV3EthereumAssets.USDT_A_TOKEN).allowance(collector, rewardsController) + USDT_RENEWAL_ALLOWANCE
```

Then `test_allowancesAfter` must compare against the allowance before plus the renewal amount, and `test_allowancesCoverUnclaimedAndRemainingEmission` against the allowance after. Name the rule in the forum post and the `.md`.

## Tests

The test file keeps the allowance-after asserts, the coverage check (allowance at least unclaimed plus remaining emission until `distributionEnd`) and the per-vault claim tests (claims revert on insufficient allowance before the payload, succeed after). Run with `FOUNDRY_PROFILE=test forge test --match-path=<dir>/*.t.sol -vv`.

## Before pushing

`pnpm lint`. The generated `diffs/` report is not part of the skeleton; `defaultTest()` writes it at the final fork block.
