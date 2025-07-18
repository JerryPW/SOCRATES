[
    {
        "function_name": "manualSwap",
        "code": "function manualSwap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "manualSwap can be executed by _feeAddrWallet1 repeatedly",
        "reason": "The manualSwap function can be called by the _feeAddrWallet1 address repeatedly with no restriction on the number of times it can be executed. This can potentially allow the wallet to trigger swaps at will, leading to potential manipulation of the token price and draining of the contract's token balance.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    },
    {
        "function_name": "manualSend",
        "code": "function manualSend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "manualSend can be executed by _feeAddrWallet1 repeatedly",
        "reason": "The manualSend function allows the _feeAddrWallet1 address to send all ETH in the contract to predefined addresses repeatedly without any restrictions. This could lead to unauthorized draining of ETH from the contract balance and could be used maliciously by the wallet owner.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen, \"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); isExcludedFromLimit[address(uniswapV2Router)] = true; isExcludedFromLimit[uniswapV2Pair] = true; uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "openTrading does not properly secure liquidity addition",
        "reason": "The openTrading function adds liquidity to Uniswap with the contract's entire ETH balance, potentially leaving no ETH for other operations or security measures. If the owner calls this function without ensuring proper ETH management, it could result in liquidity being locked or mismanaged. Additionally, there is no mechanism to prevent reentrancy attacks during liquidity provision.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    }
]