[
    {
        "function_name": "_swapTokensForEth",
        "code": "function _swapTokensForEth(uint256 tokenAmount, address tokenContract) private { address[] memory path = new address[](2); path[0] = tokenContract; path[1] = uniswapV2Router.WETH(); _approve(tokenContract, address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, tokenContract, block.timestamp ); }",
        "vulnerability": "Incorrect token parameter usage",
        "reason": "This function is intended to swap tokens of the contract for ETH using the Uniswap router. However, the variable 'tokenContract' is used instead of 'address(this)' to set the token path. This could lead to incorrect token swaps if 'tokenContract' does not match 'address(this)'. This could be exploited by an attacker to manipulate the swap path, potentially resulting in loss of funds or unexpected behavior.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "manualTokenomics",
        "code": "function manualTokenomics() public onlyOwner() { if(balanceOf(address(this)) > 0) { this.transfer(_wMarketing, balanceOf(address(this))); } if(address(this).balance > 0) { _wMarketing.transfer(address(this).balance); } }",
        "vulnerability": "Funds drain by owner",
        "reason": "This function allows the owner to transfer all tokens and ETH from the contract to the marketing wallet without any restrictions or limits. This could be exploited by a malicious owner to drain all funds from the contract, leaving other participants with nothing.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "_doLiquidity",
        "code": "function _doLiquidity(uint256 liqTokensAmount, uint256 fullBalance, uint256 burnAmount) private { uint256 bnbHalf = liqTokensAmount.div(2); uint256 tokenHalf = liqTokensAmount.sub(bnbHalf); uint256 bnbBalance = address(this).balance; _swapTokensForEth(fullBalance.sub(tokenHalf), address(this)); uint256 bnbNewBalance = address(this).balance.sub(bnbBalance); if(bnbNewBalance > 0) { uint256 liqBnbAmount = _findPercent(bnbNewBalance, _autoLiqPer); uint256 devBnbAmount = _findPercent(bnbNewBalance, _devPer); uint256 marketingBnbAmount = _findPercent(bnbNewBalance, _marketingPer); if(liqTokensAmount > 0) { _addLiquidity(tokenHalf, liqBnbAmount); _liqAllTime += liqBnbAmount; } if(devBnbAmount > 0) { _doDev(devBnbAmount); } if(marketingBnbAmount > 0) { _doMarketing(marketingBnbAmount); } if(burnAmount > 0) { _doBurn(burnAmount); } } }",
        "vulnerability": "Liquidity manipulation risk",
        "reason": "The function calculates liquidity addition and other transfers based on the ETH balance of the contract, which can be manipulated by sending ETH directly to the contract. This may lead to incorrect calculations and distributions of liquidity, dev, and marketing funds. An attacker could manipulate these calculations to their advantage by affecting the ETH balance prior to this function's execution.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    }
]