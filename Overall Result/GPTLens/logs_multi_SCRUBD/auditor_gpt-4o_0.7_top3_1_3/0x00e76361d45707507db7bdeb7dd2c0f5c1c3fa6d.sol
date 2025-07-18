[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Function access control",
        "reason": "The manualswap function is only protected by a simple address check (`_msgSender() == _feeAddrWallet1`). If `_feeAddrWallet1` is compromised or if an attacker manages to control this address, they can swap all the tokens held by the contract for ETH, draining the contract's token balance.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Function access control",
        "reason": "Similar to `manualswap`, the `manualsend` function allows the `_feeAddrWallet1` address to send all ETH balance from the contract to the fee addresses. If `_feeAddrWallet1` is compromised, an attacker can drain all ETH from the contract.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen, \"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 20000000000 * 10 ** 9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Potential for owner control",
        "reason": "The `openTrading` function can only be called once but it allows the owner to set critical parameters like the transaction limit (`_maxTxAmount`). If the owner is malicious or the private key is compromised, they can set parameters that are detrimental to the token holders, such as very high fees or low transaction limits after trading is opened.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    }
]