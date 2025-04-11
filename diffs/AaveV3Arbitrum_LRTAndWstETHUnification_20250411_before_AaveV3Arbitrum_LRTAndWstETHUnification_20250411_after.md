## Reserve changes

### Reserves altered

#### weETH ([0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe](https://arbiscan.io/address/0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe))

| description | value before | value after |
| --- | --- | --- |
| ltv | 72.5 % [7250] | 75 % [7500] |
| liquidationThreshold | 75 % [7500] | 77 % [7700] |


## Emodes changed

### EMode: Stablecoins(id: 1)



### EMode: ETH correlated(id: 2)



### EMode: ezETH wstETH(id: 3)



### EMode: ezETH Stablecoins(id: 4)



### EMode: rsETH wstETH(id: 5)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | rsETH wstETH | rsETH wstETH |
| eMode.ltv | 92.5 % | 93 % |
| eMode.liquidationThreshold | 94.5 % | 95 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap (unchanged) | wstETH | wstETH |
| eMode.collateralBitmap (unchanged) | rsETH | rsETH |


## Raw diff

```json
{
  "eModes": {
    "5": {
      "liquidationThreshold": {
        "from": 9450,
        "to": 9500
      },
      "ltv": {
        "from": 9250,
        "to": 9300
      }
    }
  },
  "reserves": {
    "0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe": {
      "liquidationThreshold": {
        "from": 7500,
        "to": 7700
      },
      "ltv": {
        "from": 7250,
        "to": 7500
      }
    }
  },
  "raw": {
    "0x794a61358d6845594f94dc1db02a252b5b4814ad": {
      "label": "AaveV3Arbitrum.POOL",
      "balanceDiff": null,
      "stateDiff": {
        "0x4f0da5bca7ea3ed2a5fd7fbf6d310bc05d68502cf438424218eeef530670c853": {
          "previousValue": "0x100000000000000000000203e800001adb00000000011194851229fe1d4c1c52",
          "newValue": "0x100000000000000000000203e800001adb00000000011194851229fe1e141d4c"
        },
        "0x50039cf134a124858bd88bbc9225ec3c537b89a0e9237ce39fe1813e6edf8257": {
          "previousValue": "0x0000000000000000000000000000000000000000000000040000277424ea2422",
          "newValue": "0x00000000000000000000000000000000000000000000000400002774251c2454"
        },
        "0x50039cf134a124858bd88bbc9225ec3c537b89a0e9237ce39fe1813e6edf8258": {
          "previousValue": "0x7273455448207773744554480000000000000000000000000000000000000018",
          "newValue": "0x7273455448207773744554480000000000000000000000000000000000000018"
        }
      }
    },
    "0x89644ca1bb8064760312ae4f03ea41b05da3637c": {
      "label": "GovernanceV3Arbitrum.PAYLOADS_CONTROLLER",
      "balanceDiff": null,
      "stateDiff": {
        "0xc201016ffcff91372d8b487e0ff78ba4e7738ee54ab48b285b35d26480999112": {
          "previousValue": "0x0067f94842000000000002000000000000000000000000000000000000000000",
          "newValue": "0x0067f94842000000000003000000000000000000000000000000000000000000"
        },
        "0xc201016ffcff91372d8b487e0ff78ba4e7738ee54ab48b285b35d26480999113": {
          "previousValue": "0x000000000000000000093a8000000000000068276cc300000000000000000000",
          "newValue": "0x000000000000000000093a8000000000000068276cc300000000000067f94843"
        }
      }
    }
  }
}
```