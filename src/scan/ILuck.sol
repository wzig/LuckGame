// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ERC20.sol";
import "./Ownable.sol";
import "./map.sol";
import "./IWallet.sol";

abstract contract ILuck {
    function _deposit(
        uint cap,
        address coin,
        address _sender,
        uint256 amount
    ) public payable virtual;
}
