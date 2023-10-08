// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./Ownable.sol";
import "./ILuck.sol";
import "./IWallet.sol";
import "./IUSDT.sol";

contract Wallet is Ownable, IWallet {
    uint public cap;

    // Declare state variable for the other contract
    ILuck public lotteryContract;

    constructor(address dest, uint _cap) Ownable(dest) {
        cap = _cap;
        lotteryContract = ILuck(dest);
    }

    receive() external payable {
        require(
            (msg.value % (cap * 1e15)) == 0 && msg.value <= (cap * 5e17),
            "amount error"
        );

        lotteryContract._deposit(
            cap,
            address(0x0000000000000000000000000000000000000000),
            msg.sender,
            msg.value
        );
    }

    uint256 private guardCounter;

    modifier nonReentrant() {
        require(guardCounter == 0, "Reentrant call detected");
        guardCounter = 1;
        _;
        guardCounter = 0;
    }

    function sendEther(
        address payable to,
        uint256 _amount
    ) public payable override onlyOwner nonReentrant {
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
        if (tokenAddress != 0xdAC17F958D2ee523a2206206994597C13D831ec7) {
            IERC20 token = IERC20(tokenAddress);
            require(
                token.transferFrom(msg.sender, address(this), amount), // approve first
                "Transfer Token failed"
            );
        } else {
            IUSDT token = IUSDT(tokenAddress); // usdt
            token.transferFrom(msg.sender, address(this), amount);
        }
        balances[tokenAddress] += amount;
        lotteryContract._deposit(cap, tokenAddress, msg.sender, amount);
    }

    // Withdraw tokens from the wallet
    function erc20Withdraw(
        address to,
        address tokenAddress,
        uint256 amount
    ) external override onlyOwner nonReentrant {
        require(balances[tokenAddress] >= amount, "Insufficient Token balance");
        balances[tokenAddress] -= amount;
        if (tokenAddress != 0xdAC17F958D2ee523a2206206994597C13D831ec7) {
            IERC20 token = IERC20(tokenAddress);
            require(token.transfer(to, amount), "Transfer Token failed");
        } else {
            IUSDT token = IUSDT(tokenAddress); // usdt
            token.transfer(to, amount);
        }
    }

    // Check the balance of a specific token for a user
    function getBalanceOf(
        address tokenAddress
    ) external view returns (uint256) {
        return balances[tokenAddress];
    }
}
