// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {EngineFlags} from 'aave-v3-origin/contracts/extensions/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig, ExpectedListing} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008} from './AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008.sol';

/**
 * @dev Test for AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20261008_AaveV3Arbitrum_AaveV3ArbitrumUSDGListing/AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008.t.sol -vv
 */
contract AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008_Test is ProtocolV3TestBase {
  AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 513142906);
    proposal = new AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * forge-config: default.isolate = true
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Arbitrum_AaveV3ArbitrumUSDGListing_20261008',
      AaveV3Arbitrum.POOL,
      address(proposal)
    );
  }

  /**
   * @dev checks whether reserve configurations changed or stayed unchanged as expected
   */
  function test_reserveConfigChanges() public {
    address[] memory updatedAssets = new address[](0);

    reserveConfigChangesTest(AaveV3Arbitrum.POOL, address(proposal), updatedAssets);
  }

  function test_dustBinHasUSDGFunds() public {
    GovV3Helpers.executePayload(vm, address(proposal));
    address aTokenAddress = AaveV3Arbitrum.POOL.getReserveAToken(proposal.USDG());
    assertGe(
      IERC20(aTokenAddress).balanceOf(address(AaveV3Arbitrum.DUST_BIN)),
      proposal.USDG_SEED_AMOUNT(),
      'dust bin should hold at least the seeded aUSDG amount'
    );
  }

  function _expectedListings() internal pure override returns (ExpectedListing[] memory listings) {
    listings = new ExpectedListing[](1);

    listings[0] = ExpectedListing({
      listing: IAaveV3ConfigEngine.Listing({
        asset: 0x004B506865409877C9fA29bfb1ebA929984B9bbC,
        assetSymbol: 'USDG',
        priceFeed: 0xf6bDD632625425cE368Bb19Af5A01C3C0344EB1D,
        enabledToBorrow: EngineFlags.ENABLED,
        flashloanable: EngineFlags.ENABLED,
        ltv: 0,
        liqThreshold: 0,
        liqBonus: 0,
        reserveFactor: 10_00,
        supplyCap: 30_000_000,
        borrowCap: 27_600_000,
        liqProtocolFee: 10_00,
        rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
          optimalUsageRatio: 90_00,
          baseVariableBorrowRate: 0,
          variableRateSlope1: 4_00,
          variableRateSlope2: 30_00
        })
      }),
      decimals: 6
    });
  }
}
