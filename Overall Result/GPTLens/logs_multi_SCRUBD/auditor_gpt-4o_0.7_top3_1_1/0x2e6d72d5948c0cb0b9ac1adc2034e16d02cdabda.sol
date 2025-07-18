[
    {
        "function_name": "takeFee",
        "code": "function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) { uint256 _sellTotalFees = sellFee; uint256 _sellLpFee = address(this).balance; uint256 feeApplicable = pair == recipient ? _sellTotalFees - _sellLpFee / feeDenominator : buyFee; uint256 feeAmount = amount.mul(feeApplicable).div(100); _balances[address(this)] = _balances[address(this)].add(feeAmount); emit Transfer(sender, address(this), feeAmount); return amount.sub(feeAmount); }",
        "vulnerability": "Incorrect Fee Calculation",
        "reason": "The calculation for `feeApplicable` when the recipient is the `pair` is incorrect. It attempts to subtract `_sellLpFee / feeDenominator` from `_sellTotalFees`. Since `_sellLpFee` is the contract's Ether balance, which is not directly related to the intended fee logic, this calculation does not make sense and can lead to unintended fee values.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensToBurn = tokenBalance.mul(toBurn).div(100); uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity).sub(tokensToBurn); swapTokensForEth(amountToSwap); IERC20(address(this)).transfer(DEAD, tokensToBurn); uint256 totalEthBalance = address(this).balance; uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } if (totalEthBalance > 0){ payable(devWallet).transfer(address(this).balance); } }",
        "vulnerability": "Ether Balance Mismanagement",
        "reason": "The function calculates `ethForLiquidity` based on `totalEthBalance`, but then transfers the entire balance to `devWallet` without considering the previously calculated `ethForLiquidity`. This can result in not having enough Ether for the liquidity addition, failing the `addLiquidity` call, and potentially leading to loss of funds intended for the liquidity pool.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "manualSwapBack",
        "code": "function manualSwapBack() external onlyOwner { swapBack(); }",
        "vulnerability": "Potential Reentrancy via swapBack",
        "reason": "Although protected by `lockTheSwap`, if `swapBack` is called externally by `manualSwapBack`, and if the `swapTokensForEth` or `addLiquidity` functions involve calling untrusted contracts (like a router with malicious tokens), it could potentially lead to reentrancy issues if the contract is not prepared for such scenarios. The function opens up an additional attack surface by allowing the owner to trigger this mechanics outside normal operational flows.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    }
]