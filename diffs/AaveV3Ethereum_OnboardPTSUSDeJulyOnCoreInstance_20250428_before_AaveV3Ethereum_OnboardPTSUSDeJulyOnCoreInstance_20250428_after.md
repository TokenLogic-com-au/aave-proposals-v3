## Reserve changes

### Reserves added

#### PT-sUSDE-31JUL2025 ([0x3b3fB9C57858EF816833dC91565EFcd85D96f634](https://etherscan.io/address/0x3b3fB9C57858EF816833dC91565EFcd85D96f634))

| description | value |
| --- | --- |
| decimals | 18 |
| isActive | true |
| isFrozen | false |
| supplyCap | 85,000,000 PT-sUSDE-31JUL2025 |
| borrowCap | 1 PT-sUSDE-31JUL2025 |
| debtCeiling | 0 $ [0] |
| isSiloed | false |
| isFlashloanable | true |
| oracle | [0x759B9B72700A129CD7AD8e53F9c99cb48Fd57105](https://etherscan.io/address/0x759B9B72700A129CD7AD8e53F9c99cb48Fd57105) |
| oracleDecimals | 8 |
| oracleDescription | PT Capped sUSDe USDT/USD linear discount 31JUL2025 |
| oracleLatestAnswer | 0.98089311 |
| usageAsCollateralEnabled | true |
| ltv | 0.05 % [5] |
| liquidationThreshold | 0.1 % [10] |
| liquidationBonus | 7.5 % |
| liquidationProtocolFee | 10 % [1000] |
| reserveFactor | 20 % [2000] |
| aToken | [0xDE6eF6CB4aBd3A473ffC2942eEf5D84536F8E864](https://etherscan.io/address/0xDE6eF6CB4aBd3A473ffC2942eEf5D84536F8E864) |
| variableDebtToken | [0x8C6FeaF5d58BA1A6541F9c4aF685f62bFCBaC3b1](https://etherscan.io/address/0x8C6FeaF5d58BA1A6541F9c4aF685f62bFCBaC3b1) |
| borrowingEnabled | false |
| isBorrowableInIsolation | false |
| interestRateStrategy | [0x9ec6F08190DeA04A54f8Afc53Db96134e5E3FdFB](https://etherscan.io/address/0x9ec6F08190DeA04A54f8Afc53Db96134e5E3FdFB) |
| aTokenName | Aave Ethereum PT_sUSDE_31JUL2025 |
| aTokenSymbol | aEthPT_sUSDE_31JUL2025 |
| aTokenUnderlyingBalance | 10 PT-sUSDE-31JUL2025 [10000000000000000000] |
| id | 41 |
| isPaused | false |
| variableDebtTokenName | Aave Ethereum Variable Debt PT_sUSDE_31JUL2025 |
| variableDebtTokenSymbol | variableDebtEthPT_sUSDE_31JUL2025 |
| virtualAccountingActive | true |
| virtualBalance | 10 PT-sUSDE-31JUL2025 [10000000000000000000] |
| optimalUsageRatio | 45 % |
| maxVariableBorrowRate | 307 % |
| baseVariableBorrowRate | 0 % |
| variableRateSlope1 | 7 % |
| variableRateSlope2 | 300 % |
| interestRate | ![ir](https://dash.onaave.com/api/static?variableRateSlope1=70000000000000000000000000&variableRateSlope2=3000000000000000000000000000&optimalUsageRatio=450000000000000000000000000&baseVariableBorrowRate=0&maxVariableBorrowRate=3070000000000000000000000000) |


## Emodes changed

### EMode: PT-sUSDe Stablecoins Jul 2025(id: 8)

| description | value before | value after |
| --- | --- | --- |
| eMode.label | - | PT-sUSDe Stablecoins Jul 2025 |
| eMode.ltv | - | 87.4 % |
| eMode.liquidationThreshold | - | 89.4 % |
| eMode.liquidationBonus | - | 4.6 % |
| eMode.borrowableBitmap | - | USDC, USDT, USDS |
| eMode.collateralBitmap | - | PT-sUSDE-31JUL2025 |

## Raw diff

```json
{
  "eModes": {
    "8": {
      "from": null,
      "to": {
        "borrowableBitmap": "34359738632",
        "collateralBitmap": "2199023255552",
        "eModeCategory": 8,
        "label": "PT-sUSDe Stablecoins Jul 2025",
        "liquidationBonus": 10460,
        "liquidationThreshold": 8940,
        "ltv": 8740
      }
    }
  },
  "reserves": {
    "0x3b3fB9C57858EF816833dC91565EFcd85D96f634": {
      "from": null,
      "to": {
        "aToken": "0xDE6eF6CB4aBd3A473ffC2942eEf5D84536F8E864",
        "aTokenName": "Aave Ethereum PT_sUSDE_31JUL2025",
        "aTokenSymbol": "aEthPT_sUSDE_31JUL2025",
        "aTokenUnderlyingBalance": "10000000000000000000",
        "borrowCap": 1,
        "borrowingEnabled": false,
        "debtCeiling": 0,
        "decimals": 18,
        "id": 41,
        "interestRateStrategy": "0x9ec6F08190DeA04A54f8Afc53Db96134e5E3FdFB",
        "isActive": true,
        "isBorrowableInIsolation": false,
        "isFlashloanable": true,
        "isFrozen": false,
        "isPaused": false,
        "isSiloed": false,
        "liquidationBonus": 10750,
        "liquidationProtocolFee": 1000,
        "liquidationThreshold": 10,
        "ltv": 5,
        "oracle": "0x759B9B72700A129CD7AD8e53F9c99cb48Fd57105",
        "oracleDecimals": 8,
        "oracleDescription": "PT Capped sUSDe USDT/USD linear discount 31JUL2025",
        "oracleLatestAnswer": "98089311",
        "reserveFactor": 2000,
        "supplyCap": 85000000,
        "symbol": "PT-sUSDE-31JUL2025",
        "underlying": "0x3b3fB9C57858EF816833dC91565EFcd85D96f634",
        "usageAsCollateralEnabled": true,
        "variableDebtToken": "0x8C6FeaF5d58BA1A6541F9c4aF685f62bFCBaC3b1",
        "variableDebtTokenName": "Aave Ethereum Variable Debt PT_sUSDE_31JUL2025",
        "variableDebtTokenSymbol": "variableDebtEthPT_sUSDE_31JUL2025",
        "virtualAccountingActive": true,
        "virtualBalance": "10000000000000000000"
      }
    }
  },
  "strategies": {
    "0x3b3fB9C57858EF816833dC91565EFcd85D96f634": {
      "from": null,
      "to": {
        "address": "0x9ec6F08190DeA04A54f8Afc53Db96134e5E3FdFB",
        "baseVariableBorrowRate": "0",
        "maxVariableBorrowRate": "3070000000000000000000000000",
        "optimalUsageRatio": "450000000000000000000000000",
        "variableRateSlope1": "70000000000000000000000000",
        "variableRateSlope2": "3000000000000000000000000000"
      }
    }
  },
  "raw": {
    "0x223d844fc4b006d67c0cdbd39371a9f73f69d974": {
      "label": "AaveV3Ethereum.EMISSION_MANAGER, AaveV3EthereumEtherFi.EMISSION_MANAGER, AaveV3EthereumLido.EMISSION_MANAGER",
      "balanceDiff": null,
      "stateDiff": {
        "0xa35865bcf0bb262efa1ae8278e28b4d540cef01cf9d29d3eb9d7efb9601c0721": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000ac140648435d03f784879cd789130f22ef588fcd"
        },
        "0xe8f24ad4c23c8e9b21be67bc4d2ff4c3e5fbe67633b1e7eb55d530b4686b020f": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000ac140648435d03f784879cd789130f22ef588fcd"
        }
      }
    },
    "0x3b3fb9c57858ef816833dc91565efcd85d96f634": {
      "label": null,
      "balanceDiff": null,
      "stateDiff": {
        "0x0000000000000000000000000000000000000000000000000000000000000002": {
          "previousValue": "0x01000000000000000000000000000000000000000056386702fda88f5a4e5a43",
          "newValue": "0x01000000000000000000000000000000000000000056386702fda88f5a4e5a43"
        },
        "0x44311a650d63f8da00142639aaf7c0f981ef208319fb2cbecee7443f32bf70f4": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000008ac7230489e80000"
        },
        "0xf17bca5f0b79532f5dbd08020f985f432ed777d5ec7fd344c3ad5c249dc24ce7": {
          "previousValue": "0x0000000000000000000000000000000000000000000000008ac7230489e80000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000000"
        },
        "0xf28b05d7cb1c50f8ef449275074a75213b412b4964112d5fc8ca14bc4785d5eb": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000000"
        }
      }
    },
    "0x54586be62e3c3580375ae3723c145253060ca0c2": {
      "label": "AaveV3Ethereum.ORACLE",
      "balanceDiff": null,
      "stateDiff": {
        "0x84a2f78871574c70c2870b9f4cf5713fc5debf3af10a53f77c2995f9e1061851": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000759b9b72700a129cd7ad8e53f9c99cb48fd57105"
        }
      }
    },
    "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2": {
      "label": "AaveV3Ethereum.POOL",
      "balanceDiff": null,
      "stateDiff": {
        "0x000000000000000000000000000000000000000000000000000000000000003b": {
          "previousValue": "0x00000000000000000000000000000000000000000000002900000000000009c4",
          "newValue": "0x00000000000000000000000000000000000000000000002a00000000000009c4"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cba": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x100000000000000000000003e800510ff4000000000107d0811229fe000a0005"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cbb": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000033b2e3c9fd0803ce8000000"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cbc": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000033b2e3c9fd0803ce8000000"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cbd": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000002900680f0d0b00000000000000000000000000000000"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cbe": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000de6ef6cb4abd3a473ffc2942eef5d84536f8e864"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cc0": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000008c6feaf5d58ba1a6541f9c4af685f62bfcbac3b1"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cc1": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000009ec6f08190dea04a54f8afc53db96134e5e3fdfb"
        },
        "0x0d9c131fe7f75d786f183f1a57e2c2cea3c59b0d3a44f328176089e6960b7cc3": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000000000008ac7230489e8000000000000000000000000000000000000"
        },
        "0x1e0cf9b1c2a1349419380539fae4effc21781e5673d593dca9a7400afb9ce924": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000003b3fb9c57858ef816833dc91565efcd85d96f634"
        },
        "0xdacfe7a8adbf8359f41dcfa7c31c6a0f0553b393d1ed6bae9994c90e5024f1da": {
          "previousValue": "0x000000000000000000000000000000000000000000022aaa8a802000000aaaaa",
          "newValue": "0x0000000000000000000000000000000000000000000a2aaa8a802000000aaaaa"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481917": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000000000000000000002000000000028dc22ec2224"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481918": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x50542d735553446520537461626c65636f696e73204a756c203230323500003a"
        },
        "0xe1eef7f3dc95a7682cb02e33f0d6a7c6e59cd5f4d1f5d7b4e6308bb610481919": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000800000108"
        }
      }
    },
    "0x8c6feaf5d58ba1a6541f9c4af685f62bfcbac3b1": {
      "label": null,
      "balanceDiff": null,
      "stateDiff": {
        "0x0000000000000000000000000000000000000000000000000000000000000000": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000001"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000001": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000000"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000035": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0xd472c9bbecc4bfb3ca801a363d95a85f95c47c9604976dcd9f4082cce33f4a1a"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000037": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000003b3fb9c57858ef816833dc91565efcd85d96f634"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003b": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000000000000000000000000000000000000000005d"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003c": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000043"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003d": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000000000000000008164cc65827dcfe994ab23944cbc90e0aa80bfcb12"
        },
        "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000ac725cb59d16c81061bdea61041a8a5e73da9ec6",
          "label": "Implementation slot"
        },
        "0xbbe3212124853f8b0084a66a2d057c2966e251e132af3691db153ab65f0d1a4d": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x4161766520457468657265756d205661726961626c6520446562742050545f73"
        },
        "0xbbe3212124853f8b0084a66a2d057c2966e251e132af3691db153ab65f0d1a4e": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x555344455f33314a554c32303235000000000000000000000000000000000000"
        },
        "0xc6bb06cb7f92603de181bf256cd16846b93b752a170ff24824098b31aa008a7e": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x7661726961626c654465627445746850545f73555344455f33314a554c323032"
        },
        "0xc6bb06cb7f92603de181bf256cd16846b93b752a170ff24824098b31aa008a7f": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x3500000000000000000000000000000000000000000000000000000000000000"
        }
      }
    },
    "0x9ec6f08190dea04a54f8afc53db96134e5e3fdfb": {
      "label": "AaveV3Ethereum.ASSETS.WETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.wstETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.WBTC.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.USDC.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.DAI.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.LINK.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.AAVE.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.cbETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.USDT.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.rETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.LUSD.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.CRV.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.MKR.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.SNX.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.BAL.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.UNI.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.LDO.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.ENS.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.ONE_INCH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.FRAX.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.GHO.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.RPL.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.sDAI.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.STG.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.KNC.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.FXS.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.crvUSD.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.PYUSD.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.weETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.osETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.USDe.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.ETHx.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.sUSDe.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.tBTC.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.cbBTC.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.USDS.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.rsETH.INTEREST_RATE_STRATEGY, AaveV3Ethereum.ASSETS.LBTC.INTEREST_RATE_STRATEGY",
      "balanceDiff": null,
      "stateDiff": {
        "0x84a2f78871574c70c2870b9f4cf5713fc5debf3af10a53f77c2995f9e1061851": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000000000000000000000000000000000007530000002bc000000001194"
        }
      }
    },
    "0xdabad81af85554e9ae636395611c58f7ec1aaec5": {
      "label": "GovernanceV3Ethereum.PAYLOADS_CONTROLLER",
      "balanceDiff": null,
      "stateDiff": {
        "0xfdbe17e4b45e906c090608f319c93802261400cfc4bccf7a0240a7a87faf0787": {
          "previousValue": "0x00680f0d0a000000000002000000000000000000000000000000000000000000",
          "newValue": "0x00680f0d0a000000000003000000000000000000000000000000000000000000"
        },
        "0xfdbe17e4b45e906c090608f319c93802261400cfc4bccf7a0240a7a87faf0788": {
          "previousValue": "0x000000000000000000093a80000000000000683d318b00000000000000000000",
          "newValue": "0x000000000000000000093a80000000000000683d318b000000000000680f0d0b"
        }
      }
    },
    "0xde6ef6cb4abd3a473ffc2942eef5d84536f8e864": {
      "label": null,
      "balanceDiff": null,
      "stateDiff": {
        "0x0000000000000000000000000000000000000000000000000000000000000000": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000001"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000001": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000000"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000036": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000008ac7230489e80000"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000037": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000000000000000000000000000000000000000000041"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000038": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x6145746850545f73555344455f33314a554c323032350000000000000000002c"
        },
        "0x0000000000000000000000000000000000000000000000000000000000000039": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000000000000000008164cc65827dcfe994ab23944cbc90e0aa80bfcb12"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003b": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0xab905b3e53e2afddec9ce6a4ee5c0639bf003cabe5bf4a0892f182de0aef1f34"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003c": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x000000000000000000000000464c71f6c2f760dda6093dcb91c24c39e5d6e18c"
        },
        "0x000000000000000000000000000000000000000000000000000000000000003d": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000003b3fb9c57858ef816833dc91565efcd85d96f634"
        },
        "0x2c491f7384cd762770fb659d7290ed7b4da75a7c480a8a5cc401f49c4807de64": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x00000000033b2e3c9fd0803ce800000000000000000000008ac7230489e80000"
        },
        "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x0000000000000000000000007effd7b47bfd17e52fb7559d3f924201b9dbff3d",
          "label": "Implementation slot"
        },
        "0x42a7b7dd785cd69714a189dffb3fd7d7174edc9ece837694ce50f7078f7c31ae": {
          "previousValue": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "newValue": "0x4161766520457468657265756d2050545f73555344455f33314a554c32303235"
        }
      }
    }
  }
}
```