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
        console.log("Luck Contract deployed to %s", address(instance));
        console.log("instance.owner()", instance.owner());
        instance.setLotteryBlockNum(200);

        Wallet instanceWallet = new Wallet(address(instance), 10);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(10, address(instanceWallet));

        instanceWallet = new Wallet(address(instance), 50);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(50, address(instanceWallet));

        instanceWallet = new Wallet(address(instance), 100);
        console.log("Wallet Contract deployed to %s", address(instanceWallet));
        instance.setAllowMap(100, address(instanceWallet));

        _testErc20();
    }

    function _testErc20() public {
        tusdc = new TUSDC();
        console.log("tusdc Contract deployed to %s", address(tusdc));

        instance.setCoinConfig(address(tusdc), 1000, 6);

        tusdc.mint(0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1, 100000 ether);
        tusdc.mint(0x61097BA76cD906d2ba4FD106E757f7Eb455fc295, 100000 ether);
        tusdc.mint(0x87BdCE72c06C21cd96219BD8521bDF1F42C78b5e, 100000 ether);
        tusdc.mint(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc, 100000 ether);
        tusdc.mint(0x9DCCe783B6464611f38631e6C851bf441907c710, 100000 ether);
    }
}
