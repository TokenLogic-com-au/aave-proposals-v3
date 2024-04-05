// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2PayloadPolygon} from 'aave-helpers/v2-config-engine/AaveV2PayloadPolygon.sol';
import {EngineFlags} from 'aave-helpers/v3-config-engine/EngineFlags.sol';
import {IAaveV2ConfigEngine} from 'aave-helpers/v2-config-engine/IAaveV2ConfigEngine.sol';
import {IV2RateStrategyFactory} from 'aave-helpers/v2-config-engine/IV2RateStrategyFactory.sol';

/**
 * @title Stablecoin IR Curves Updates
 * @author Luigy_Karpatkey
 * - Snapshot:
 * - Discussion: https://governance.aave.com/t/arfc-polygon-v2-borrow-rate-adjustments/17252
 */
contract AaveV2Polygon_MultipleIRCurvesUpdates_20240410 is AaveV2PayloadPolygon {
  function rateStrategiesUpdates()
    public
    pure
    override
    returns (IAaveV2ConfigEngine.RateStrategyUpdate[] memory)
  {
    IAaveV2ConfigEngine.RateStrategyUpdate[]
      memory rateStrategies = new IAaveV2ConfigEngine.RateStrategyUpdate[](10);

    // Frozen Assets
    rateStrategies[0] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.BAL_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: _bpsToRay(20_00),
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(50_00),
        variableRateSlope2: _bpsToRay(1_000_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    rateStrategies[1] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.CRV_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: _bpsToRay(10_00),
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(50_00),
        variableRateSlope2: _bpsToRay(1_000_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });

    rateStrategies[2] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.GHST_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: _bpsToRay(10_00),
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(50_00),
        variableRateSlope2: _bpsToRay(1_000_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });

    rateStrategies[3] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.LINK_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: _bpsToRay(10_00),
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(50_00),
        variableRateSlope2: _bpsToRay(1_000_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });

    // Active Assets - Stables
    rateStrategies[4] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.DAI_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(12_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    rateStrategies[5] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.USDT_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(12_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    rateStrategies[6] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.USDC_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(12_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });

    // Active Assets - Volatile

    rateStrategies[7] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.WBTC_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(4_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    rateStrategies[8] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.WETH_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(4_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    rateStrategies[9] = IAaveV2ConfigEngine.RateStrategyUpdate({
      asset: AaveV2PolygonAssets.WMATIC_UNDERLYING,
      params: IV2RateStrategyFactory.RateStrategyParams({
        optimalUtilizationRate: EngineFlags.KEEP_CURRENT,
        baseVariableBorrowRate: EngineFlags.KEEP_CURRENT,
        variableRateSlope1: _bpsToRay(6_75),
        variableRateSlope2: _bpsToRay(750_00),
        stableRateSlope1: EngineFlags.KEEP_CURRENT,
        stableRateSlope2: EngineFlags.KEEP_CURRENT
      })
    });
    return rateStrategies;
  }
}
