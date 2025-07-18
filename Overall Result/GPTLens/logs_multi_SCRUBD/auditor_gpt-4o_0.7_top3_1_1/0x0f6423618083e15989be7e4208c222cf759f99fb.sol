[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { _transfer(sender, recipient, amount); uint256 currentAllowance = _allowances[sender][msg.sender]; require(currentAllowance >= amount); unchecked { _approve(sender, msg.sender, currentAllowance - amount); } return true; }",
        "vulnerability": "Missing Approval Check Before Transfer",
        "reason": "The transferFrom function allows a transfer of tokens before checking if the caller has sufficient allowance. This means that the _transfer function can be called and tokens can be moved before verifying if the caller is authorized to transfer the specific amount. As a result, an attacker can exploit this to transfer more tokens than allowed if the transfer fails after the transfer logic but before the allowance check.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "_getFeeSell",
        "code": "function _getFeeSell(uint256 amount, address account) private returns (uint256) { uint256 devFee = amount / 12; uint256 burnCount = getSellBurnCount(amount); amount -= devFee + burnCount; _balances[account] -= devFee + burnCount; _balances[address(this)] += devFee; _totalSupply -= burnCount; emit Transfer(address(this), address(0), burnCount); return amount; }",
        "vulnerability": "Incorrect Balance Deduction",
        "reason": "The function _getFeeSell deducts the devFee and burnCount from the specified account's balance without checking if the account has enough balance to cover both values. This can lead to a situation where an account's balance becomes negative, causing incorrect balances and potential exploits.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "makeLiquidity",
        "code": "function makeLiquidity() public onlyOwner { require(uniswapV2Pair == address(0)); address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair( address(this), _uniswapV2Router.WETH() ); _balances[address(this)] = _totalSupply; _allowances[address(this)][address(_uniswapV2Router)] = _totalSupply; _isExcludedFromFee[pair] = true; _uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), _totalSupply, 0, 0, msg.sender, block.timestamp ); uniswapV2Pair = pair; tradingEnable = true; incrementTime = block.timestamp; maxBuyIncrementValue = (_totalSupply * maxByyIncrementPercentil) / 1000; }",
        "vulnerability": "Potential Loss of ETH in Liquidity Addition",
        "reason": "The makeLiquidity function does not account for any ETH already present in the contract before calling addLiquidityETH, which sends the entire balance as liquidity. If any ETH was sent to the contract inadvertently or for other purposes, it will be included in the liquidity pool unintentionally, leading to a potential loss of ETH.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    }
]