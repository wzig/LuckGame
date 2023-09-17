pragma solidity ^0.8.19;

abstract contract IWallet {
    function sendEther(address payable to, uint256 _amount) public payable virtual;
}
