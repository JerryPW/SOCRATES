[
    {
        "function_name": "setSwapEnabled",
        "code": "function setSwapEnabled(bool enabled) external { require(_msgSender() == _Dev); swapEnabled = enabled; }",
        "vulnerability": "Centralization Risk",
        "reason": "The function allows the address stored in _Dev to enable or disable the swap feature. This can be used to manipulate the contract's behavior, potentially affecting the token's liquidity and market price. If the _Dev account is compromised or acts maliciously, it can disable swaps to prevent users from selling tokens.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner() { for (uint256 i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Potential for Arbitrary Blacklisting",
        "reason": "The owner can blacklist any address arbitrarily by adding it to the bots mapping. This could prevent legitimate users from being able to participate in transfers, effectively freezing their assets. This centralization risk could be exploited if the owner's account is compromised or if the owner acts maliciously.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen, \"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()) .createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp ); swapEnabled = true; _maxTxAmount = 20000000000 * 10**9; launchBlock = block.number; tradingOpen = true; IERC20(uniswapV2Pair).approve( address(uniswapV2Router), type(uint256).max ); }",
        "vulnerability": "Liquidity Addition Centralization",
        "reason": "The 'openTrading' function gives the owner full control over when trading is opened. Until this function is called, no trading can occur, and the owner can manipulate the launch time to their advantage. This centralization can be used to execute trades with insider knowledge before the general market can react.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    }
]