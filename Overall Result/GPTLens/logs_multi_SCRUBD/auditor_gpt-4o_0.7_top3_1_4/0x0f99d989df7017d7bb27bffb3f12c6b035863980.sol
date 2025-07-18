[
    {
        "function_name": "launch",
        "code": "function launch() external onlyOwner returns (bool){ require(!tradingActive, \"Trading is already active, cannot relaunch.\"); enableTrading(); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); excludeFromMaxTransaction(address(_uniswapV2Router), true); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); require(address(this).balance > 0, \"Must have ETH on contract to launch\"); addLiquidity(balanceOf(address(this)), address(this).balance); transferOwnership(_owner); launchTime = block.timestamp; return true; }",
        "vulnerability": "Centralized Control of Trading Activation",
        "reason": "The `launch` function is only callable by the contract owner, which centralizes control over the activation of trading. This means the owner can indefinitely delay or prevent trading activation, affecting token holders' ability to trade the tokens.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "addOnBlackList",
        "code": "function addOnBlackList(address account) public onlyOwner { require(!stopBlkListing, \"You have disabled this function\"); blackListAdd[account] = true; }",
        "vulnerability": "Centralized Blacklisting",
        "reason": "The `addOnBlackList` function allows the owner to blacklist any account, preventing it from participating in token transfers. This centralizes power and poses risks of arbitrary censorship or misuse of power by the contract owner.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Potential Fund Misappropriation",
        "reason": "The `withdrawStuckETH` function allows the owner to withdraw all ETH from the contract before trading starts, which could lead to fund misappropriation. If the owner decides never to activate trading, they could potentially take all the ETH from the contract, affecting investors negatively.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    }
]