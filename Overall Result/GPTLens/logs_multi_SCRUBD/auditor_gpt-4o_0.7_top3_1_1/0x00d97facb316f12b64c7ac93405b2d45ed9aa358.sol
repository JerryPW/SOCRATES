[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential abuse by fee wallet",
        "reason": "The manualswap function allows the address _feeAddrWallet1 to unilaterally swap all tokens held by the contract into ETH. If this wallet is compromised or malicious, it can drain the contract's token balance without any restrictions or checks.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralization risk",
        "reason": "The manualsend function enables _feeAddrWallet1 to send all ETH held by the contract to predefined wallets. This presents a centralization risk as a single address controls the entire ETH balance of the contract, which could be exploited if the address is malicious or compromised.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = false; _maxTxAmount = 1000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Trading centralization",
        "reason": "The openTrading function can only be called by the contract owner, giving a single entity the power to control when trading is opened. This centralization can be exploited by the owner to manipulate market conditions or delay trading for personal gain.",
        "file_name": "0x00d97facb316f12b64c7ac93405b2d45ed9aa358.sol"
    }
]