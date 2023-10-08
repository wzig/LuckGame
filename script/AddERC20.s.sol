// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/Luck.sol";
import "../src/Wallet.sol";

contract LotteryScript is Script {
    function setUp() public {}

    Luck instance;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        instance = Luck(0xc48078a734c2e22D43F54B47F7a8fB314Fa5A601);
        instance.setCoinConfig( // shib
            address(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE),
            130000000,
            18
        );
    }
}
