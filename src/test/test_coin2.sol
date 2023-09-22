// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/forge-std/src/Test.sol";
import "../Luck.sol";
import "../IWallet.sol";
import "../Wallet.sol";
import "./TUSDC.sol";

contract LotteryTest2 is Test {
    Luck public instance;
    Wallet public instanceWallet;
    TUSDC public tusdcUnstance;
    uint forkID;

    function _setUp() public {
        forkID = vm.createSelectFork("mainnet", 17999182);

        address owner = 0x060FcF541c7444F439C0c4e83001634853dc59Da;
        vm.deal(owner, 1000 ether);

        vm.prank(owner);
        instance = new Luck();
        instanceWallet = new Wallet(address(instance), 100);
        tusdcUnstance = new TUSDC();

        emit log_named_address(
            "instanceWallet owner()",
            instanceWallet.owner()
        );

        vm.prank(owner);
        instance.setAllowMap(100, address(instanceWallet));

        vm.prank(owner);
        instance.setCoinConfig(address(tusdcUnstance), 1000, 6);

        emit log_named_address("address(instance)", address(instance));
        emit log_named_address("instance.owner()", instance.owner());

        emit log_string("====> start");

        emit log_named_address("instance.owner()", instance.owner()); // do not remove this line, forge bug
    }

    function testName2() public {
        _setUp();
        address addr = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.deal(addr, 1000 ether);
        tusdcUnstance.mint(addr, 1000_000 ether);
        address addr2 = 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955;
        vm.deal(addr2, 1000 ether);
        tusdcUnstance.mint(addr2, 1000_000 ether);

        for (uint i = 0; i < 1; i++) {
            vm.prank(addr); // Sets the *next* call's msg.sender to be the input address
            tusdcUnstance.approve(address(instanceWallet), 100 ether);
            vm.prank(addr); // Sets the *next* call's msg.sender to be the input address
            instanceWallet.erc20Deposit(address(tusdcUnstance), 100 ether); // deposit

            vm.prank(addr2); // Sets the *next* call's msg.sender to be the input address
            tusdcUnstance.approve(address(instanceWallet), 100 ether);
            vm.prank(addr2);
            instanceWallet.erc20Deposit(address(tusdcUnstance), 100 ether); // deposit
        }
        uint currentIndex = block.number / 100;

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
                address(tusdcUnstance)
            )
        );

        emit log_named_uint(
            "instance.getCoinConfig()",
            instance.getCoinConfig(address(tusdcUnstance))
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

        vm.rollFork(forkID, 17999182 + 20000);

        vm.expectRevert();
        vm.prank(addr);
        instance.lottery(100, address(0x1), 900);

        vm.expectRevert();
        vm.prank(addr);
        instance.lottery(100, address(tusdcUnstance), 900);

        vm.prank(addr);
        instance.lottery(100, address(tusdcUnstance), 899);

        vm.expectRevert();
        vm.prank(addr);
        instance.lottery(100, address(tusdcUnstance), 899);

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
            "instanceWallet.getBalanceOf(address(tusdcUnstance))",
            instanceWallet.getBalanceOf(address(tusdcUnstance))
        );
    }
}
