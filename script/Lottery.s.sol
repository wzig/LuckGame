// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/Lottery.sol";
import "../src/Wallet.sol";

contract LotteryScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Lottery instance = new Lottery();
        console.log("Lottery Contract deployed to %s", address(instance));

        Wallet instanceWallet = new Wallet(address(instance), 10);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(10, address(instanceWallet));

        instanceWallet = new Wallet(address(instance), 50);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(50, address(instanceWallet));

        instanceWallet = new Wallet(address(instance), 100);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(100, address(instanceWallet));
    }
}
