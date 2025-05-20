// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CCIPLaunchConstants
 * @notice Library containing all constants used across the GHO Sonic Launch proposal
 */
library CCIPLaunchConstants {
  // Common Addresses
  address internal constant RISK_COUNCIL = 0x8513e6F37dBc52De87b166980Fa3F50639694B60;

  // CCIP Rate Limits
  uint128 internal constant CCIP_RATE_LIMIT_CAPACITY = 1_000_000e18;
  uint128 internal constant CCIP_RATE_LIMIT_REFILL_RATE = 200e18;
  uint128 internal constant CCIP_BUCKET_CAPACITY = 15_000_000e18;
  uint64 internal constant SONIC_CHAIN_SELECTOR = 1673871237479749969;

  // Arbitrum Addresses
  address internal constant ARB_TOKEN_ADMIN_REGISTRY = 0x39AE1032cF4B334a1Ed41cdD0833bdD7c7E7751E;
  address internal constant ARB_CCIP_ROUTER = 0x141fa059441E0ca23ce184B6A78bafD2A517DdE8;

  // Arbitrum ON_RAMPs
  address internal constant ARB_SONIC_ON_RAMP = 0xF0592475d795FB9Ef80B2ddB511d8c6Eb14D821F;
  address internal constant ARB_ETH_ON_RAMP = 0x67761742ac8A21Ec4D76CA18cbd701e5A6F3Bef3;

  // Arbitrum OFF_RAMPs
  address internal constant ARB_SONIC_OFF_RAMP = 0x78867d5D2791eFE73df1cE23Fb7bF4B2db94EE0D;
  address internal constant ARB_ETH_OFF_RAMP = 0x91e46cc5590A4B9182e47f40006140A7077Dec31;

  // Base Addresses
  address internal constant BASE_TOKEN_ADMIN_REGISTRY = 0x6f6C373d09C07425BaAE72317863d7F6bb731e37;
  address internal constant BASE_CCIP_ROUTER = 0x881e3A65B4d4a04dD529061dd0071cf975F58bCD;

  // Base ON_RAMPs

  address internal constant BASE_ETH_ON_RAMP = 0x56b30A0Dcd8dc87Ec08b80FA09502bAB801fa78e;
  address internal constant BASE_SONIC_ON_RAMP = 0xf54853C3502716D9673E1D71BbC94E16C20277E7;

  // Base OFF_RAMPs

  address internal constant BASE_ETH_OFF_RAMP = 0xCA04169671A81E4fB8768cfaD46c347ae65371F1;
  address internal constant BASE_SONIC_OFF_RAMP = 0xA8a877a0F7d3A837A98931b33d45aFd759F98C98;

  // Ethereum Addresses
  address internal constant ETH_TOKEN_ADMIN_REGISTRY = 0xb22764f98dD05c789929716D677382Df22C05Cb6;
  address internal constant ETH_CCIP_ROUTER = 0x80226fc0Ee2b096224EeAc085Bb9a8cba1146f7D;

  // Ethereum ON_RAMPs
  address internal constant ETH_ARB_ON_RAMP = 0x69eCC4E2D8ea56E2d0a05bF57f4Fd6aEE7f2c284;
  address internal constant ETH_SONIC_ON_RAMP = 0xF487000Fe6FE14Fd5E7E86514219994eCEaB6bA7;
  address internal constant ETH_BASE_ON_RAMP = 0xb8a882f3B88bd52D1Ff56A873bfDB84b70431937;

  // Ethereum OFF_RAMPs
  address internal constant ETH_ARB_OFF_RAMP = 0xdf615eF8D4C64d0ED8Fd7824BBEd2f6a10245aC9;
  address internal constant ETH_SONIC_OFF_RAMP = 0x7c6963669EBFf136EE36c053EcF0089d59eE2287;
  address internal constant ETH_BASE_OFF_RAMP = 0x6B4B6359Dd5B47Cdb030E5921456D2a0625a9EbD;

  // SONIC Addresses
  address internal constant SONIC_TOKEN_POOL = 0xab1c66208266bbF5b2809ce1deDd3e5149eb4C94;
  address internal constant SONIC_TOKEN_ADMIN_REGISTRY = 0x2961Cb47b5111F38d75f415c21ceB4120ddd1b69;
  address internal constant SONIC_GHO_TOKEN_IMPL = 0x2f4C4B5526d4129396F767470836559D535FD055;
  address internal constant SONIC_GHO_TOKEN = 0x2FB8193f1302D3D0323f53E29C0AEBc5acEf73Ca;
  address internal constant SONIC_CCIP_ROUTER = 0xB4e1Ff7882474BB93042be9AD5E1fA387949B860;
  address internal constant SONIC_RMN_PROXY = 0x60536Ef486DB5E0e1771874E31485c12e3c2844f;
  address internal constant SONIC_CCIP_STEWARD = 0x06179f7C1be40863405f374E7f5F8806c728660A;

  address internal constant SONIC_AAVE_STEWARD = 0x6e637e1E48025E51315d50ab96d5b3be1971A715;
  address internal constant SONIC_BUCKET_STEWARD = 0x6Bb7a212910682DCFdbd5BCBb3e28FB4E8da10Ee;
  address internal constant SONIC_GHO_PRICE_FEED = 0x360d8aa8F6b09B7BC57aF34db2Eb84dD87bf4d12;

  // SONIC ON_RAMPs
  address internal constant SONIC_ARB_ON_RAMP = 0x140E6D5ba903F684944Dd27369d767DdEf958c9B;
  address internal constant SONIC_ETH_ON_RAMP = 0x014ABcfDbCe9F67d0Df34574664a6C0A241Ec03A;
  address internal constant SONIC_BASE_ON_RAMP = 0xAAb6D9fc00aAc37373206e91789CcDE1E851b3E4;

  // SONIC OFF_RAMPs
  address internal constant SONIC_ARB_OFF_RAMP = 0x2C1539696E29012806a15Bcd9845Ed1278a9fd63;
  address internal constant SONIC_BASE_OFF_RAMP = 0xbeEDd1C5C13C5886c3d600e94Ff9e82C04A53C38;
  address internal constant SONIC_ETH_OFF_RAMP = 0x658d9ae41A9c291De423d3B4B6C064f6dD0e7Ed2;
}
