## Hub Spoke Config Changes

### USDC (assetId: 5) on Hub [0xCca852Bc40e560adC3b1Cc58CA5b55638ce826c9](https://etherscan.io/address/0xCca852Bc40e560adC3b1Cc58CA5b55638ce826c9) / Spoke [0x531E90a2376902DE8915789Fcc1075e3B0c153E7](https://etherscan.io/address/0x531E90a2376902DE8915789Fcc1075e3B0c153E7)

| description | value before | value after |
| --- | --- | --- |
| addCap | 2,000,000 (2e6) USDC | 100,000,000 (1e8) USDC |

## Event logs

#### 0xCca852Bc40e560adC3b1Cc58CA5b55638ce826c9 (AaveV4Ethereum.ALL_HUBS[0], AaveV4Ethereum.HUBS.CORE_HUB)

| index | event |
| --- | --- |
| 0 | UpdateSpokeConfig(assetId: 5, spoke: 0x531E90a2376902DE8915789Fcc1075e3B0c153E7, config: {addCap: 100000000, drawCap: 0, riskPremiumThreshold: 0, active: true, halted: false}) |

#### 0x5300A1a15135EA4dc7aD5a167152C01EFc9b192A (AaveV2Ethereum.POOL_ADMIN, AaveV2EthereumAMM.POOL_ADMIN, AaveV3Ethereum.ACL_ADMIN, AaveV3EthereumEtherFi.ACL_ADMIN, AaveV3EthereumHorizon.ACL_ADMIN, AaveV3EthereumLido.ACL_ADMIN, GovernanceV3Ethereum.EXECUTOR_LVL_1)

| index | event |
| --- | --- |
| 1 | ExecutedAction(target: 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f, value: 0, signature: execute(), data: 0x, executionTime: 1795639955, withDelegatecall: true, resultData: 0x) |

#### 0xdAbad81aF85554E9ae636395611C58F7eC1aAEc5 (GovernanceV3Ethereum.PAYLOADS_CONTROLLER)

| index | event |
| --- | --- |
| 2 | PayloadExecuted(payloadId: 485) |

## Raw storage changes

### 0xcca852bc40e560adc3b1cc58ca5b55638ce826c9 (AaveV4Ethereum.ALL_HUBS[0], AaveV4Ethereum.HUBS.CORE_HUB)

| slot | previous value | new value |
| --- | --- | --- |
| 0x71a369ff12b15f756a3a343762bb215a56bd5d233d347237bdc42da29f554437 | 0x00000001000000000000000000001e8480000000000000000000008620e6cc45 | 0x0000000100000000000000000005f5e100000000000000000000008620e6cc45 |

### 0xdabad81af85554e9ae636395611c58f7ec1aaec5 (GovernanceV3Ethereum.PAYLOADS_CONTROLLER)

| slot | previous value | new value |
| --- | --- | --- |
| 0x232ebb06e144df88b78853b41f90c7b1d52440d35345730e282a08e1ba0bd7fc | 0x006b074a92000000000002000000000000000000000000000000000000000000 | 0x006b074a92000000000003000000000000000000000000000000000000000000 |
| 0x232ebb06e144df88b78853b41f90c7b1d52440d35345730e282a08e1ba0bd7fd | 0x000000000000000000093a800000000000006b356f1300000000000000000000 | 0x000000000000000000093a800000000000006b356f130000000000006b074a93 |


## Raw diff

```json
{
  "spokeConfigs": {
    "0xCca852Bc40e560adC3b1Cc58CA5b55638ce826c9_5_0x531E90a2376902DE8915789Fcc1075e3B0c153E7": {
      "addCap": {
        "from": 2000000,
        "to": 100000000
      }
    }
  }
}
```
