## Reserve changes

### Reserves added

#### ezETH ([0xbf5495Efe5DB9ce00f80364C8B423567e58d2110](https://etherscan.io/address/0xbf5495Efe5DB9ce00f80364C8B423567e58d2110))

| description | value |
| --- | --- |
| decimals | 18 |
| isActive | true |
| isFrozen | false |
| supplyCap | 7,000 ezETH |
| borrowCap | 700 ezETH |
| debtCeiling | 0 $ [0] |
| isSiloed | false |
| isFlashloanable | true |
| eModeCategory | 1 |
| oracle | [0xD6270dAabFe4862306190298C2B48fed9e15C847](https://etherscan.io/address/0xD6270dAabFe4862306190298C2B48fed9e15C847) |
| oracleDecimals | 8 |
| oracleDescription | Capped ethX / ETH / USD |
| oracleLatestAnswer | 2773.5167273 |
| usageAsCollateralEnabled | true |
| ltv | 72 % [7200] |
| liquidationThreshold | 75 % [7500] |
| liquidationBonus | 7.5 % |
| liquidationProtocolFee | 10 % [1000] |
| reserveFactor | 15 % [1500] |
| aToken | [0x09AA30b182488f769a9824F15E6Ce58591Da4781](https://etherscan.io/address/0x09AA30b182488f769a9824F15E6Ce58591Da4781) |
| aTokenImpl | [0x7F8Fc14D462bdF93c681c1f2Fd615389bF969Fb2](https://etherscan.io/address/0x7F8Fc14D462bdF93c681c1f2Fd615389bF969Fb2) |
| variableDebtToken | [0x2D9fe18b6c35FE439cC15D932cc5C943bf2d901E](https://etherscan.io/address/0x2D9fe18b6c35FE439cC15D932cc5C943bf2d901E) |
| variableDebtTokenImpl | [0x3E59212c34588a63350142EFad594a20C88C2CEd](https://etherscan.io/address/0x3E59212c34588a63350142EFad594a20C88C2CEd) |
| stableDebtToken | [0x779dB175167C60c2B2193Be6B8d8B3602435e89E](https://etherscan.io/address/0x779dB175167C60c2B2193Be6B8d8B3602435e89E) |
| stableDebtTokenImpl | [0x36284fED68f802c5733432c3306D8e92c504a243](https://etherscan.io/address/0x36284fED68f802c5733432c3306D8e92c504a243) |
| borrowingEnabled | true |
| stableBorrowRateEnabled | false |
| isBorrowableInIsolation | false |
| interestRateStrategy | [0x6642dcAaBc80807DD083c66a301d308568CBcA3D](https://etherscan.io/address/0x6642dcAaBc80807DD083c66a301d308568CBcA3D) |
| aTokenName | Aave Ethereum Lido ezETH |
| aTokenSymbol | aEthLidoezETH |
| aTokenUnderlyingBalance | 0.01 ezETH [10000000000000000] |
| isPaused | false |
| stableDebtTokenName | Aave Ethereum Lido Stable Debt ezETH |
| stableDebtTokenSymbol | stableDebtEthLidoezETH |
| variableDebtTokenName | Aave Ethereum Lido Variable Debt ezETH |
| variableDebtTokenSymbol | variableDebtEthLidoezETH |
| virtualAccountingActive | true |
| virtualBalance | 0.01 ezETH [10000000000000000] |
| optimalUsageRatio | 45 % |
| maxVariableBorrowRate | 307 % |
| baseVariableBorrowRate | 0 % |
| variableRateSlope1 | 7 % |
| variableRateSlope2 | 300 % |
| interestRate | ![ir](/.assets/f90aed3ab721b3ff3a381a99ecb8e44704ff4da6.svg) |
| eMode.label | ETH correlated |
| eMode.ltv | 93.5 % |
| eMode.liquidationThreshold | 95.5 % |
| eMode.liquidationBonus | 1 % |
| eMode.priceSource | 0x0000000000000000000000000000000000000000 |


## Raw diff

```json
{
  "reserves": {
    "0xbf5495Efe5DB9ce00f80364C8B423567e58d2110": {
      "from": null,
      "to": {
        "aToken": "0x09AA30b182488f769a9824F15E6Ce58591Da4781",
        "aTokenImpl": "0x7F8Fc14D462bdF93c681c1f2Fd615389bF969Fb2",
        "aTokenName": "Aave Ethereum Lido ezETH",
        "aTokenSymbol": "aEthLidoezETH",
        "aTokenUnderlyingBalance": "10000000000000000",
        "borrowCap": 700,
        "borrowingEnabled": true,
        "debtCeiling": 0,
        "decimals": 18,
        "eModeCategory": 1,
        "interestRateStrategy": "0x6642dcAaBc80807DD083c66a301d308568CBcA3D",
        "isActive": true,
        "isBorrowableInIsolation": false,
        "isFlashloanable": true,
        "isFrozen": false,
        "isPaused": false,
        "isSiloed": false,
        "liquidationBonus": 10750,
        "liquidationProtocolFee": 1000,
        "liquidationThreshold": 7500,
        "ltv": 7200,
        "oracle": "0xD6270dAabFe4862306190298C2B48fed9e15C847",
        "oracleDecimals": 8,
        "oracleDescription": "Capped ethX / ETH / USD",
        "oracleLatestAnswer": 277351672730,
        "reserveFactor": 1500,
        "stableBorrowRateEnabled": false,
        "stableDebtToken": "0x779dB175167C60c2B2193Be6B8d8B3602435e89E",
        "stableDebtTokenImpl": "0x36284fED68f802c5733432c3306D8e92c504a243",
        "stableDebtTokenName": "Aave Ethereum Lido Stable Debt ezETH",
        "stableDebtTokenSymbol": "stableDebtEthLidoezETH",
        "supplyCap": 7000,
        "symbol": "ezETH",
        "underlying": "0xbf5495Efe5DB9ce00f80364C8B423567e58d2110",
        "usageAsCollateralEnabled": true,
        "variableDebtToken": "0x2D9fe18b6c35FE439cC15D932cc5C943bf2d901E",
        "variableDebtTokenImpl": "0x3E59212c34588a63350142EFad594a20C88C2CEd",
        "variableDebtTokenName": "Aave Ethereum Lido Variable Debt ezETH",
        "variableDebtTokenSymbol": "variableDebtEthLidoezETH",
        "virtualAccountingActive": true,
        "virtualBalance": "10000000000000000"
      }
    }
  },
  "strategies": {
    "0xbf5495Efe5DB9ce00f80364C8B423567e58d2110": {
      "from": null,
      "to": {
        "address": "0x6642dcAaBc80807DD083c66a301d308568CBcA3D",
        "baseVariableBorrowRate": 0,
        "maxVariableBorrowRate": "3070000000000000000000000000",
        "optimalUsageRatio": "450000000000000000000000000",
        "variableRateSlope1": "70000000000000000000000000",
        "variableRateSlope2": "3000000000000000000000000000"
      }
    }
  }
}
```