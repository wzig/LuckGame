// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/forge-std/src/Test.sol";
import "../scan/Luck.sol";
import "../scan/IWallet.sol";
import "../scan/Wallet.sol";

contract LotteryTest is Test {
    Luck public instance;
    Wallet public instanceWallet;
    uint forkID;

    function _setUp() public {
        forkID = vm.createSelectFork("mainnet", 17999182);

        address owner = 0x060FcF541c7444F439C0c4e83001634853dc59Da;
        vm.deal(owner, 1000 ether);

        vm.prank(owner);
        instance = new Luck();
        instanceWallet = new Wallet(address(instance), 1);

        emit log_named_address(
            "instanceWallet owner()",
            instanceWallet.owner()
        );

        vm.prank(owner);
        instance.setAllowMap(1, address(instanceWallet));

        emit log_named_address("address(instance)", address(instance));
        emit log_named_address("instance.owner()", instance.owner());

        emit log_string("====> start");

        emit log_named_address("instance.owner()", instance.owner()); // do not remove this line, forge bug
    }

    function testName() public {
        _setUp();
        address addr = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.deal(addr, 1000 ether);
        address addr2 = 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955;
        vm.deal(addr2, 1000 ether);

        for (uint i = 0; i < 1; i++) {
            vm.prank(addr); // Sets the *next* call's msg.sender to be the input address
            (bool sent, bytes memory _data) = address(instanceWallet).call{
                value: 0.5 ether
            }(""); // deposit

            require(sent, "Failed to send ether");

            vm.prank(addr2);
            (sent, _data) = address(instanceWallet).call{value: 0.5 ether}("");
            require(sent, "Failed to send ether");
        }
        uint currentIndex = block.number / 8000;

        emit log_named_uint("currentIndex", currentIndex);
        emit log_named_address(
            "getLotteryAllowMap",
            instance.getLotteryAllowMap(1)
        );

        emit log_named_uint(
            "instance.getLotteryPoolTotal()",
            instance.getLotteryPoolTotal(
                currentIndex,
                1,
                address(0x0000000000000000000000000000000000000000)
            )
        );

        emit log_named_decimal_uint(
            "instance.balanceOf(addr)",
            instance.balanceOf(addr),
            instance.decimals()
        );
        emit log_string("====> balance");

        emit log_named_decimal_uint("addr.balance", addr.balance, 18);
        emit log_named_decimal_uint(
            "address(instance).balance",
            address(instance).balance,
            18
        );

        emit log_string("====> lottery");

        vm.rollFork(forkID, 17999182 + 8000);

        vm.prank(addr);
        vm.expectRevert();
        instance.lottery(
            1,
            address(0x0000000000000000000000000000000000000000),
            currentIndex + 1
        );

        emit log_named_uint(
            "==============>instance.getLotteryPoolTotal()",
            instance.getLotteryPoolTotal(
                currentIndex,
                1,
                address(0x0000000000000000000000000000000000000000)
            )
        );
        vm.prank(addr);
        instance.lottery(
            1,
            address(0x0000000000000000000000000000000000000000),
            currentIndex
        );

        vm.expectRevert();
        vm.prank(addr);
        instance.lottery(
            1,
            address(0x0000000000000000000000000000000000000000),
            currentIndex
        );

        emit log_named_decimal_uint(
            "instance.balanceOf(addr)",
            instance.balanceOf(addr),
            instance.decimals()
        );
        emit log_named_decimal_uint(
            "instance.totalSupply()",
            instance.totalSupply(),
            18
        );

        emit log_string("====> balance");

        emit log_named_decimal_uint("addr.balance", addr.balance, 18);
        emit log_named_decimal_uint("addr2.balance", addr2.balance, 18);
        emit log_named_decimal_uint(
            "address(instanceWallet).balance",
            address(instanceWallet).balance,
            18
        );
        emit log_named_decimal_uint(
            "instance.owner().balance",
            instance.owner().balance,
            18
        );

        emit log_named_address("instance.owner()", instance.owner());

        emit log_named_uint(
            "instanceWallet owner()",
            instanceWallet.getBalance()
        );
    }
}
