// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {GhoCCIPChains} from 'src/helpers/gho-launch/constants/GhoCCIPChains.sol';
import {IUpgradeableLockReleaseTokenPool} from 'src/interfaces/ccip/IUpgradeableLockReleaseTokenPool.sol';

/**
 * @dev The payloads reset the lanes the pool reports (`getSupportedChains`), the tests loop over
 * GhoCCIPChains; this pins the two sets equal so no lane escapes either side.
 */
abstract contract SupportedChainsCheck is Test {
  function _assertSupportedChainsMatchLibrary(address tokenPool, uint64 ownSelector) internal view {
    uint64[] memory supported = IUpgradeableLockReleaseTokenPool(tokenPool).getSupportedChains();
    GhoCCIPChains.ChainInfo[] memory expected = GhoCCIPChains.getAllChainsExcept(
      ownSelector,
      false
    );
    assertEq(supported.length, expected.length, 'supported chain count');
    for (uint256 i = 0; i < expected.length; i++) {
      bool found;
      for (uint256 j = 0; j < supported.length; j++) {
        if (supported[j] == expected[i].chainSelector) found = true;
      }
      assertTrue(found, 'GhoCCIPChains lane not supported by the pool');
    }
  }
}
