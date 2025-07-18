[
    {
        "function_name": "calculateFee",
        "code": "function calculateFee(uint256 feeIndex, uint256 amount, bool extra_fee) internal returns(uint256) { if(extra_fee) { uint256 extraFee = (amount * extra_fee_percent) / (10**(_feeDecimal + 2)); _marketingFeeCollected += extraFee; return extraFee; } uint256 marketingFee = (amount * _marketingFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 donationFee = (amount * _donationFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 liquidityFee = (amount * _liquidityFee[feeIndex]) / (10**(_feeDecimal + 2)); _marketingFeeCollected += marketingFee; _donationFeeCollected += donationFee; _liquidityFeeCollected += liquidityFee; return marketingFee + donationFee + liquidityFee; }",
        "vulnerability": "Excessive Fee Calculation Overflow",
        "reason": "The function calculates fees based on a percentage of the transaction amount and an additional 'extra_fee'. The 'extra_fee_percent' is set to 9000, which corresponds to a 90% fee. This is excessively high and can lead to overflow issues when calculating the extra fee. Additionally, such high fees can discourage legitimate users and could be exploited by an attacker who manipulates the fee structure.",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    },
    {
        "function_name": "swap",
        "code": "function swap() private lockTheSwap { uint totalCollected = _marketingFeeCollected + _donationFeeCollected + _liquidityFeeCollected; uint amountToSwap = _marketingFeeCollected + _donationFeeCollected + (_liquidityFeeCollected / 2); uint amountTokensToLiquidity = totalCollected - amountToSwap; if(minTokensBeforeSwap > totalCollected) return; address[] memory sellPath = new address[](2); sellPath[0] = address(this); sellPath[1] = router.WETH(); uint balanceBefore = address(this).balance; _approve(address(this), address(router), amountToSwap); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, sellPath, address(this), block.timestamp ); uint amountFee = address(this).balance - balanceBefore; uint amountMarketing = (amountFee * _marketingFeeCollected) / totalCollected; if(amountMarketing > 0) sendViaCall(payable(marketing_wallet), amountMarketing); uint amountDonation = (amountFee * _donationFeeCollected) / totalCollected; if(amountDonation > 0) sendViaCall(payable(donation_wallet), amountDonation); uint256 amountETHLiquidity = address(this).balance; if(amountTokensToLiquidity > 0){ _approve(address(this), address(router), amountTokensToLiquidity); router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountTokensToLiquidity, 0, 0, liquidity_wallet, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountTokensToLiquidity); } _marketingFeeCollected = 0; _donationFeeCollected = 0; _liquidityFeeCollected = 0; emit Swap(totalCollected, amountMarketing, amountDonation); }",
        "vulnerability": "Reentrancy Through swapExactTokensForETHSupportingFeeOnTransferTokens",
        "reason": "The function uses 'swapExactTokensForETHSupportingFeeOnTransferTokens' which can lead to reentrancy issues as it calls an external contract (the router). Although there is a reentrancy guard in place with 'lockTheSwap', the use of external calls can still be risky if not properly managed, especially when transferring funds out of the contract.",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    },
    {
        "function_name": "setMaxTxPercentage",
        "code": "function setMaxTxPercentage(uint256 percentage) public onlyOwner { maxTxAmount = (_totalSupply * percentage) / 10000; }",
        "vulnerability": "Arbitrary Max Transaction Setting",
        "reason": "The function allows the owner to arbitrarily set the max transaction percentage. This can be exploited by the owner to set very low values, effectively freezing trading for all users except for those who are exempt. This centralizes control and makes the contract susceptible to malicious actions by a compromised or malicious owner.",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    }
]