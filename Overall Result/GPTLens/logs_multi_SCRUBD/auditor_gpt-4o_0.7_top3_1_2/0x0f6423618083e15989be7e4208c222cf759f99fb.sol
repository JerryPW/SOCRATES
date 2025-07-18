[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { _transfer(sender, recipient, amount); uint256 currentAllowance = _allowances[sender][msg.sender]; require(currentAllowance >= amount); unchecked { _approve(sender, msg.sender, currentAllowance - amount); } return true; }",
        "vulnerability": "Missing allowance check before transfer",
        "reason": "The function `transferFrom` performs the token transfer without checking if the sender has sufficient allowance. The allowance check is done after the transfer, which means an attacker could transfer tokens without having the required allowance initially.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "_getFeeSell",
        "code": "function _getFeeSell(uint256 amount, address account) private returns (uint256) { uint256 devFee = amount / 12; uint256 burnCount = getSellBurnCount(amount); amount -= devFee + burnCount; _balances[account] -= devFee + burnCount; _balances[address(this)] += devFee; _totalSupply -= burnCount; emit Transfer(address(this), address(0), burnCount); return amount; }",
        "vulnerability": "Incorrect balance deduction",
        "reason": "The function `_getFeeSell` deducts the `devFee` and `burnCount` from the `account` balance without ensuring that `account` has sufficient balance after deducting these fees. This could lead to negative balances which is a serious issue in a token contract.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "makeLiquidity",
        "code": "function makeLiquidity() public onlyOwner { require(uniswapV2Pair == address(0)); address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair( address(this), _uniswapV2Router.WETH() ); _balances[address(this)] = _totalSupply; _allowances[address(this)][address(_uniswapV2Router)] = _totalSupply; _isExcludedFromFee[pair] = true; _uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), _totalSupply, 0, 0, msg.sender, block.timestamp ); uniswapV2Pair = pair; tradingEnable = true; incrementTime = block.timestamp; maxBuyIncrementValue = (_totalSupply * maxByyIncrementPercentil) / 1000; }",
        "vulnerability": "Reentrancy risk during liquidity provision",
        "reason": "The `makeLiquidity` function involves transferring the entire contract balance to the liquidity pool without using reentrancy guard, which can be potentially exploited by reentrant calls if the external call in `addLiquidityETH` triggers a fallback function that calls back into the contract.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    }
]