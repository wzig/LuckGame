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
        instance.setCoinConfig( //usdt
            address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
            1000,
            6
        );
        instance.setCoinConfig( //usdc
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
            1000,
            6
        );
        instance.setCoinConfig( // shib
            address(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE),
            140000,
            18
        );
    }
}
