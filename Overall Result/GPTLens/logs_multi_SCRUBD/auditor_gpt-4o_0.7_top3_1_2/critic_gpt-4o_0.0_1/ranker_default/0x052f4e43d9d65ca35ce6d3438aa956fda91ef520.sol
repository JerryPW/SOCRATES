[
    {
        "function_name": "swapBack",
        "vulnerability": "Potential Loss Due to Slippage",
        "criticism": "The reasoning is partially correct. The swapBack function does not explicitly handle slippage, which could lead to receiving less ETH than expected. However, the impact of this is limited to the contract's internal operations and does not directly affect users' funds. The severity is moderate due to potential operational issues, but the profitability is low as it does not provide a direct avenue for exploitation.",
        "correctness": 6,
        "severity": 4,
        "profitability": 1,
        "reason": "The swapBack function calculates the amount to swap without considering slippage which might result in less ETH received than expected. If the amountBNB is lower than expected, it might lead to insufficient fund errors during subsequent transfers to designated wallets.",
        "code": "function swapBack() private nonReentrant { uint256 splitLiquidityPortion = lpPortionOfSwap.div(2); uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR); uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify); uint256 balanceBefore = address(this).balance; swapTokensForETH(amountToSwap); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBDevolpment = amountBNB.mul(devolpmentPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR); transferToAddress(payable(marketingWallet), amountBNBMarketing); transferToAddress(payable(devolpmentWallet), amountBNBDevolpment); _addLiquidity(amountToLiquify, amountBNBLiquidity); }",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol",
        "final_score": 4.25
    },
    {
        "function_name": "transfer",
        "vulnerability": "Blacklist Bypass",
        "criticism": "The reasoning is incorrect. The transfer function calls the _transfer function, which includes a check for blacklisted addresses. Therefore, the claim that blacklisted addresses can bypass restrictions is not valid. The correctness of the reasoning is low, and since the vulnerability does not exist, the severity and profitability are also zero.",
        "correctness": 2,
        "severity": 0,
        "profitability": 0,
        "reason": "The transfer function does not check if the recipient is blacklisted before allowing the transfer. This allows blacklisted addresses to still receive tokens, bypassing the blacklist restrictions.",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool){ _transfer(_msgSender(), recipient, amount); return true; }",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol",
        "final_score": 1.0
    },
    {
        "function_name": "_transfer",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning is incorrect. The _transfer function does not involve any external calls that could lead to reentrancy. It primarily performs internal checks and balance updates. The use of the nonReentrant modifier is unnecessary in this context. Therefore, the correctness of the reasoning is low, and the severity and profitability are zero.",
        "correctness": 1,
        "severity": 0,
        "profitability": 0,
        "reason": "The _transfer function performs checks and updates balances, but it does not utilize the nonReentrant modifier, leaving it potentially vulnerable to reentrancy attacks in complex scenarios where external calls might be involved.",
        "code": "function _transfer(address sender, address recipient, uint256 amount) private { require(sender != address(0), \"Token: transfer from the zero address\"); require(recipient != address(0), \"Token: transfer to the zero address\"); require(sender != address(deadAddress), \"Token: transfer from the burn address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(tradingIsEnabled, \"This account cannot send tokens until trading is enabled\"); require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], \"Blacklisted address\"); if ( sender != address(router) && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] ) { require(amount <= maxTxAmount, \"Transfer amount exceeds the Max Transaction Amount.\"); } if ( maxWalletBalance > 0 && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] && recipient != address(pair) ) { uint256 recipientBalance = balanceOf(recipient); require(recipientBalance + amount <= maxWalletBalance, \"New balance would exceed the maxWalletBalance\"); } bool _isTakeFee = takeFeeEnabled; if ( isInPresale ){ _isTakeFee = false; } if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _isTakeFee = false; } _beforeTokenTransfer(recipient); _transferTokens(sender, recipient, amount, _isTakeFee); }",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol",
        "final_score": 0.5
    }
]