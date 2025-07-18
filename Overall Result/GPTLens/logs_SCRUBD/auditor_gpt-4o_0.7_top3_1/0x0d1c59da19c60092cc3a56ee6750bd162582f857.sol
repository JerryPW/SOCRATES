[
    {
        "function_name": "_swapTokensForEth",
        "code": "function _swapTokensForEth(uint256 tokenAmount, address tokenContract) private { address[] memory path = new address[](2); path[0] = tokenContract; path[1] = uniswapV2Router.WETH(); _approve(tokenContract, address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, tokenContract, block.timestamp ); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function _swapTokensForEth performs an external call to uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens without any checks or state updates before the call. This could be exploited in a reentrancy attack, where the external contract could call back into the contract before the first call completes, potentially manipulating the contract's state in a harmful way.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "manualTokenomics",
        "code": "function manualTokenomics() public onlyOwner() { if(balanceOf(address(this)) > 0) { this.transfer(_wMarketing, balanceOf(address(this))); } if(address(this).balance > 0) { _wMarketing.transfer(address(this).balance); } }",
        "vulnerability": "Improper access control",
        "reason": "The manualTokenomics function allows the contract owner to transfer all tokens and ETH balance held by the contract to the marketing wallet. This creates a centralization risk, as the owner can drain the contract's funds at any time. It also poses a risk of loss if the owner's key is compromised.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "_doLiquidity",
        "code": "function _doLiquidity(uint256 liqTokensAmount, uint256 fullBalance, uint256 burnAmount) private { uint256 bnbHalf = liqTokensAmount.div(2); uint256 tokenHalf = liqTokensAmount.sub(bnbHalf); uint256 bnbBalance = address(this).balance; _swapTokensForEth(fullBalance.sub(tokenHalf), address(this)); uint256 bnbNewBalance = address(this).balance.sub(bnbBalance); if(bnbNewBalance > 0) { uint256 liqBnbAmount = _findPercent(bnbNewBalance, _autoLiqPer); uint256 devBnbAmount = _findPercent(bnbNewBalance, _devPer); uint256 marketingBnbAmount = _findPercent(bnbNewBalance, _marketingPer); if(liqTokensAmount > 0) { _addLiquidity(tokenHalf, liqBnbAmount); _liqAllTime += liqBnbAmount; } if(devBnbAmount > 0) { _doDev(devBnbAmount); } if(marketingBnbAmount > 0) { _doMarketing(marketingBnbAmount); } if(burnAmount > 0) { _doBurn(burnAmount); } } }",
        "vulnerability": "Potential loss due to slippage",
        "reason": "The function _doLiquidity swaps tokens for ETH and then adds liquidity to the liquidity pool. However, it does not account for slippage, which can result in significant losses if the market conditions change between the swap and the liquidity addition. This can be exploited by front-running or sandwich attacks, where an attacker can manipulate the token price to benefit from the contract's operations.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    }
]