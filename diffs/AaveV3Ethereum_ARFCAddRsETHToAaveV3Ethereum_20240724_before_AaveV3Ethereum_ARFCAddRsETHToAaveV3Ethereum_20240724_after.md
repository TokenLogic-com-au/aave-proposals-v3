## Reserve changes

### Reserves added

#### rsETH ([0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7](https://etherscan.io/address/0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7))

| description | value |
| --- | --- |
| decimals | 18 |
| isActive | true |
| isFrozen | false |
| supplyCap | 19,000 rsETH |
| borrowCap | 1,900 rsETH |
| debtCeiling | 0 $ [0] |
| isSiloed | false |
| isFlashloanable | true |
| eModeCategory | 1 |
| oracle | [0xD6270dAabFe4862306190298C2B48fed9e15C847](https://etherscan.io/address/0xD6270dAabFe4862306190298C2B48fed9e15C847) |
| oracleDecimals | 8 |
| oracleDescription | Capped ethX / ETH / USD |
| oracleLatestAnswer | 2724.30314349 |
| usageAsCollateralEnabled | true |
| ltv | 72 % [7200] |
| liquidationThreshold | 75 % [7500] |
| liquidationBonus | 7.5 % |
| liquidationProtocolFee | 10 % [1000] |
| reserveFactor | 15 % [1500] |
| aToken | [0x10Ac93971cdb1F5c778144084242374473c350Da](https://etherscan.io/address/0x10Ac93971cdb1F5c778144084242374473c350Da) |
| aTokenImpl | [0x7EfFD7b47Bfd17e52fB7559d3f924201b9DbfF3d](https://etherscan.io/address/0x7EfFD7b47Bfd17e52fB7559d3f924201b9DbfF3d) |
| variableDebtToken | [0xAC50890a80A2731eb1eA2e9B4F29569CeB06D960](https://etherscan.io/address/0xAC50890a80A2731eb1eA2e9B4F29569CeB06D960) |
| variableDebtTokenImpl | [0xaC725CB59D16C81061BDeA61041a8A5e73DA9EC6](https://etherscan.io/address/0xaC725CB59D16C81061BDeA61041a8A5e73DA9EC6) |
| stableDebtToken | [0xCcf8413F9cA3bAE07EEF05E265D238d60abCb8Ca](https://etherscan.io/address/0xCcf8413F9cA3bAE07EEF05E265D238d60abCb8Ca) |
| stableDebtTokenImpl | [0x15C5620dfFaC7c7366EED66C20Ad222DDbB1eD57](https://etherscan.io/address/0x15C5620dfFaC7c7366EED66C20Ad222DDbB1eD57) |
| borrowingEnabled | true |
| stableBorrowRateEnabled | false |
| isBorrowableInIsolation | false |
| interestRateStrategy | [0x847A3364Cc5fE389283bD821cfC8A477288D9e82](https://etherscan.io/address/0x847A3364Cc5fE389283bD821cfC8A477288D9e82) |
| aTokenName | Aave Ethereum rsETH |
| aTokenSymbol | aEthrsETH |
| aTokenUnderlyingBalance | 0.01 rsETH [10000000000000000] |
| isPaused | false |
| stableDebtTokenName | Aave Ethereum Stable Debt rsETH |
| stableDebtTokenSymbol | stableDebtEthrsETH |
| variableDebtTokenName | Aave Ethereum Variable Debt rsETH |
| variableDebtTokenSymbol | variableDebtEthrsETH |
| virtualAccountingActive | true |
| virtualBalance | 0.01 rsETH [10000000000000000] |
| optimalUsageRatio | 45 % |
| maxVariableBorrowRate | 307 % |
| baseVariableBorrowRate | 0 % |
| variableRateSlope1 | 7 % |
| variableRateSlope2 | 300 % |
| interestRate | ![ir](/.assets/b5f94bbcdf660fdadabe91f32d6c64714a825648.svg) |
| eMode.label | ETH correlated |
| eMode.ltv | 93 % |
| eMode.liquidationThreshold | 95 % |
| eMode.liquidationBonus | 1 % |
| eMode.priceSource | 0x0000000000000000000000000000000000000000 |


## Raw diff

```json
{
  "reserves": {
    "0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7": {
      "from": null,
      "to": {
        "aToken": "0x10Ac93971cdb1F5c778144084242374473c350Da",
        "aTokenImpl": "0x7EfFD7b47Bfd17e52fB7559d3f924201b9DbfF3d",
        "aTokenName": "Aave Ethereum rsETH",
        "aTokenSymbol": "aEthrsETH",
        "aTokenUnderlyingBalance": "10000000000000000",
        "borrowCap": 1900,
        "borrowingEnabled": true,
        "debtCeiling": 0,
        "decimals": 18,
        "eModeCategory": 1,
        "interestRateStrategy": "0x847A3364Cc5fE389283bD821cfC8A477288D9e82",
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
        "oracleLatestAnswer": 272430314349,
        "reserveFactor": 1500,
        "stableBorrowRateEnabled": false,
        "stableDebtToken": "0xCcf8413F9cA3bAE07EEF05E265D238d60abCb8Ca",
        "stableDebtTokenImpl": "0x15C5620dfFaC7c7366EED66C20Ad222DDbB1eD57",
        "stableDebtTokenName": "Aave Ethereum Stable Debt rsETH",
        "stableDebtTokenSymbol": "stableDebtEthrsETH",
        "supplyCap": 19000,
        "symbol": "rsETH",
        "underlying": "0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7",
        "usageAsCollateralEnabled": true,
        "variableDebtToken": "0xAC50890a80A2731eb1eA2e9B4F29569CeB06D960",
        "variableDebtTokenImpl": "0xaC725CB59D16C81061BDeA61041a8A5e73DA9EC6",
        "variableDebtTokenName": "Aave Ethereum Variable Debt rsETH",
        "variableDebtTokenSymbol": "variableDebtEthrsETH",
        "virtualAccountingActive": true,
        "virtualBalance": "10000000000000000"
      }
    }
  },
  "strategies": {
    "0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7": {
      "from": null,
      "to": {
        "address": "0x847A3364Cc5fE389283bD821cfC8A477288D9e82",
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