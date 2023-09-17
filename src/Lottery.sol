// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
// import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
// import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "./map.sol";
import "./IWallet.sol";

// import "../lib/forge-std/src/Test.sol";

/// @custom:security-contact qq@qq.com
contract Lottery is ERC20, Ownable {
    using Iterable2UintMapping for Iterable2UintMapping.Map;
    Iterable2UintMapping.Map private lotteryPool;

    uint private lotteryBlockNum;

    // token currenttly for commemorative
    constructor() ERC20("Lottery", "Lottery") Ownable(msg.sender) {
        lotteryBlockNum = 2000;
        _mint(msg.sender, 10_000_000 * 10 ** decimals()); // kind of for commemorative
    }

    modifier onlyAllowMap() {
        _checkAllowMap();
        _;
    }

    function checkAllow() internal view returns (bool) {
        return lotteryPool.allowMapRev[_msgSender()] > 0;
    }

    function _checkAllowMap() internal view virtual {
        if (!checkAllow()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    function setLotteryBlockNum(uint _lotteryBlockNum) public onlyOwner {
        // change lottery gap
        lotteryBlockNum = _lotteryBlockNum;
    }

    function setAllowMap(uint cap, address addr1) public onlyOwner {
        lotteryPool.allowMap[cap] = addr1; // 1
        lotteryPool.allowMapRev[addr1] = cap; // 1
    }

    function getLotteryBlockNum() public view returns (uint) {
        return lotteryBlockNum;
    }

    function getLotteryPoolKeys() public view returns (uint[] memory) {
        return lotteryPool.keys;
    }

    function getLotteryPoolKeys2(
        uint index,
        uint cap
    ) public view returns (address[] memory) {
        return lotteryPool.keys2[index][cap];
    }

    function getLotteryPoolTotal(
        uint index,
        uint cap
    ) public view returns (uint256) {
        return lotteryPool.poolTotal[index][cap];
    }

    function getUserCurrentDeposit(
        uint index,
        uint cap,
        address addr
    ) public view returns (uint256) {
        return lotteryPool.values[index][cap][addr];
    }

    function getLotteryAllowMap(uint cap) public view returns (address) {
        return lotteryPool.allowMap[cap];
    }

    function _deposit(
        uint cap,
        address _sender,
        uint256 amount
    ) public payable onlyAllowMap {
        require(amount > 0, "amount <= 0");
        uint currentIndex = block.number / lotteryBlockNum;
        require(
            lotteryPool.poolTotal[currentIndex][cap] < cap * 1e18,
            "overflow cap"
        );
        require(
            lotteryPool.poolTotal[currentIndex][cap] + amount <= cap * 11e17,
            "overflow cap"
        );

        lotteryPool.add(currentIndex, cap, _sender, amount);

        _mint(_sender, amount * lotteryBlockNum);
    }

    function lottery(uint cap, uint roundNum) public {
        uint _index = block.number / lotteryBlockNum - 1; // last pool
        require(roundNum <= _index, "round number error");
        _lottery(roundNum, cap);
    }

    function _lottery(uint index, uint cap) private {
        require(lotteryPool.poolTotal[index][cap] > 0, "pool is 0");

        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.prevrandao, // almost unpredictable for previous block
                    block.number,
                    blockhash(block.timestamp - 1),
                    msg.sender
                )
            )
        ) % (lotteryPool.poolTotal[index][cap]);

        uint256 tmp = 0;
        for (uint i = 0; i < lotteryPool.keys2[index][cap].length; i++) {
            address addr = lotteryPool.keys2[index][cap][i];
            tmp += lotteryPool.values[index][cap][addr];

            if (tmp >= randomNumber) {
                for (
                    uint j = 0;
                    j < lotteryPool.keys2[index][cap].length;
                    j++
                ) {
                    if (i == j) {
                        continue;
                    }
                    address other = lotteryPool.keys2[index][cap][j];
                    _balances[other] +=
                        lotteryPool.values[index][cap][other] *
                        lotteryBlockNum;
                    _totalSupply +=
                        lotteryPool.values[index][cap][other] *
                        lotteryBlockNum;
                }
                uint256 feeService = lotteryPool.poolTotal[index][cap] / 100; // fee = 0.5 % , not like greedy 5%, or even 10% (ft)
                uint256 feeTrigger = feeService;

                IWallet(lotteryPool.allowMap[cap]).sendEther(
                    payable(owner()),
                    feeService
                );

                IWallet(lotteryPool.allowMap[cap]).sendEther(
                    payable(msg.sender),
                    feeTrigger
                );
                IWallet(lotteryPool.allowMap[cap]).sendEther(
                    payable(addr),
                    lotteryPool.poolTotal[index][cap] - feeService - feeTrigger
                );

                lotteryPool.poolTotal[index + 1e8][cap] = lotteryPool.poolTotal[
                    index
                ][cap]; // history total amount
                lotteryPool.poolTotal[index][cap] = 0;

                break;
            }
        }
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        super._update(from, to, amount);
    }
}
