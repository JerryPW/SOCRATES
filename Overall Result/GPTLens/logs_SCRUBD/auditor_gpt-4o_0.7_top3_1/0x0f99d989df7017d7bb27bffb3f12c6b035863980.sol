[
    {
        "function_name": "launch",
        "code": "function launch() external onlyOwner returns (bool){ require(!tradingActive, \"Trading is already active, cannot relaunch.\"); enableTrading(); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); excludeFromMaxTransaction(address(_uniswapV2Router), true); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); require(address(this).balance > 0, \"Must have ETH on contract to launch\"); addLiquidity(balanceOf(address(this)), address(this).balance); transferOwnership(_owner); launchTime = block.timestamp; return true; }",
        "vulnerability": "Potentially unsafe transfer of ownership",
        "reason": "The function transfers ownership back to a specified address after enabling trading, which could be exploited if that address is compromised or maliciously set. This circumvents any checks or balances that were in place during contract deployment.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() private lockTheSwap { uint256 contractBalance = balanceOf(address(this)); uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap; uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2); uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity); uint256 initialETHBalance = address(this).balance; swapTokensForETH(amountToSwapForETH); uint256 ethBalance = address(this).balance.sub(initialETHBalance); uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap); uint256 ethForLiquidity = ethBalance.sub(ethForMarketing); uint256 ethForDev= ethForMarketing * 1 / 6; ethForMarketing -= ethForDev; _liquidityTokensToSwap = 0; _marketingTokensToSwap = 0; (bool success,) = address(marketingAddress).call{value: ethForMarketing}(\"\"); (success,) = address(devAddress).call{value: ethForDev}(\"\"); addLiquidity(tokensForLiquidity, ethForLiquidity); emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity); if(address(this).balance > 1e17){ (success,) = address(marketingAddress).call{value: address(this).balance}(\"\"); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function makes external calls to the marketing and dev addresses while still holding the state of the contract, which can be exploited to perform reentrancy attacks, potentially draining the contract's funds.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Unsafe withdrawal of ETH",
        "reason": "The function allows the owner to withdraw all ETH from the contract before trading starts. This is dangerous if the owner is compromised or intends to rug pull, as it allows them to take all funds out of the contract easily.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    }
]