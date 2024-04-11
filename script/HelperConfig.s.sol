// SPDX-Licence-Identifier: MIT
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
// Mock contract
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetWorkConfig public activeNetWorkConfig;

    uint8 public constant DECIMALS = 8; // uint8 is for decimals
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetWorkConfig {
        address priceFeed; //ETH/USD price feed add
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetWorkConfig = getMainnetEthConfig();
        } else {
            activeNetWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory ethConfig = NetWorkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        if (activeNetWorkConfig.priceFeed != address(0)) {
            return activeNetWorkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetWorkConfig memory anvilConfig = NetWorkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
