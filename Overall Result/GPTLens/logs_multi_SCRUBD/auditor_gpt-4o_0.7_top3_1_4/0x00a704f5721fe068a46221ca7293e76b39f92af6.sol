[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 3000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Liquidity Addition Vulnerability",
        "reason": "The function `openTrading` adds liquidity using the contract's entire balance. If the contract receives ETH before this function is called, it can lead to unintended liquidity addition. Attackers could send ETH to the contract, causing unexpected behavior when liquidity is added.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Single Address Control",
        "reason": "The function `manualswap` allows a single address (`_feeAddrWallet1`) to swap all tokens in the contract for ETH. If the private key of `_feeAddrWallet1` is compromised, an attacker could drain the tokens by continuously calling `manualswap`.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Single Address Control",
        "reason": "Similar to `manualswap`, the `manualsend` function allows a single address (`_feeAddrWallet1`) to send the entire ETH balance of the contract. If this address is compromised, an attacker could send all ETH to themselves.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    }
]