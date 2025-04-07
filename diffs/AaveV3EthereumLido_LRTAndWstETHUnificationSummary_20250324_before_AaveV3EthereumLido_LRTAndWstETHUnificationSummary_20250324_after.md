## Reserve changes

### Reserves altered

#### WETH ([0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))

| description | value before | value after |
| --- | --- | --- |
| ltv | 82 % [8200] | 84 % [8400] |
| liquidationThreshold | 83 % [8300] | 85 % [8500] |


## Emodes changed

### EMode: wstETH_WETH(id: 1)

| description | value before | value after |
| --- | --- | --- |
| eMode.label | ETH correlated | wstETH_WETH |
| eMode.ltv | 93.5 % | 95 % |
| eMode.liquidationThreshold | 95.5 % | 96.5 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap (unchanged) | WETH | WETH |
| eMode.collateralBitmap (unchanged) | wstETH | wstETH |


### EMode: LRT Stablecoins main(id: 2)



### EMode: LRT wstETH main(id: 3)



### EMode: sUSDe Stablecoins(id: 4)



### EMode: rsETH LST main(id: 5)



## Raw diff

```json
{
  "eModes": {
    "1": {
      "label": {
        "from": "ETH correlated",
        "to": "wstETH_WETH"
      },
      "liquidationThreshold": {
        "from": 9550,
        "to": 9650
      },
      "ltv": {
        "from": 9350,
        "to": 9500
      }
    }
  },
  "reserves": {
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2": {
      "liquidationThreshold": {
        "from": 8300,
        "to": 8500
      },
      "ltv": {
        "from": 8200,
        "to": 8400
      }
    }
  },
  "raw": {
    "0x4e033931ad43597d96d6bcc25c280717730b58b1": {
      "label": "AaveV3EthereumLido.POOL",
      "balanceDiff": null,
      "stateDiff": {
        "0x8e0cc0f1f0504b4cb44a23b328568106915b169e79003737a7b094503cdbeeb0": {
          "previousValue": "0x00000000000000000000000000000000000000000000000000012774254e2486",
          "newValue": "0x0000000000000000000000000000000000000000000000000001277425b2251c"
        },
        "0x8e0cc0f1f0504b4cb44a23b328568106915b169e79003737a7b094503cdbeeb1": {
          "previousValue": "0x45544820636f7272656c6174656400000000000000000000000000000000001c",
          "newValue": "0x7773744554485f57455448000000000000000000000000000000000000000016"
        },
        "0xf81d8d79f42adb4c73cc3aa0c78e25d3343882d0313c0b80ece3d3a103ef1ebf": {
          "previousValue": "0x100000000000000000000103e80000dbba00000c5c1003e885122904206c2008",
          "newValue": "0x100000000000000000000103e80000dbba00000c5c1003e885122904213420d0"
        }
      }
    },
    "0xdabad81af85554e9ae636395611c58f7ec1aaec5": {
      "label": "GovernanceV3Ethereum.PAYLOADS_CONTROLLER",
      "balanceDiff": null,
      "stateDiff": {
        "0xf843a8c18f62b65c515f4053205e1eed3cbda1e0323ad22ad36843554f16bfc6": {
          "previousValue": "0x0067f3d212000000000002000000000000000000000000000000000000000000",
          "newValue": "0x0067f3d212000000000003000000000000000000000000000000000000000000"
        },
        "0xf843a8c18f62b65c515f4053205e1eed3cbda1e0323ad22ad36843554f16bfc7": {
          "previousValue": "0x000000000000000000093a800000000000006821f69300000000000000000000",
          "newValue": "0x000000000000000000093a800000000000006821f69300000000000067f3d213"
        }
      }
    }
  }
}
```