[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 3000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Liquidity Addition Without Time Lock",
        "reason": "The `openTrading` function adds liquidity to the Uniswap pool and enables trading without any time lock or constraints on when this can be done by the contract owner. This allows the owner to potentially manipulate the token price by adding and removing liquidity at will. This poses a risk to investors as the owner can significantly affect the market dynamics of the token.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Centralized Control",
        "reason": "The `manualswap` function allows the address `_feeAddrWallet1` to swap all tokens held by the contract for ETH at any time. This centralized control means that a single entity has significant influence over the contract's operations, creating a single point of failure. If this address is compromised, an attacker could drain the contract's token balance for personal gain.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { _feeAddrWallet1.transfer(amount/3); _feeAddrWallet2.transfer(amount/3); _feeAddrWallet3.transfer(amount/3); }",
        "vulnerability": "Potential Loss of Funds to Zero Address",
        "reason": "The `sendETHToFee` function distributes ETH to three addresses. However, if any of these addresses are set to the zero address or are compromised, funds could be irreversibly lost or stolen. As `_feeAddrWallet2` and `_feeAddrWallet3` are initialized to the same address, this also increases the risk profile, since a compromise of this address would impact two-thirds of the fee distribution.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    }
]