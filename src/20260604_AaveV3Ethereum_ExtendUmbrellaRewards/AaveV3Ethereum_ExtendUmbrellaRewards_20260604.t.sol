// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UmbrellaEthereum, UmbrellaEthereumAssets} from 'aave-address-book/UmbrellaEthereum.sol';
import {IRewardsController} from 'aave-umbrella/rewards/interfaces/IRewardsController.sol';
import {IRewardsStructs} from 'aave-umbrella/rewards/interfaces/IRewardsStructs.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV3TestBase.sol';
import {AaveV3Ethereum_ExtendUmbrellaRewards_20260604} from './AaveV3Ethereum_ExtendUmbrellaRewards_20260604.sol';

/**
 * @dev Test for AaveV3Ethereum_ExtendUmbrellaRewards_20260604
 * command: FOUNDRY_PROFILE=test forge test --match-path=src/20260604_AaveV3Ethereum_ExtendUmbrellaRewards/AaveV3Ethereum_ExtendUmbrellaRewards_20260604.t.sol -vv
 */
contract AaveV3Ethereum_ExtendUmbrellaRewards_20260604_Test is ProtocolV3TestBase {
  IRewardsController internal constant REWARDS_CONTROLLER =
    IRewardsController(UmbrellaEthereum.UMBRELLA_REWARDS_CONTROLLER);

  AaveV3Ethereum_ExtendUmbrellaRewards_20260604 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 25246530);
    proposal = new AaveV3Ethereum_ExtendUmbrellaRewards_20260604();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Ethereum_ExtendUmbrellaRewards_20260604',
      AaveV3Ethereum.POOL,
      address(proposal)
    );
  }

  function test_distributionEndExtended() public {
    uint256 expectedDistributionEnd = block.timestamp + proposal.DISTRIBUTION_DURATION();

    executePayload(vm, address(proposal));

    _assertDistributionEnd(
      UmbrellaEthereumAssets.STK_WA_USDC_V1,
      AaveV3EthereumAssets.USDC_A_TOKEN,
      expectedDistributionEnd
    );
    _assertDistributionEnd(
      UmbrellaEthereumAssets.STK_WA_USDT_V1,
      AaveV3EthereumAssets.USDT_A_TOKEN,
      expectedDistributionEnd
    );
    _assertDistributionEnd(
      UmbrellaEthereumAssets.STK_WA_WETH_V1,
      AaveV3EthereumAssets.WETH_A_TOKEN,
      expectedDistributionEnd
    );
    _assertDistributionEnd(
      UmbrellaEthereumAssets.STK_GHO_V1,
      AaveV3EthereumAssets.GHO_UNDERLYING,
      expectedDistributionEnd
    );
  }

  function test_maxEmissionPerSecondUnchanged() public {
    uint256 usdcMaxEmissionBefore = _getMaxEmissionPerSecond(
      UmbrellaEthereumAssets.STK_WA_USDC_V1,
      AaveV3EthereumAssets.USDC_A_TOKEN
    );
    uint256 usdtMaxEmissionBefore = _getMaxEmissionPerSecond(
      UmbrellaEthereumAssets.STK_WA_USDT_V1,
      AaveV3EthereumAssets.USDT_A_TOKEN
    );
    uint256 wethMaxEmissionBefore = _getMaxEmissionPerSecond(
      UmbrellaEthereumAssets.STK_WA_WETH_V1,
      AaveV3EthereumAssets.WETH_A_TOKEN
    );
    uint256 ghoMaxEmissionBefore = _getMaxEmissionPerSecond(
      UmbrellaEthereumAssets.STK_GHO_V1,
      AaveV3EthereumAssets.GHO_UNDERLYING
    );

    executePayload(vm, address(proposal));

    assertEq(
      _getMaxEmissionPerSecond(
        UmbrellaEthereumAssets.STK_WA_USDC_V1,
        AaveV3EthereumAssets.USDC_A_TOKEN
      ),
      usdcMaxEmissionBefore
    );
    assertEq(
      _getMaxEmissionPerSecond(
        UmbrellaEthereumAssets.STK_WA_USDT_V1,
        AaveV3EthereumAssets.USDT_A_TOKEN
      ),
      usdtMaxEmissionBefore
    );
    assertEq(
      _getMaxEmissionPerSecond(
        UmbrellaEthereumAssets.STK_WA_WETH_V1,
        AaveV3EthereumAssets.WETH_A_TOKEN
      ),
      wethMaxEmissionBefore
    );
    assertEq(
      _getMaxEmissionPerSecond(
        UmbrellaEthereumAssets.STK_GHO_V1,
        AaveV3EthereumAssets.GHO_UNDERLYING
      ),
      ghoMaxEmissionBefore
    );
  }

  function _assertDistributionEnd(
    address asset,
    address reward,
    uint256 expectedDistributionEnd
  ) internal view {
    IRewardsStructs.RewardDataExternal memory data = REWARDS_CONTROLLER.getRewardData(
      asset,
      reward
    );
    assertEq(data.distributionEnd, expectedDistributionEnd);
  }

  function _getMaxEmissionPerSecond(address asset, address reward) internal view returns (uint256) {
    return REWARDS_CONTROLLER.getRewardData(asset, reward).maxEmissionPerSecond;
  }
}
