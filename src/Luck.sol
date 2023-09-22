// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./map.sol";
import "./IWallet.sol";

// import "../lib/forge-std/src/Test.sol";

/// @custom:security-contact
contract Luck is ERC20, Ownable {
    using Iterable2UintMapping for Iterable2UintMapping.Map;
    Iterable2UintMapping.Map private lotteryPool;

    uint private lotteryBlockNum;
    mapping(address => uint256[]) private coinConfig;

    // token currenttly for commemorative
    constructor() ERC20("Luck", "Luck") Ownable(msg.sender) {
        lotteryBlockNum = 20000;
        _mint(msg.sender, 1_000_000 * 10 ** decimals()); // kind of for commemorative
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

    function setCoinConfig(
        address coin,
        uint r,
        uint decimal
    ) public onlyOwner {
        // roughly eth/coin
        if (coinConfig[coin].length > 1) {
            coinConfig[coin][0] = r;
            coinConfig[coin][1] = decimal;
        } else {
            coinConfig[coin].push(r);
            coinConfig[coin].push(decimal);
        }
    }

    function setAllowMap(uint cap, address addr1) public onlyOwner {
        lotteryPool.allowMap[cap] = addr1; // 1
        lotteryPool.allowMapRev[addr1] = cap; // 1
    }

    function getCoinConfig(address coin) public view returns (uint) {
        return coinConfig[coin][0];
    }

    function getLotteryBlockNum() public view returns (uint) {
        return lotteryBlockNum;
    }

    function getLotteryPoolKeys(uint cap) public view returns (uint[] memory) {
        return lotteryPool.keys[cap];
    }

    function getLotteryPoolKeys2(
        uint index,
        uint cap,
        address coin
    ) public view returns (address[] memory) {
        return lotteryPool.keys2[index][cap][coin];
    }

    function getLotteryPoolTotal(
        uint index,
        uint cap,
        address coin
    ) public view returns (uint256) {
        return lotteryPool.poolTotal[index][cap][coin];
    }

    function getLuckUser(
        uint index,
        uint cap,
        address coin
    ) public view returns (address) {
        return lotteryPool.luckUser[index][cap][coin];
    }

    function getDrawler(
        uint index,
        uint cap,
        address coin
    ) public view returns (address) {
        return lotteryPool.drawler[index][cap][coin];
    }

    function getUserCurrentDeposit(
        uint index,
        uint cap,
        address coin,
        address addr
    ) public view returns (uint256) {
        return lotteryPool.values[index][cap][coin][addr];
    }

    function getLotteryAllowMap(uint cap) public view returns (address) {
        return lotteryPool.allowMap[cap];
    }

    function _deposit(
        uint cap,
        address coin,
        address _sender,
        uint256 amount
    ) public payable onlyAllowMap {
        require(amount > 0, "amount <= 0");
        uint r = 1;
        uint d = 18;
        if (coin != address(0x0000000000000000000000000000000000000000)) {
            r = coinConfig[coin][0];
            d = coinConfig[coin][1];
        }
        require(r > 0, "coin not support");

        uint currentIndex = block.number / lotteryBlockNum;
        require(
            lotteryPool.poolTotal[currentIndex][cap][coin] < cap * r * 1e18,
            "overflow cap"
        );
        require(
            lotteryPool.poolTotal[currentIndex][cap][coin] + amount <=
                cap * r * 11e17,
            "overflow cap"
        );

        lotteryPool.add(currentIndex, cap, coin, _sender, amount);

        _mint(_sender, (amount * lotteryBlockNum * 10 ** (18 - d)) / r);
    }

    function lottery(uint cap, address coin, uint roundNum) public {
        uint _index = block.number / lotteryBlockNum - 1; // last pool
        require(roundNum <= _index, "round number error");
        _lottery(roundNum, cap, coin);
    }

    function _lottery(uint index, uint cap, address coin) private {
        require(lotteryPool.poolTotal[index][cap][coin] > 0, "pool is 0");

        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.prevrandao, // unpredictable for previous block
                    block.number,
                    blockhash(block.timestamp - 1),
                    msg.sender
                )
            )
        ) % (lotteryPool.poolTotal[index][cap][coin]);

        uint256 tmp = 0;
        for (uint i = 0; i < lotteryPool.keys2[index][cap][coin].length; i++) {
            address addr = lotteryPool.keys2[index][cap][coin][i];
            tmp += lotteryPool.values[index][cap][coin][addr];

            if (tmp >= randomNumber) {
                for (
                    uint j = 0;
                    j < lotteryPool.keys2[index][cap][coin].length;
                    j++
                ) {
                    if (i == j) {
                        continue;
                    }
                    address other = lotteryPool.keys2[index][cap][coin][j];
                    _balances[other] +=
                        lotteryPool.values[index][cap][coin][other] *
                        lotteryBlockNum;
                    _totalSupply +=
                        lotteryPool.values[index][cap][coin][other] *
                        lotteryBlockNum;
                }
                uint256 feeService = lotteryPool.poolTotal[index][cap][coin] /
                    100; // fee = 0.5 % , not like greedy 5%, or even 10% (ft)
                uint256 feeTrigger = feeService;

                _distribute(index, cap, coin, addr, feeService, feeTrigger);

                lotteryPool.luckUser[index][cap][coin] = addr;
                lotteryPool.drawler[index][cap][coin] = msg.sender;

                lotteryPool.poolTotal[index + 1e8][cap][coin] = lotteryPool
                    .poolTotal[index][cap][coin]; // history total amount
                lotteryPool.poolTotal[index][cap][coin] = 0;

                break;
            }
        }
    }

    function _distribute(
        uint index,
        uint cap,
        address coin,
        address addr,
        uint feeService,
        uint feeTrigger
    ) private {
        if (coin == address(0x0000000000000000000000000000000000000000)) {
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
                lotteryPool.poolTotal[index][cap][coin] -
                    feeService -
                    feeTrigger
            );
        } else {
            IWallet(lotteryPool.allowMap[cap]).erc20Withdraw(
                payable(owner()),
                coin,
                feeService
            );

            IWallet(lotteryPool.allowMap[cap]).erc20Withdraw(
                payable(msg.sender),
                coin,
                feeTrigger
            );
            IWallet(lotteryPool.allowMap[cap]).erc20Withdraw(
                payable(addr),
                coin,
                lotteryPool.poolTotal[index][cap][coin] -
                    feeService -
                    feeTrigger
            );
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
