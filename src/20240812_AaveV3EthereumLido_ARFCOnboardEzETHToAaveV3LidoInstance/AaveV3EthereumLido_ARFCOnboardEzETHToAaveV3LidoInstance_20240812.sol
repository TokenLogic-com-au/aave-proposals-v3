// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3EthereumLido, AaveV3EthereumLidoEModes} from 'aave-address-book/AaveV3EthereumLido.sol';
import {AaveV3PayloadEthereumLido} from 'aave-helpers/v3-config-engine/AaveV3PayloadEthereumLido.sol';
import {EngineFlags} from 'aave-v3-origin/periphery/contracts/v3-config-engine/EngineFlags.sol';
import {IAaveV3ConfigEngine} from 'aave-v3-origin/periphery/contracts/v3-config-engine/IAaveV3ConfigEngine.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';

import 'forge-std/Test.sol';
/**
 * @title [ARFC] Onboard ezETH to Aave V3 Lido Instance
 * @author Karpatkey_Tokenlogic
 * - Snapshot: https://snapshot.org/#/aave.eth/proposal/0x7ef22a28cb6729ea4a978b02332ff1af8ed924a726915f9a6debf835d8bf8048
 * - Discussion: https://governance.aave.com/t/arfc-onboard-ezeth-to-aave-v3-lido-instance/18504
 */
contract AaveV3EthereumLido_ARFCOnboardEzETHToAaveV3LidoInstance_20240812 is
  AaveV3PayloadEthereumLido
{
  using SafeERC20 for IERC20;

  address public constant ezETH = 0xbf5495Efe5DB9ce00f80364C8B423567e58d2110;
  address public constant ezETH_PRICE_FEED = 0xD6270dAabFe4862306190298C2B48fed9e15C847; // TODO change this address to capo price feed
  uint256 public constant ezETH_SEED_AMOUNT = 0.01 ether;

  function _postExecute() internal override {
    IERC20(ezETH).forceApprove(address(AaveV3EthereumLido.POOL), ezETH_SEED_AMOUNT);
    AaveV3EthereumLido.POOL.supply(
      ezETH,
      ezETH_SEED_AMOUNT,
      address(AaveV3EthereumLido.COLLECTOR),
      0
    );
  }

  function newListings() public pure override returns (IAaveV3ConfigEngine.Listing[] memory) {
    IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](1);

    listings[0] = IAaveV3ConfigEngine.Listing({
      asset: ezETH,
      assetSymbol: 'ezETH',
      priceFeed: ezETH_PRICE_FEED,
      eModeCategory: AaveV3EthereumLidoEModes.ETH_CORRELATED,
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.DISABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 72_00,
      liqThreshold: 75_00,
      liqBonus: 7_50,
      reserveFactor: 15_00,
      supplyCap: 7_000,
      borrowCap: 700,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
        optimalUsageRatio: 45_00,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 7_00,
        variableRateSlope2: 300_00
      })
    });

    return listings;
  }
}
