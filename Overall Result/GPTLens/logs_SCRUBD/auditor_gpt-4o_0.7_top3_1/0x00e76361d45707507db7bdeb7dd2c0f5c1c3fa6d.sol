[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 20000000000 * 10 ** 9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Reentrancy vulnerability due to the external call to addLiquidityETH",
        "reason": "The function `openTrading` makes an external call to `addLiquidityETH` which is a non-view function. This call transfers control to an external contract, potentially allowing reentrancy attacks. Since this function updates state variables after this call, an attacker could exploit this to repeatedly call `openTrading` and manipulate the state of the contract, leading to unexpected behavior and potential loss of funds.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if (!_isBuy(from)) { if (_buyMap[from] != 0 && (_buyMap[from] + (24 hours) >= block.timestamp)) { _feeAddr1 = 1; _feeAddr2 = 65; } else { _feeAddr1 = 1; _feeAddr2 = 8; } } else { if (_buyMap[to] == 0) { _buyMap[to] = block.timestamp; } _feeAddr1 = 1; _feeAddr2 = 8; } if (from != owner() && to != owner()) { require(!bots[from] && !bots[to]); if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) { require(amount <= _maxTxAmount); require(cooldown[to] < block.timestamp); cooldown[to] = block.timestamp + (30 seconds); } uint256 contractTokenBalance = balanceOf(address(this)); if (!inSwap && from != uniswapV2Pair && swapEnabled) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if(contractETHBalance > 0) { sendETHToFee(address(this).balance); } } } _tokenTransfer(from,to,amount); }",
        "vulnerability": "Potential denial of service due to cooldown mechanism",
        "reason": "The cooldown mechanism, which imposes a 30 seconds delay between transfers for certain addresses, could be exploited by attackers to lock out legitimate users from transacting. By repeatedly triggering this mechanism, an attacker could prevent a targeted account from executing transactions, effectively causing a denial of service for that account.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Function can be called by a compromised `_feeAddrWallet1`",
        "reason": "The `manualswap` function allows the `_feeAddrWallet1` to swap the entire contract balance for ETH. If the private key for the `_feeAddrWallet1` is compromised, an attacker could call this function to drain the contract's token balance. This poses a significant risk, as the funds intended for team or operational use could be entirely stolen.",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol"
    }
]