## Reserve changes

### Reserve altered

#### DAI ([0x6B175474E89094C44Da98b954EedeAC495271d0F](https://etherscan.io/address/0x6B175474E89094C44Da98b954EedeAC495271d0F))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 15,924,528.6233 DAI [15924528623359921994863938] | 15,424,528.6233 DAI [15424528623359921994863938] |
| virtualBalance | 15,924,487.4050 DAI [15924487405080584531407384] | 15,424,487.4050 DAI [15424487405080584531407384] |


#### USDC ([0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 137,192,431.4930 USDC [137192431493016] | 135,942,431.4930 USDC [135942431493016] |
| virtualBalance | 137,186,093.5677 USDC [137186093567742] | 135,936,093.5677 USDC [135936093567742] |


#### USDT ([0xdAC17F958D2ee523a2206206994597C13D831ec7](https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 199,667,226.1302 USDT [199667226130261] | 198,417,226.1302 USDT [198417226130261] |
| virtualBalance | 199,666,071.9160 USDT [199666071916049] | 198,416,071.9160 USDT [198416071916049] |


## Emodes changed

### EMode: ETH correlated(id: 1)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | ETH correlated | ETH correlated |
| eMode.ltv (unchanged) | 93 % | 93 % |
| eMode.liquidationThreshold (unchanged) | 95 % | 95 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap (unchanged) | WETH, wstETH, cbETH, rETH, weETH, osETH, ETHx | WETH, wstETH, cbETH, rETH, weETH, osETH, ETHx |
| eMode.collateralBitmap (unchanged) | WETH, wstETH, cbETH, rETH, weETH, osETH, ETHx | WETH, wstETH, cbETH, rETH, weETH, osETH, ETHx |


### EMode: sUSDe Stablecoins(id: 2)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | sUSDe Stablecoins | sUSDe Stablecoins |
| eMode.ltv (unchanged) | 90 % | 90 % |
| eMode.liquidationThreshold (unchanged) | 92 % | 92 % |
| eMode.liquidationBonus (unchanged) | 3 % | 3 % |
| eMode.borrowableBitmap (unchanged) | USDC, USDS | USDC, USDS |
| eMode.collateralBitmap (unchanged) | sUSDe | sUSDe |


### EMode: rsETH LST main(id: 3)

| description | value before | value after |
| --- | --- | --- |
| eMode.label (unchanged) | rsETH LST main | rsETH LST main |
| eMode.ltv (unchanged) | 92.5 % | 92.5 % |
| eMode.liquidationThreshold (unchanged) | 94.5 % | 94.5 % |
| eMode.liquidationBonus (unchanged) | 1 % | 1 % |
| eMode.borrowableBitmap (unchanged) | wstETH, ETHx | wstETH, ETHx |
| eMode.collateralBitmap (unchanged) | rsETH | rsETH |


## Raw diff

```json
{
  "reserves": {
    "0x6B175474E89094C44Da98b954EedeAC495271d0F": {
      "aTokenUnderlyingBalance": {
        "from": "15924528623359921994863938",
        "to": "15424528623359921994863938"
      },
      "virtualBalance": {
        "from": "15924487405080584531407384",
        "to": "15424487405080584531407384"
      }
    },
    "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48": {
      "aTokenUnderlyingBalance": {
        "from": "137192431493016",
        "to": "135942431493016"
      },
      "virtualBalance": {
        "from": "137186093567742",
        "to": "135936093567742"
      }
    },
    "0xdAC17F958D2ee523a2206206994597C13D831ec7": {
      "aTokenUnderlyingBalance": {
        "from": "199667226130261",
        "to": "198417226130261"
      },
      "virtualBalance": {
        "from": "199666071916049",
        "to": "198416071916049"
      }
    }
  }
}
```