[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(from != address(0), \"Token: transfer from the zero address\"); require(to != address(0), \"Token: transfer to the zero address\"); require( !_isBlackListed[from] && !_isBlackListed[to], \"Account is blacklisted\" ); require( isTradingEnabled || _isExcludedFromFees[from], \"Trading not enabled yet\" ); if (amount == 0) { super._transfer(from, to, 0); return; } uint256 contractTokenBalance = balanceOf(address(this)); bool overMinimumTokenBalance = contractTokenBalance >= swapTokensAtAmount; if ( swapEnabled && !swapping && from != uniswapV2Pair && overMinimumTokenBalance ) { contractTokenBalance = swapTokensAtAmount; uint256 swapTokens = contractTokenBalance.mul(buyFee.liquidityFee) .div(totalBuyFee+totalSellFee); swapAndLiquify(swapTokens); uint256 walletTokens = contractTokenBalance - swapTokens; swapAndSendToWallets(walletTokens); } bool takeFee = true; if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) { takeFee = false; } if (takeFee) { uint256 fees; if (automatedMarketMakerPairs[to]) { fees = totalSellFee; } else if (automatedMarketMakerPairs[from]) { fees = totalBuyFee; } if (!_isExcludedFromLimit[from] && !_isExcludedFromLimit[to]) { if (automatedMarketMakerPairs[to]) { require(amount <= maxSellAmount, \"Sell exceeds limit\"); } else if (automatedMarketMakerPairs[from]) { require(amount <= maxBuyAmount, \"Buy exceeds limit\"); if (block.number < tradingStartBlock + BLOCKCOUNT) { _isBlackListed[to] = true; } } if (!automatedMarketMakerPairs[to]) { require( balanceOf(to) + amount <= maxWalletAmount, \"Balance exceeds limit\" ); } } uint256 feeAmount = amount.mul(fees).div(100); amount = amount.sub(feeAmount); super._transfer(from, address(this), feeAmount); } super._transfer(from, to, amount); }",
        "vulnerability": "Blacklisting bypass",
        "reason": "The function does not check if 'to' address is blacklisted before executing the main transfer logic. This allows blacklisted accounts to receive tokens, potentially bypassing the intended restriction.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "updateRouter",
        "code": "function updateRouter(address newAddress) external onlyOwner { require(newAddress != address(uniswapV2Router), \"LUNRR: The router already has that address\"); uniswapV2Router = IUniswapV2Router02(newAddress); address get_pair = IUniswapV2Factory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH()); if (get_pair == address(0)) { uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH()); } else { uniswapV2Pair = get_pair; } }",
        "vulnerability": "Unrestricted router update",
        "reason": "The function allows the owner to update the Uniswap router address without any restrictions. If the owner's account is compromised, an attacker can change the router to a malicious one, potentially leading to loss of funds during token swaps.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address _token) external onlyOwner { require(_token != address(this), \"No rugs\"); if (_token == address(0x0)) { payable(owner()).transfer(address(this).balance); return; } IERC20 erc20token = IERC20(_token); uint256 balance = erc20token.balanceOf(address(this)); erc20token.transfer(owner(), balance); }",
        "vulnerability": "Potential fund misappropriation",
        "reason": "The function allows the owner to transfer any ERC20 tokens held by the contract to themselves, which could be misused to drain any tokens accidentally sent to the contract. This functionality can be abused if the owner's account is compromised.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    }
]