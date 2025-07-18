[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Function access control vulnerability",
        "reason": "The manualswap function can only be called by _feeAddrWallet1. If this address is compromised, an attacker can repeatedly call this function to drain the contract's token balance by swapping it to ETH, disrupting the tokenomics and causing financial damage.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Function access control vulnerability",
        "reason": "The manualsend function can only be called by _feeAddrWallet1. If this address is compromised, an attacker can drain all ETH from the contract, which is intended to be used for operational expenses or other purposes, leading to a financial loss.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 1e12 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Potential reentrancy during liquidity addition",
        "reason": "The openTrading function calls addLiquidityETH without handling reentrancy. If the external call to addLiquidityETH triggers a fallback function, it could potentially reenter and manipulate the state before the function completes. Although the lockTheSwap modifier is not directly applied here, similar precautions should be considered.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    }
]