## Emodes changed

### EMode: ETH correlated(id: 1)



### EMode: sUSDe Stablecoins(id: 2)



### EMode: rsETH LST main(id: 3)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | rsETH LST main | rsETH LST main |
| eMode.ltv (unchanged) | 92.5 % | 92.5 % |
| eMode.liquidationThreshold (unchanged) | 94.5 % | 94.5 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap | wstETH, ETHx | ETHx |
| eMode.collateralBitmap (unchanged) | rsETH | rsETH |


### EMode: LBTC_WBTC(id: 4)



### EMode: LBTC_cbBTC(id: 5)



### EMode: LBTC_tBTC(id: 6)



### EMode: eBTC/WBTC(id: 7)



### EMode: rsETH/wstETH(id: 8)

| description | value before | value after |
| --- | --- | --- |
| eMode.label | - | rsETH/wstETH |
| eMode.ltv | - | 93 % |
| eMode.liquidationThreshold | - | 95 % |
| eMode.liquidationBonus | - | 1 % |
| eMode.borrowableBitmap | - | wstETH |
| eMode.collateralBitmap | - | rsETH |


## Raw diff

```json
{
  "eModes": {
    "3": {
      "borrowableBitmap": {
        "from": "2147483650",
        "to": "2147483648"
      }
    },
    "8": {
      "from": null,
      "to": {
        "borrowableBitmap": "2",
        "collateralBitmap": "68719476736",
        "eModeCategory": 8,
        "label": "rsETH/wstETH",
        "liquidationBonus": 10100,
        "liquidationThreshold": 9500,
        "ltv": 9300
      }
    }
  },
  "raw": {
    "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2": {
      "label": "AaveV3Ethereum.POOL",
      "balanceDiff": null,
      "stateDiff": {
        "0x81d0999fde243adcc41b7fa1be5cea14f789e3a6065b815ac58f4bc0838c3155": {
          "previousValue": "0x0000000000000000000000000000000000000000001000000000277424ea2422",
          "newValue": "0x0000000000000000000000000000000000000000001000000000277424ea2422"
        },
        "0x81d0999fde243adcc41b7fa1be5cea14f789e3a6065b815ac58f4bc0838c3157": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000080000002",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000080000000"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481917": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000000000000000000000000000000000000010000000002774251c2454"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481918": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x72734554482f7773744554480000000000000000000000000000000000000018"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481919": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000002"
        }
      }
    },
    "0xdabad81af85554e9ae636395611c58f7ec1aaec5": {
      "label": "GovernanceV3Ethereum.PAYLOADS_CONTROLLER",
      "balanceDiff": null,
      "stateDiff": {
        "0xe033ac067c55ffa15276c1e7e852433fbe5b06aff21c9e12052d01007cfb4f63": {
          "previousValue": "0x0067f94632000000000002000000000000000000000000000000000000000000",
          "newValue": "0x0067f94632000000000003000000000000000000000000000000000000000000"
        },
        "0xe033ac067c55ffa15276c1e7e852433fbe5b06aff21c9e12052d01007cfb4f64": {
          "previousValue": "0x000000000000000000093a8000000000000068276ab300000000000000000000",
          "newValue": "0x000000000000000000093a8000000000000068276ab300000000000067f94633"
        }
      }
    }
  }
}
```