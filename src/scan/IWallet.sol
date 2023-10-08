pragma solidity ^0.8.19;

abstract contract IWallet {
    function sendEther(
        address payable to,
        uint256 _amount
    ) public payable virtual;

    function erc20Deposit(
        address tokenAddress,
        uint256 amount
    ) external virtual;

    function erc20Withdraw(
        address to,
        address tokenAddress,
        uint256 amount
    ) external virtual;
}
