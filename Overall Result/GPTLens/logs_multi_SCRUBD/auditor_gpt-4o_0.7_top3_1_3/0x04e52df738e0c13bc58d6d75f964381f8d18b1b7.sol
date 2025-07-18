[
    {
        "function_name": "open",
        "code": "function open() external onlyOwner { require(!isOpen,\"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _totalSupply); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance} (address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp); IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); isOpen = true; }",
        "vulnerability": "Liquidity Addition Without Proper Checks",
        "reason": "The function directly uses the contract's ETH balance to provide liquidity without checking if the balance is non-zero. This can cause unexpected behavior or failure if the contract doesn't hold any ETH.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint amount) private { require(sender != address(0), \"[sminem]: transfer from the zero address\"); require(recipient != address(0), \"[sminem]: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if(sender != owner() && recipient != owner()) { if(!_isExcludedFromFee[recipient] && !_isExcludedFromFee[sender] ) { require(amount <= _maxAmountInTx, \"Transfer amount exceeds the maxTxAmount.\"); } require(!_botList[sender] && !_botList[recipient], \"Bot detected\"); if(sender == uniswapV2Pair && recipient != address(uniswapV2Router) && !_isExcludedFromFee[recipient]) { require(isOpen, \"[sminem]: Trading not started yet.\"); uint walletBalance = balanceOf(address(recipient)); require(amount.add(walletBalance) <= _totalSupply.mul(_maxOwnedTokensPercent).div(100)); } uint256 contractTokenBalance = balanceOf(address(this)); if(!inSwap && sender != uniswapV2Pair && isOpen) { if(contractTokenBalance > 0) { if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_maxTokensInWalletPercent).div(100)) { contractTokenBalance = balanceOf(uniswapV2Pair).mul(_maxTokensInWalletPercent).div(100); } swapTokensForEth(contractTokenBalance); } uint256 contractETHBalance = address(this).balance; if(contractETHBalance > _floor) { sendETHToFee(address(this).balance.sub(_floor)); } } } bool takeFee = true; if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) takeFee = false; if(!takeFee) removeAllFee(); _transferRegular(sender, recipient, amount); if(!takeFee) restoreAllFee(); }",
        "vulnerability": "Reentrancy in Swap and Transfer",
        "reason": "The function `swapTokensForEth` is called within the `_transfer` function without proper reentrancy guard when sending ETH. Although there is a `lockTheSwap` modifier, it could be bypassed if the attacker controls the token contract, causing reentrancy during token swap operations.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address spender, uint amount) public override returns (bool) { require(_msgSender() != address(0)); require(spender != address(0)); _allowance[_msgSender()][spender] = amount; emit Approval(_msgSender(), spender, amount); return true; }",
        "vulnerability": "Missing SafeMath Usage for Allowance",
        "reason": "The `approve` function directly assigns a new allowance without considering the current allowance. This can lead to the race condition where spenders could use both the old and new allowance, leading to double spending.",
        "file_name": "0x04e52df738e0c13bc58d6d75f964381f8d18b1b7.sol"
    }
]