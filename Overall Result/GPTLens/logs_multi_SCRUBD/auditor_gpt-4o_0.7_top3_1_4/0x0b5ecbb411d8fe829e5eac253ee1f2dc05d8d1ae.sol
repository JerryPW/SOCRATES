[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() internal onlyOwner { tradingActive = true; swapAndLiquifyEnabled = true; tradingActiveBlock = block.number; earlyBuyPenaltyEnd = block.timestamp + 30 days; }",
        "vulnerability": "Trading activation is internal",
        "reason": "The enableTrading function is marked as internal and is only callable by the owner, meaning trading can only be activated by the contract owner or functions within the contract. This can be exploited by the owner to delay or prevent trading activation, potentially manipulating the trading environment to their advantage.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    },
    {
        "function_name": "launch",
        "code": "function launch() external onlyOwner returns (bool){ require(!tradingActive, \"Trading is already active, cannot relaunch.\"); enableTrading(); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); excludeFromMaxTransaction(address(_uniswapV2Router), true); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); require(address(this).balance > 0, \"Must have ETH on contract to launch\"); addLiquidity(balanceOf(address(this)), address(this).balance); transferOwnership(_owner); return true; }",
        "vulnerability": "Owner control over trading start",
        "reason": "The function launch relies on internal function enableTrading to activate trading. This means that the contract owner has exclusive control over when trading can start, which could be exploited to control the market conditions or prevent trading altogether, affecting token holders' ability to trade freely.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Potential ETH withdrawal restriction",
        "reason": "The withdrawStuckETH function allows the owner to withdraw ETH only if trading hasn't started. This can be problematic if ETH becomes locked in the contract after trading has started, as there would be no way to withdraw it, potentially leading to a loss of funds.",
        "file_name": "0x0b5ecbb411d8fe829e5eac253ee1f2dc05d8d1ae.sol"
    }
]