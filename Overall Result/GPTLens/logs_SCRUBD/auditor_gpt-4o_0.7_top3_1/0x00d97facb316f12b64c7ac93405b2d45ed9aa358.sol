[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = false; _maxTxAmount = 1000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Centralization Risk",
        "reason": "The openTrading function can only be called by the contract owner, leading to a centralization risk. This means that the owner has the sole authority to enable trading, which could be exploited to control or disrupt the trading process. If the owner's private key is compromised, an attacker could manipulate trading conditions.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Unauthorized Access",
        "reason": "The manualswap function can only be called by the address _feeAddrWallet1. If the private key of this address is compromised, an attacker could repeatedly call this function to swap tokens for ETH, potentially draining the contract's token reserves.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Unauthorized Access",
        "reason": "Similar to manualswap, the manualsend function can only be called by _feeAddrWallet1. If this address is compromised, an attacker could send all ETH from the contract to the fee addresses, potentially draining the contract's ETH balance.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    }
]