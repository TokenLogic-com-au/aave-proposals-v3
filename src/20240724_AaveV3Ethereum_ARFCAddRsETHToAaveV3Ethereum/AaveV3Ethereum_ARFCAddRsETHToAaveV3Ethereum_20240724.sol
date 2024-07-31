// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumEModes} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3PayloadEthereum} from 'aave-helpers/v3-config-engine/AaveV3PayloadEthereum.sol';
import {EngineFlags} from 'aave-helpers/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-helpers/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IV3RateStrategyFactory} from 'aave-helpers/v3-config-engine/IV3RateStrategyFactory.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';

/**
 * @title [ARFC] Add rsETH to Aave V3 Ethereum
 * @author Karpatkey_Tokenlogic
 * - Snapshot: TODO
 * - Discussion: https://governance.aave.com/t/arfc-add-rseth-to-aave-v3-ethereum/17696
 */
contract AaveV3Ethereum_ARFCAddRsETHToAaveV3Ethereum_20240724 is AaveV3PayloadEthereum {
  using SafeERC20 for IERC20;

  address public constant rsETH = 0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7;
  uint256 public constant rsETH_SEED_AMOUNT = 0.01 ether;

  function _postExecute() internal override {
    IERC20(rsETH).forceApprove(address(AaveV3Ethereum.POOL), rsETH_SEED_AMOUNT);
    AaveV3Ethereum.POOL.supply(rsETH, rsETH_SEED_AMOUNT, address(AaveV3Ethereum.COLLECTOR), 0);
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: rsETH,
      assetSymbol: 'rsETH',
      priceFeed: 0x03c68933f7a3F76875C0bc670a58e69294cDFD01, // TODO change this address to capo price feed
      eModeCategory: AaveV3EthereumEModes.ETH_CORRELATED,
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.DISABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 72_50,
      liqThreshold: 75_00,
      liqBonus: 7_50,
      reserveFactor: 15_00,
      supplyCap: 8_000,
      borrowCap: 800,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      rateStrategyParams: IV3RateStrategyFactory.RateStrategyParams({
        optimalUsageRatio: _bpsToRay(45_00),
        baseVariableBorrowRate: _bpsToRay(0),
        variableRateSlope1: _bpsToRay(7_00),
        variableRateSlope2: _bpsToRay(300_00),
        stableRateSlope1: _bpsToRay(0),
        stableRateSlope2: _bpsToRay(0),
        baseStableRateOffset: _bpsToRay(0),
        stableRateExcessOffset: _bpsToRay(0),
        optimalStableToTotalDebtRatio: _bpsToRay(0)
      })
    });

    return listings;
  }
}
