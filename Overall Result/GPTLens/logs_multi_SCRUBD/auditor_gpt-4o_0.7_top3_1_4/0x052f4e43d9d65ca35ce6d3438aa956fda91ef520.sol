[
    {
        "function_name": "swapBack",
        "code": "function swapBack() private nonReentrant { uint256 splitLiquidityPortion = lpPortionOfSwap.div(2); uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR); uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify); uint256 balanceBefore = address(this).balance; swapTokensForETH(amountToSwap); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBDevolpment = amountBNB.mul(devolpmentPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR); transferToAddress(payable(marketingWallet), amountBNBMarketing); transferToAddress(payable(devolpmentWallet), amountBNBDevolpment); _addLiquidity(amountToLiquify, amountBNBLiquidity); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The `swapBack` function, although protected by a nonReentrant modifier, involves external calls to untrusted contracts (e.g., the router) which can lead to a potential reentrancy attack if the router or the token being swapped has a fallback function that makes a call back to this contract. This can lead to unexpected manipulations and draining of funds.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) private { require(sender != address(0), \"Token: transfer from the zero address\"); require(recipient != address(0), \"Token: transfer to the zero address\"); require(sender != address(deadAddress), \"Token: transfer from the burn address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(tradingIsEnabled, \"This account cannot send tokens until trading is enabled\"); require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], \"Blacklisted address\"); if ( sender != address(router) && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] ) { require(amount <= maxTxAmount, \"Transfer amount exceeds the Max Transaction Amount.\"); } if ( maxWalletBalance > 0 && !_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] && recipient != address(pair) ) { uint256 recipientBalance = balanceOf(recipient); require(recipientBalance + amount <= maxWalletBalance, \"New balance would exceed the maxWalletBalance\"); } bool _isTakeFee = takeFeeEnabled; if ( isInPresale ){ _isTakeFee = false; } if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _isTakeFee = false; } _beforeTokenTransfer(recipient); _transferTokens(sender, recipient, amount, _isTakeFee); }",
        "vulnerability": "Lack of proper slippage protection",
        "reason": "The `_transfer` function does not include a mechanism to handle slippage when transferring tokens, especially when `swapBack` is triggered. This could result in failed transactions or severe losses for users if the price changes significantly during the transaction process.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "transferToAddress",
        "code": "function transferToAddress(address payable recipient, uint256 amount) private { require(recipient != address(0), \"Cannot transfer the ETH to a zero address\"); recipient.transfer(amount); }",
        "vulnerability": "Lack of error handling in ETH transfer",
        "reason": "The `transferToAddress` function uses the `transfer` method which only forwards 2300 gas and does not provide a way to handle any potential errors if the recipient is a smart contract with a complex fallback function. This could lead to failed transactions and locked funds if the transfer fails.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    }
]