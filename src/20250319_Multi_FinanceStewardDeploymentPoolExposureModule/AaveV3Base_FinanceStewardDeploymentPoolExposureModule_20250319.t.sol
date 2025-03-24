// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IAccessControl} from 'openzeppelin-contracts/contracts/access/IAccessControl.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {ProtocolV3TestBase} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {IPoolDataProvider, IPriceOracleGetter} from 'aave-address-book/AaveV3.sol';
import {DataTypes} from 'aave-v3-origin/contracts/protocol/libraries/types/DataTypes.sol';
import {ReserveConfiguration} from 'aave-v3-origin/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';

import {AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319} from './AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319.sol';
import {Values} from './Values.sol';

/**
 * @dev Test for AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319
 * command: FOUNDRY_PROFILE=base forge test --match-path=src/20250319_Multi_FinanceStewardDeploymentPoolExposureModule/AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319.t.sol -vv
 */
contract AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319_Test is ProtocolV3TestBase {
  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

  AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319 internal proposal;
  TestBalance internal tester;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 27797204);
    proposal = new AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319();
    tester = new TestBalance();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Base_FinanceStewardDeploymentPoolExposureModule_20250319',
      AaveV3Base.POOL,
      address(proposal)
    );
  }

  function test_accessGranted() public {
    assertFalse(
      IAccessControl(address(AaveV3Base.COLLECTOR)).hasRole(
        'FUNDS_ADMIN',
        AaveV3Base.POOL_EXPOSURE_STEWARD
      )
    );

    executePayload(vm, address(proposal));

    assertTrue(
      IAccessControl(address(AaveV3Base.COLLECTOR)).hasRole(
        'FUNDS_ADMIN',
        AaveV3Base.POOL_EXPOSURE_STEWARD
      )
    );
  }

  function test_allReservesHaveEnoughBalanceOnDustBin() public {
    executePayload(vm, address(proposal));

    address[] memory reserves = AaveV3Base.POOL.getReservesList();
    uint256 reservesLen = reserves.length;

    for (uint256 i = 0; i < reservesLen; i++) {
      address reserve = reserves[i];
      address aToken = AaveV3Base.POOL.getReserveAToken(reserve);
      DataTypes.ReserveConfigurationMap memory configuration = AaveV3Base.POOL.getConfiguration(
        reserve
      );
      (, , , uint256 decimals, ) = configuration.getParams();

      uint256 tokenAmount = Values.getTokenAmountByDollarValue(
        reserve,
        address(AaveV3Base.ORACLE),
        decimals,
        100
      );
      uint256 balanceDustBin = IERC20(aToken).balanceOf(AaveV3Base.DUST_BIN);

      try tester.isGreaterThanOrEqual(balanceDustBin, tokenAmount) {} catch {
        assertGt(balanceDustBin, 0, 'a token does not have greater than 0 balance in dust bin');
      }
    }
  }
}

contract TestBalance is ProtocolV3TestBase {
  function isGreaterThanOrEqual(uint256 balanceDustBin, uint256 minTokenAmount) public pure {
    assertGe(balanceDustBin, minTokenAmount, 'a token does not have greater than $100 in dust bin');
  }
}
