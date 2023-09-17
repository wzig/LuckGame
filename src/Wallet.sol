// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
// import "../lib/openzeppelin-contracts/contracts/proxy/Proxy.sol";
import "./Lottery.sol";
import "./IWallet.sol";

// import "../lib/forge-std/src/Test.sol";

contract Wallet is Ownable, IWallet {
    uint public cap;

    // Declare state variable for the other contract
    Lottery public lotteryContract;

    constructor(address dest, uint _cap) Ownable(dest) {
        cap = _cap;
        lotteryContract = Lottery(dest);
    }

    receive() external payable {
        require(
            (msg.value % (cap * 1e15)) == 0 && msg.value <= (cap * 5e17),
            "amount error"
        );

        lotteryContract._deposit(cap, msg.sender, msg.value);
    }

    // fallback() external payable {
    //     require(
    //         (msg.value % (cap * 1e15)) != 0 || msg.value > (cap * 5e17),
    //         "amount error"
    //     );
    //     lotteryContract._deposit(cap, msg.sender, msg.value);
    // }

    function sendEther(
        address payable to,
        uint256 _amount // ) public payable override onlyOwner {
    ) public payable override {
        (bool sent, bytes memory _data) = address(to).call{value: _amount}("");
        require(sent, "Failed to sendEther");
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
