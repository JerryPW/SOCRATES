[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { _transfer(sender, recipient, amount); uint256 currentAllowance = _allowances[sender][msg.sender]; require(currentAllowance >= amount); unchecked { _approve(sender, msg.sender, currentAllowance - amount); } return true; }",
        "vulnerability": "Missing allowance check before transfer",
        "reason": "The function `transferFrom` does not enforce the allowance check before calling the `_transfer` function. This allows an attacker to transfer tokens on behalf of the sender without sufficient allowance, as the allowance is checked and updated only after the transfer occurs.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "makeLiquidity",
        "code": "function makeLiquidity() public onlyOwner { require(uniswapV2Pair == address(0)); address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair( address(this), _uniswapV2Router.WETH() ); _balances[address(this)] = _totalSupply; _allowances[address(this)][address(_uniswapV2Router)] = _totalSupply; _isExcludedFromFee[pair] = true; _uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), _totalSupply, 0, 0, msg.sender, block.timestamp ); uniswapV2Pair = pair; tradingEnable = true; incrementTime = block.timestamp; maxBuyIncrementValue = (_totalSupply * maxByyIncrementPercentil) / 1000; }",
        "vulnerability": "Potential for rug pull via liquidity removal",
        "reason": "The `makeLiquidity` function allows the owner to create a liquidity pool with all tokens from the contract's balance. If the owner has malicious intent, they could later remove the liquidity, effectively executing a rug pull and capturing the entire pool's ETH.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "_getFeeSell",
        "code": "function _getFeeSell(uint256 amount, address account) private returns (uint256) { uint256 devFee = amount / 12; uint256 burnCount = getSellBurnCount(amount); amount -= devFee + burnCount; _balances[account] -= devFee + burnCount; _balances[address(this)] += devFee; _totalSupply -= burnCount; emit Transfer(address(this), address(0), burnCount); return amount; }",
        "vulnerability": "Insecure balance manipulation",
        "reason": "In function `_getFeeSell`, the balance of `account` is decremented by `devFee` and `burnCount` without verifying if the account has sufficient balance. This could lead to underflow errors or unwanted token behavior if the balance is not properly managed.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    }
]