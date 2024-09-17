## Reserve changes

### Reserve altered

#### DAI ([0x6B175474E89094C44Da98b954EedeAC495271d0F](https://etherscan.io/address/0x6B175474E89094C44Da98b954EedeAC495271d0F))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 13,649,815.5772 DAI [13649815577259411745389414] | 14,067,175.9931 DAI [14067175993185230778840613] |
| virtualBalance | 13,649,774.3589 DAI [13649774358980074281932860] | 14,067,134.7749 DAI [14067134774905893315384059] |


#### USDC ([0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 272,426,038.2653 USDC [272426038265314] | 274,968,565.2655 USDC [274968565265574] |
| virtualBalance | 272,419,700.3400 USDC [272419700340040] | 274,962,227.3403 USDC [274962227340300] |


#### WETH ([0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 120,653.9358 WETH [120653935880624504124464] | 120,740.7495 WETH [120740749529376292236157] |
| virtualBalance | 120,653.9294 WETH [120653929427078216594873] | 120,740.7430 WETH [120740743075830004706566] |


#### USDT ([0xdAC17F958D2ee523a2206206994597C13D831ec7](https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7))

| description | value before | value after |
| --- | --- | --- |
| aTokenUnderlyingBalance | 473,454,976.3677 USDT [473454976367726] | 475,886,809.9525 USDT [475886809952550] |
| virtualBalance | 473,453,822.1535 USDT [473453822153514] | 475,885,655.7383 USDT [475885655738338] |


## Raw diff

```json
{
  "reserves": {
    "0x6B175474E89094C44Da98b954EedeAC495271d0F": {
      "aTokenUnderlyingBalance": {
        "from": "13649815577259411745389414",
        "to": "14067175993185230778840613"
      },
      "virtualBalance": {
        "from": "13649774358980074281932860",
        "to": "14067134774905893315384059"
      }
    },
    "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48": {
      "aTokenUnderlyingBalance": {
        "from": 272426038265314,
        "to": 274968565265574
      },
      "virtualBalance": {
        "from": 272419700340040,
        "to": 274962227340300
      }
    },
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2": {
      "aTokenUnderlyingBalance": {
        "from": "120653935880624504124464",
        "to": "120740749529376292236157"
      },
      "virtualBalance": {
        "from": "120653929427078216594873",
        "to": "120740743075830004706566"
      }
    },
    "0xdAC17F958D2ee523a2206206994597C13D831ec7": {
      "aTokenUnderlyingBalance": {
        "from": 473454976367726,
        "to": 475886809952550
      },
      "virtualBalance": {
        "from": 473453822153514,
        "to": 475885655738338
      }
    }
  }
}
```