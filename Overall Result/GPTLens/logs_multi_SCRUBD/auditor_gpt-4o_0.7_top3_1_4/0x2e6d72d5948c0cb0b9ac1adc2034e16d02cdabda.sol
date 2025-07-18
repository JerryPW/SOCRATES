[
    {
        "function_name": "changeSwapBackSettings",
        "code": "function changeSwapBackSettings() external { swapAndLiquifyEnabled = false; }",
        "vulnerability": "Lack of Access Control",
        "reason": "The `changeSwapBackSettings` function lacks `onlyOwner` modifier, allowing any user to disable `swapAndLiquifyEnabled`, potentially preventing liquidity functions from executing and disrupting token economics.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "takeFee",
        "code": "function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) { uint256 _sellTotalFees = sellFee; uint256 _sellLpFee = address(this).balance; uint256 feeApplicable = pair == recipient ? _sellTotalFees - _sellLpFee / feeDenominator : buyFee; uint256 feeAmount = amount.mul(feeApplicable).div(100); _balances[address(this)] = _balances[address(this)].add(feeAmount); emit Transfer(sender, address(this), feeAmount); return amount.sub(feeAmount); }",
        "vulnerability": "Incorrect Fee Calculation",
        "reason": "The fee calculation in `takeFee` subtracts `_sellLpFee / feeDenominator` from `_sellTotalFees`, which doesn't make logical sense and could lead to incorrect fee application. This could be manipulated if `_sellLpFee` is large enough, resulting in a negative or unintended fee, affecting token transfers.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); approve(address(this), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Unrestricted Approval",
        "reason": "The `swapTokensForEth` function calls `approve` with itself as the spender and `tokenAmount`, potentially leading to a re-approval vulnerability if `swapExactTokensForETHSupportingFeeOnTransferTokens` is called recursively or in a reentrant manner, possibly allowing for token transfer manipulation.",
        "file_name": "0x2e6d72d5948c0cb0b9ac1adc2034e16d02cdabda.sol"
    }
]