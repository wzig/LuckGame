// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./Lottery.sol";
import "./IWallet.sol";

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

        lotteryContract._deposit(cap, address(0x0000000000000000000000000000000000000000), msg.sender, msg.value);
    }

    function sendEther(
        address payable to,
        uint256 _amount
    ) public payable override onlyOwner {
        (bool sent, bytes memory _data) = address(to).call{value: _amount}("");
        require(sent, "Failed to sendEther");
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    // Mapping to track balances of different tokens
    mapping(address => uint256) public balances;

    // Deposit tokens into the wallet
    function erc20Deposit(
        address tokenAddress,
        uint256 amount
    ) external override {
        require(amount > 0, "Amount must be greater than 0");
        IERC20 token = IERC20(tokenAddress);
        require(
            token.transferFrom(msg.sender, address(this), amount), // approve first
            "Transfer Token failed"
        );
        balances[tokenAddress] += amount;
        lotteryContract._deposit(cap, tokenAddress, msg.sender, amount);
    }

    // Withdraw tokens from the wallet
    function erc20Withdraw(
        address to,
        address tokenAddress,
        uint256 amount
    ) external override onlyOwner {
        require(balances[tokenAddress] >= amount, "Insufficient Token balance");
        IERC20 token = IERC20(tokenAddress);
        balances[tokenAddress] -= amount;
        require(token.transfer(to, amount), "Transfer Token failed");
    }

    // Check the balance of a specific token for a user
    function getBalanceOf(
        address tokenAddress
    ) external view returns (uint256) {
        return balances[tokenAddress];
    }
}
