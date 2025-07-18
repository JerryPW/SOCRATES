[
    {
        "function_name": "removeERC20",
        "code": "function removeERC20(address _token) external { if(_token != address(this)){ IERC20(_token).transfer(mkt, IERC20(_token).balanceOf(address(this))); mkt.transfer(address(this).balance); } }",
        "vulnerability": "Unauthorized token withdrawal",
        "reason": "The `removeERC20` function allows any user to transfer any ERC20 tokens (except the contract's own token) from the contract to the marketing address (`mkt`). Additionally, it transfers the contract's entire ETH balance to the `mkt` address. This function lacks access control, allowing any user to exploit it and potentially drain all ERC20 tokens and ETH from the contract.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "startTrade",
        "code": "function startTrade(address admin,address[] calldata adrs,uint256 per) public onlyOwner { address weth = _uniswapRouter.WETH(); IERC20(weth).approve(address(_uniswapRouter), ~uint256(0)); IERC20(weth).transferFrom(admin,address(this),IERC20(weth).balanceOf(admin)); for(uint i=0;i<adrs.length;i++){ swapToken(per,adrs[i]); } startTradeBlock = block.number; uint256 _bal = IERC20(weth).balanceOf(address(this)); if(_bal > 0){ IERC20(weth).transfer(admin,_bal); } }",
        "vulnerability": "Potential token theft through admin transfer",
        "reason": "The `startTrade` function allows the owner to transfer an arbitrary amount of WETH from any `admin` address to the contract. This function can be exploited to drain the `admin` address of its WETH balance without their consent, which could be maliciously used to steal tokens.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { uint256 balance = balanceOf(from); require(balance >= amount, \"balanceNotEnough\"); if (inSwap){ _basicTransfer(from, to, amount); return; } bool takeFee; if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to] && _buyCount > _preventSwapBefore) { uint256 _numSellToken = amount; if (_numSellToken > balanceOf(address(this))){ _numSellToken = _balances[address(this)]; } if (_numSellToken > swapAtAmount){ swapTokenForETH(_numSellToken); } } if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) { require(startTradeBlock > 0); takeFee = true; if (isMarketPair[from] && to != address(_uniswapRouter) && !_isExcludeFromFee[to]) { _buyCount++; } if (remainHolder && amount == balance) { amount = amount - (amount / 10000); } } _transferToken(from, to, amount, takeFee); }",
        "vulnerability": "Trade restrictions bypass",
        "reason": "The `_transfer` function checks if trading has started by requiring `startTradeBlock > 0` before allowing fee-taking transfers. However, this can be bypassed by transferring tokens when `inSwap` is true, which calls `_basicTransfer` without any restriction. This could allow unauthorized trading before the intended start block.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    }
]