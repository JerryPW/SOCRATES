[
    {
        "function_name": "forceSend",
        "code": "function forceSend() external onlyOwner { (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Missing error handling in ether transfer",
        "reason": "The function uses low-level call to transfer balance to feeWallet, but the success check is incorrectly set to false immediately after the call. This can result in ether being sent to a contract that does not have a payable fallback function without checking if the transfer was successful.",
        "file_name": "0x0a16d08b57afe4e0e323eba83e0282b07c2ed1f1.sol"
    },
    {
        "function_name": "forceSwap",
        "code": "function forceSwap() external onlyOwner { _swapTokensForEth(balanceOf(address(this))); (bool success,) = address(feeWallet).call{value : address(this).balance}(\"\"); success = false; }",
        "vulnerability": "Unverified ether transfer",
        "reason": "Similar to the forceSend function, this function performs a low-level call to transfer ether to feeWallet, setting the success variable to false immediately after. This can cause ether to be sent without confirming the success of the transaction, leading to potential loss of funds if the target address is not capable of accepting ether.",
        "file_name": "0x0a16d08b57afe4e0e323eba83e0282b07c2ed1f1.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(!_isBlacklisted[from], \"Your address has been marked as a sniper, you are unable to transfer or swap.\"); if (amount == 0) { super._transfer(from, to, 0); return; } if(tradingActive) { require(block.number >= _launchBlock + deadBlocks, \"NOT BOT\"); } if (limitsInEffect) { if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_swapping ) { if (!tradingActive) { require(_isExcludedFromFees[from] || _isExcludedFromFees[to], \"Trading is not active.\"); } if (balanceOf(to) == 0 && _holderFirstBuyTimestamp[to] == 0) { _holderFirstBuyTimestamp[to] = block.timestamp; } if (transferDelayEnabled) { if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"); _holderLastTransferTimestamp[tx.origin] = block.number; } } if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) { require(amount <= maxTransactionAmount, \"Buy transfer amount exceeds the maxTransactionAmount.\"); require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\"); } else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) { require(amount <= maxTransactionAmount, \"Sell transfer amount exceeds the maxTransactionAmount.\"); } else if (!_isExcludedMaxTransactionAmount[to]) { require(amount + balanceOf(to) <= maxWallet, \"Max wallet exceeded\"); } } } uint256 contractTokenBalance = balanceOf(address(this)); bool canSwap = contractTokenBalance >= swapTokensAtAmount; if ( canSwap && !_swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to] ) { _swapping = true; swapBack(); _swapping = false; } bool takeFee = !_swapping; if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) { takeFee = false; } uint256 fees = 0; if (takeFee) { fees = amount.mul(totalFees).div(100); _tokensForLiquidity += fees * _liquidityFee / totalFees; _tokensForMarketing += fees * _marketingFee / totalFees; if (fees > 0) { super._transfer(from, address(this), fees); } amount -= fees; } super._transfer(from, to, amount); }",
        "vulnerability": "Potential for front-running attacks",
        "reason": "The function implements a transfer delay mechanism by checking the block number for each transfer. However, this can be exploited by front-running attackers who can observe transactions and execute their own before others. This is especially concerning during times of high volatility or when trading restrictions are lifted.",
        "file_name": "0x0a16d08b57afe4e0e323eba83e0282b07c2ed1f1.sol"
    }
]