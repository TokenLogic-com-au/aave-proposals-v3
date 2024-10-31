## Reserve changes

### Reserves altered

#### WETH ([0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))

| description | value before | value after |
| --- | --- | --- |
| maxVariableBorrowRate | 87.5 % | 87.75 % |
| variableRateSlope1 | 2.5 % | 2.75 % |
| interestRate | ![before](https://dash.onaave.com/api/static?variableRateSlope1=25000000000000000000000000&variableRateSlope2=850000000000000000000000000&optimalUsageRatio=900000000000000000000000000&baseVariableBorrowRate=0&maxVariableBorrowRate=875000000000000000000000000) | ![after](https://dash.onaave.com/api/static?variableRateSlope1=27500000000000000000000000&variableRateSlope2=850000000000000000000000000&optimalUsageRatio=900000000000000000000000000&baseVariableBorrowRate=0&maxVariableBorrowRate=877500000000000000000000000) |

## Emodes changed

### EMode: ETH correlated(id: 1)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | ETH correlated | ETH correlated |
| eMode.ltv (unchanged) | 93.5 % | 93.5 % |
| eMode.liquidationThreshold (unchanged) | 95.5 % | 95.5 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap (unchanged) | wstETH, WETH | wstETH, WETH |
| eMode.collateralBitmap (unchanged) | wstETH, WETH | wstETH, WETH |


## Raw diff

```json
{
  "strategies": {
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2": {
      "maxVariableBorrowRate": {
        "from": "875000000000000000000000000",
        "to": "877500000000000000000000000"
      },
      "variableRateSlope1": {
        "from": "25000000000000000000000000",
        "to": "27500000000000000000000000"
      }
    }
  }
}
```