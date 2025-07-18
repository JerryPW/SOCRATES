[
    {
        "function_name": "claimETHOverflow",
        "code": "function claimETHOverflow() external onlyOwner { require(address(this).balance > 0, \"RedKnightToken: Cannot send more than contract balance\"); uint256 amount = address(this).balance; (bool success,) = address(owner()).call{value : amount}(\"\"); if (success){ emit ClaimETHOverflow(amount); } }",
        "vulnerability": "Owner can drain all ETH",
        "reason": "The function allows the owner to transfer the entire ETH balance of the contract to their own address. If the contract is intended to hold ETH for any purpose (e.g., liquidity, user funds), this function could be used maliciously to drain the contract's ETH balance, potentially resulting in a loss of funds for users or other stakeholders.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "_swapAndLiquify",
        "code": "function _swapAndLiquify() private { uint256 contractBalance = balanceOf(address(this)); uint256 initialETHBalance = address(this).balance; uint8 totalFeePrior = _totalFee; uint8 liquidityFeePrior = _liquidityFee; uint8 marketingFeePrior = _marketingFee; uint8 devFeePrior = _devFee; uint8 buyBackFeePrior = _buyBackFee; uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2; uint256 amountToSwapForETH = contractBalance - amountToLiquify; _swapTokensForETH(amountToSwapForETH); uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance; uint256 totalETHFee = _totalFee - (_liquidityFee / 2); uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2; uint256 amountETHDev = ETHBalanceAfterSwap * _devFee / totalETHFee; uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee; uint256 amountETHMarketing = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHDev + amountETHBuyBack); payable(marketingWallet).transfer(amountETHMarketing); payable(devWallet).transfer(amountETHDev); payable(buyBackWallet).transfer(amountETHBuyBack); if (amountToLiquify > 0) { _addLiquidity(amountToLiquify, amountETHLiquidity); emit SwapAndLiquify(amountToSwapForETH, amountETHLiquidity, amountToLiquify); } _totalFee = totalFeePrior; _liquidityFee = liquidityFeePrior; _marketingFee = marketingFeePrior; _devFee = devFeePrior; _buyBackFee = buyBackFeePrior; }",
        "vulnerability": "Reentrancy through external calls",
        "reason": "The function makes external calls to transfer ETH to various wallets (`marketingWallet`, `devWallet`, `buyBackWallet`) without using reentrancy guards. This could allow an attacker to re-enter the contract during the ETH transfer and potentially manipulate the contract's state or cause unexpected behaviors.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "blockAccount",
        "code": "function blockAccount(address account) external onlyOwner { uint256 currentTimestamp = _getNow(); require(!_isBlocked[account], \"RedKnightToken: Account is already blocked\"); if (_isLaunched) { require((currentTimestamp - _launchStartTimestamp) < _blockedTimeLimit, \"RedKnightToken: Time to block accounts has expired\"); } _isBlocked[account] = true; emit BlockedAccountChange(account, true); }",
        "vulnerability": "Owner can block accounts arbitrarily",
        "reason": "This function allows the owner to block any account from trading by simply setting `_isBlocked` to true. Although there is a time limit on blocking accounts post-launch, the owner still has significant power to arbitrarily block accounts within this period, potentially as a form of censorship or to target specific users.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    }
]