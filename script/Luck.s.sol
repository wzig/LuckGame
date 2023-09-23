// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/Luck.sol";
import "../src/Wallet.sol";
import "../src/test/TUSDC.sol";

contract LotteryScript is Script {
    function setUp() public {}

    Luck instance;
    TUSDC tusdc;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        uint256 testDeploy = vm.envOr("TEST_DEPLOY", uint256(0));
        vm.startBroadcast(deployerPrivateKey);

        instance = new Luck();
        console.log("Luck deployed to %s", address(instance));
        console.log("instance.owner()", instance.owner());

        Wallet instanceWallet = new Wallet(address(instance), 10);
        console.log("Wallet deployed to %s", address(instanceWallet));
        instance.setAllowMap(10, address(instanceWallet));

        instanceWallet = new Wallet(address(instance), 50);
        console.log("Wallet deployed to %s", address(instanceWallet));
        instance.setAllowMap(50, address(instanceWallet));

        // instanceWallet = new Wallet(address(instance), 100);
        // console.log("Wallet deployed to %s", address(instanceWallet));
        // instance.setAllowMap(100, address(instanceWallet));
        instance.setCoinConfig(
            address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
            1000,
            6
        );

        if (testDeploy > 0) {
            console.log("testDeploy TEST_DEPLOY", testDeploy);
            instance.setLotteryBlockNum(200);
            _testErc20();
        }
    }

    function _testErc20() public {
        tusdc = new TUSDC();
        console.log("tusdc deployed to %s", address(tusdc));

        instance.setCoinConfig(address(tusdc), 1000, 6);

        tusdc.mint(0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1, 100000 ether);
        tusdc.mint(0x9DCCe783B6464611f38631e6C851bf441907c710, 100000 ether);
    }
}
