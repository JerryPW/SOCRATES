[
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address _token) external onlyOwner { require(_token != address(this), \"No rugs\"); if (_token == address(0x0)) { payable(owner()).transfer(address(this).balance); return; } IERC20 erc20token = IERC20(_token); uint256 balance = erc20token.balanceOf(address(this)); erc20token.transfer(owner(), balance); }",
        "vulnerability": "Token Draining by Owner",
        "reason": "The function allows the owner to transfer any ERC20 tokens (except the contract's own tokens) from the contract to the owner\u2019s address. This could be used to drain all tokens from the contract to the owner\u2019s wallet if it holds any valuable tokens.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "setBlackList",
        "code": "function setBlackList(address addr, bool value) external onlyOwner { _isBlackListed[addr] = value; }",
        "vulnerability": "Centralized Blacklisting",
        "reason": "The owner of the contract can arbitrarily blacklist any address, preventing them from participating in transfers. This gives the owner excessive control over user funds and could be abused for malicious purposes.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(from != address(0), \"Token: transfer from the zero address\"); require(to != address(0), \"Token: transfer to the zero address\"); require( !_isBlackListed[from] && !_isBlackListed[to], \"Account is blacklisted\" ); require( isTradingEnabled || _isExcludedFromFees[from], \"Trading not enabled yet\" ); if (amount == 0) { super._transfer(from, to, 0); return; } uint256 contractTokenBalance = balanceOf(address(this)); bool overMinimumTokenBalance = contractTokenBalance >= swapTokensAtAmount; if ( swapEnabled && !swapping && from != uniswapV2Pair && overMinimumTokenBalance ) { contractTokenBalance = swapTokensAtAmount; uint256 swapTokens = contractTokenBalance.mul(buyFee.liquidityFee) .div(totalBuyFee+totalSellFee); swapAndLiquify(swapTokens); uint256 walletTokens = contractTokenBalance - swapTokens; swapAndSendToWallets(walletTokens); } bool takeFee = true; if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) { takeFee = false; } if (takeFee) { uint256 fees; if (automatedMarketMakerPairs[to]) { fees = totalSellFee; } else if (automatedMarketMakerPairs[from]) { fees = totalBuyFee; } if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) { if (automatedMarketMakerPairs[to]) { require(amount <= maxSellAmount, \"Sell exceeds limit\"); } else if (automatedMarketMakerPairs[from]) { require(amount <= maxBuyAmount, \"Buy exceeds limit\"); if (block.number < tradingStartBlock + BLOCKCOUNT) { _isBlackListed[to] = true; } } if (!automatedMarketMakerPairs[to]) { require( balanceOf(to) + amount <= maxWalletAmount, \"Balance exceeds limit\" ); } } uint256 feeAmount = amount.mul(fees).div(100); amount = amount.sub(feeAmount); super._transfer(from, address(this), feeAmount); } super._transfer(from, to, amount); }",
        "vulnerability": "Early Blacklisting on Trading Start",
        "reason": "In the _transfer function, new buyers during the initial blocks after trading starts can be blacklisted. The block number check and automatic blacklisting could be exploited to prevent certain users from trading, affecting market fairness and accessibility.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    }
]