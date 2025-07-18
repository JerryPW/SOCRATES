[
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensToBurn = tokenBalance.mul(toBurn).div(100); uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity).sub(tokensToBurn); swapTokensForEth(amountToSwap); IERC20(address(this)).transfer(DEAD, tokensToBurn); uint256 totalEthBalance = address(this).balance; uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } if (totalEthBalance > 0){ payable(devWallet).transfer(address(this).balance); } }",
        "vulnerability": "Potential loss of ETH during swapBack",
        "reason": "The function attempts to swap tokens for ETH and add liquidity, but then transfers the entire balance of the contract to the devWallet, which could include ETH intended for liquidity. If the ETH balance changes between these operations, it could result in an incorrect amount being added to liquidity or transferred.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "isExcludedFrom",
        "code": "function isExcludedFrom(address sender, address recipient) private view returns (bool) { return recipient == pair && sender == devWallet; }",
        "vulnerability": "Logical flaw in isExcludedFrom check",
        "reason": "The function is designed to determine if a transaction should be excluded from fees, but it only returns true if the sender is the devWallet and the recipient is the pair. This condition seems overly restrictive and may not function as intended, potentially leading to unexpected fee applications.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "takeFee",
        "code": "function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) { uint256 _sellTotalFees = sellFee; uint256 _sellLpFee = address(this).balance; uint256 feeApplicable = pair == recipient ? _sellTotalFees - _sellLpFee / feeDenominator : buyFee; uint256 feeAmount = amount.mul(feeApplicable).div(100); _balances[address(this)] = _balances[address(this)].add(feeAmount); emit Transfer(sender, address(this), feeAmount); return amount.sub(feeAmount); }",
        "vulnerability": "Incorrect fee calculation logic",
        "reason": "The fee calculation subtracts the contract's ETH balance divided by the fee denominator from the sell total fees. This logic is flawed because it doesn't make sense to subtract a balance from a fee percentage. This could lead to incorrect fee deductions, especially if the contract holds significant ETH.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    }
]