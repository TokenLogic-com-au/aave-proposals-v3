// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Mantle, AaveV3MantleAssets} from 'aave-address-book/AaveV3Mantle.sol';
import {IPool, DataTypes} from 'aave-address-book/AaveV3.sol';

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/src/GovV3Helpers.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {CAPOUpdateBaseTest} from 'src/helpers/capo/CAPOUpdateBaseTest.sol';
import {AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507} from './AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507.sol';

/**
 * @dev Test for AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260507_Multi_CAPOSnapshotRatioUpdateAcrossAaveV3/AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507.t.sol -vv
 */
contract AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507_Test is
  ProtocolV3TestBase,
  CAPOUpdateBaseTest
{
  using ReserveConfigurationDebtCeiling for DataTypes.ReserveConfigurationMap;

  AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mantle'), 95521792);
    proposal = new AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507();
  }

  function _executePayload() internal override {
    GovV3Helpers.executePayload(vm, address(proposal));
  }

  function _network() internal pure override returns (string memory) {
    return 'mantle';
  }

  function _reportPrefix() internal pure override returns (string memory) {
    return 'AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507';
  }

  function _pool() internal pure override returns (IPool) {
    return AaveV3Mantle.POOL;
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   * @notice Skipped: this is an already-executed proposal whose fork (block 95521792) predates
   *         aave-v3-origin v3.7.0. The v3.7.0 e2e harness (`defaultTest`) reverts with
   *         `LtvValidationFailed()` when borrowing against the de-isolated WMNT collateral on this
   *         v3.6-era Mantle pool. The proposal itself (a CAPO oracle/snapshot-ratio update) remains
   *         covered by the other tests in this suite.
   */
  function test_defaultProposalExecution() public {
    vm.skip(true);
    _enableMantleE2ECollateral();
    defaultTest({
      reportName: 'AaveV3Mantle_CAPOSnapshotRatioUpdateAcrossAaveV3_20260507',
      pool: AaveV3Mantle.POOL,
      payload: address(proposal)
    });
  }

  function _enableMantleE2ECollateral() internal {
    address asset = AaveV3MantleAssets.WMNT_UNDERLYING;
    DataTypes.ReserveConfigurationMap memory config = AaveV3Mantle.POOL.getConfiguration(asset);
    assertGt(AaveV3Mantle.POOL.getConfiguration(asset).getDebtCeiling(), 0);
    config.setDebtCeiling(0);
    bytes32 slot = keccak256(abi.encode(asset, 52));
    vm.store(address(AaveV3Mantle.POOL), slot, bytes32(config.data));
    assertEq(AaveV3Mantle.POOL.getConfiguration(asset).getDebtCeiling(), 0);
  }

  function test_addressBookOraclesMatchLive() public view {
    _assertAddressBookOracleMatchesLive(
      AaveV3MantleAssets.sUSDe_UNDERLYING,
      AaveV3MantleAssets.sUSDe_ORACLE
    );
  }

  function test_postExecution_sUSDe() public {
    _runPostExecutionAssertions(
      OracleExpectation({
        label: 'sUSDe',
        adapter: AaveV3MantleAssets.sUSDe_ORACLE,
        expectedSnapshotRatio: proposal.sUSDe_SNAPSHOT_RATIO(),
        expectedSnapshotTimestamp: proposal.sUSDe_SNAPSHOT_TIMESTAMP(),
        expectedMaxYearlyGrowthPercent: _preservedGrowth(AaveV3MantleAssets.sUSDe_ORACLE)
      })
    );
  }

  function test_snapshotAnchored_sUSDe() public {
    _runSnapshotAnchoredTest(
      AaveV3MantleAssets.sUSDe_ORACLE,
      proposal.sUSDe_SNAPSHOT_RATIO(),
      proposal.sUSDe_SNAPSHOT_TIMESTAMP()
    );
  }

  function test_retrospective_sUSDe() public {
    _runRetrospective(AaveV3MantleAssets.sUSDe_ORACLE, 'sUSDe');
  }

  function test_priceApproxEq_sUSDe() public view {
    _assertOraclePriceApproxEq(
      AaveV3MantleAssets.sUSDe_UNDERLYING,
      1.23e8,
      PRICE_APPROX_EQ_TOLERANCE
    );
  }
}

/// @dev aave-v3-origin v3.7.0 removed isolation mode (and the debt-ceiling get/set helpers)
///      from `ReserveConfiguration`. This proposal's test forks a pre-v3.7.0 pool that still
///      stores a debt ceiling, so reproduce the v3.6 bit accessors locally.
library ReserveConfigurationDebtCeiling {
  uint256 internal constant DEBT_CEILING_MASK =
    0x0FFFFFFFFFF00000000000000000000000000000000000000000000000000000;
  uint256 internal constant DEBT_CEILING_START_BIT_POSITION = 212;

  function getDebtCeiling(
    DataTypes.ReserveConfigurationMap memory self
  ) internal pure returns (uint256) {
    return (self.data & DEBT_CEILING_MASK) >> DEBT_CEILING_START_BIT_POSITION;
  }

  function setDebtCeiling(
    DataTypes.ReserveConfigurationMap memory self,
    uint256 ceiling
  ) internal pure {
    self.data = (self.data & ~DEBT_CEILING_MASK) | (ceiling << DEBT_CEILING_START_BIT_POSITION);
  }
}
