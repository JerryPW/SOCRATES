[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential Denial of Service from Unrestricted Access",
        "reason": "The `manualswap` function can be called by the `_feeAddrWallet1` account to swap all tokens held by the contract for ETH. If the `_feeAddrWallet1` is compromised or acts maliciously, it could engage in frequent swaps, potentially causing gas exhaustion or interfering with normal contract operations. There is no restriction on how often or under what conditions this function can be called, which could lead to abuse.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralization Risk and Unauthorized Drain of Contract's ETH Balance",
        "reason": "The `manualsend` function allows the `_feeAddrWallet1` to transfer the entire ETH balance of the contract to the fee wallets without any restrictions or checks on the amount or frequency. This centralized control over the contract's ETH balance means that if `_feeAddrWallet1` is compromised, the attacker could drain all ETH from the contract, resulting in loss for token holders relying on contract-held funds for liquidity or operations.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 50000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Centralized Control Over Trading",
        "reason": "The `openTrading` function can only be called by the contract owner, which means that the owner has centralized control over when trading is enabled. If the owner's private key is compromised, an attacker could prevent trading from opening or manipulate the trading conditions to their advantage. Moreover, the owner could potentially delay or restrict trading to further their own interests, which poses a risk to token holders.",
        "file_name": "0x005d068a5dd27f3e49a047deac6785b426145bbc.sol"
    }
]