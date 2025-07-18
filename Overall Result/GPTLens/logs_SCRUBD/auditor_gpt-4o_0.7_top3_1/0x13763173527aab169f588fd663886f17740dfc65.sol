[
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external payable onlyOwner lockTaxSwap { require(_primaryLP == address(0), \"LP exists\"); require(!_tradingOpen, \"trading is open\"); require(msg.value > 0 || address(this).balance>0, \"No ETH in contract or message\"); require(_balances[address(this)]>0, \"No tokens in contract\"); _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH()); _addLiquidity(_balances[address(this)], address(this).balance, false); _balances[_primaryLP] -= _swapLimit; (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature(\"sync()\")); require(lpAddSuccess, \"Failed adding liquidity\"); _isLP[_primaryLP] = lpAddSuccess; _openTrading(); }",
        "vulnerability": "Incorrect balance manipulation",
        "reason": "The function reduces the balance of the liquidity pool `_primaryLP` by `_swapLimit` after adding liquidity. This direct manipulation of the liquidity pool's balance is incorrect and can lead to inconsistencies in the contract's understanding of the pool's balance versus the actual balance on the blockchain.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    },
    {
        "function_name": "_swapTaxAndLiquify",
        "code": "function _swapTaxAndLiquify() private lockTaxSwap { uint256 _taxTokensAvailable = _swapLimit; if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) { if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; } uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2; uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP; if( _tokensToSwap > 10**_decimals ) { uint256 _ethPreSwap = address(this).balance; _balances[address(this)] += _taxTokensAvailable; _swapTaxTokensForEth(_tokensToSwap); _swapLimit -= _taxTokensAvailable; uint256 _ethSwapped = address(this).balance - _ethPreSwap; if ( _taxSharesLP > 0 ) { uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ; _approveRouter(_tokensForLP); _addLiquidity(_tokensForLP, _ethWeiAmount, false); } } uint256 _contractETHBalance = address(this).balance; if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); } } }",
        "vulnerability": "Reentrancy risk",
        "reason": "The function `_swapTaxAndLiquify` calls external functions that transfer ETH and interact with Uniswap. This creates a potential reentrancy vulnerability, especially since `_balances[address(this)]` is manipulated before these external calls. If an attacker manages to execute a reentrant call, they could potentially exploit the contract by manipulating its state in unexpected ways.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    },
    {
        "function_name": "manualTaxSwapAndSend",
        "code": "function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap { require(swapTokenPercent <= 100, \"Cannot swap more than 100%\"); uint256 tokensToSwap = _balances[address(this)] * swapTokenPercent / 100; if (tokensToSwap > 10 ** _decimals) { _swapTaxTokensForEth(tokensToSwap); } if (sendEth) { uint256 ethBalance = address(this).balance; require(ethBalance > 0, \"No ETH\"); _distributeTaxEth(address(this).balance); } }",
        "vulnerability": "Potential for excessive token swap",
        "reason": "The function allows the owner to manually trigger a swap of a percentage of the contract's token balance. If not carefully managed, this could allow the owner to significantly impact the token's price by dumping a large number of tokens on the market at once, which could be seen as an exploitative action against the interests of token holders.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    }
]