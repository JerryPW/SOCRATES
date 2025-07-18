[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Privileged access to swap all tokens",
        "reason": "The manualswap function can be called by the _feeAddrWallet1 address to swap all tokens held by the contract to ETH. If _feeAddrWallet1 is compromised, an attacker could drain the contract's token balance, converting them to ETH for withdrawal. This function grants a high degree of control to a single address without any additional security checks.",
        "file_name": "0x01680af31961fb47ad92e32218a5d8cbd036f6ba.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Privileged access to withdraw all ETH",
        "reason": "The manualsend function allows the _feeAddrWallet1 address to withdraw all ETH held by the contract. If the private key for _feeAddrWallet1 is compromised, an attacker could steal all ETH stored in the contract. This function lacks additional security measures to prevent unauthorized access, relying solely on a single address check.",
        "file_name": "0x01680af31961fb47ad92e32218a5d8cbd036f6ba.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 1000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Potential loss of ETH during liquidity addition",
        "reason": "The openTrading function adds liquidity to Uniswap and sends the liquidity tokens to the owner. However, if there is a large balance of ETH in the contract at this time, it could lead to an unintended large addition of liquidity, potentially at unfavorable rates, without explicit user confirmation. This can result in a loss of ETH value if not managed carefully.",
        "file_name": "0x01680af31961fb47ad92e32218a5d8cbd036f6ba.sol"
    }
]