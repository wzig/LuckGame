// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../scan/ERC20.sol";
import "../scan/map.sol";

/// @custom:security-contact
contract TUSDC is ERC20 {
    constructor() ERC20("TUSDC", "TUSDC") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
