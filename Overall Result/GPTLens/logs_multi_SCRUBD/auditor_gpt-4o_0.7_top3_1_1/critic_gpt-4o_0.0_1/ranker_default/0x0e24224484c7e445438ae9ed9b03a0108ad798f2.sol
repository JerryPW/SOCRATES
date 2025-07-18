[
    {
        "function_name": "calculateFee",
        "vulnerability": "Excessive Fee Vulnerability",
        "criticism": "The reasoning is correct. The function does apply an 'extra fee' which could be extremely high if the conditions for 'extra_fee' are met. This could lead to a massive reduction in tokens for users during transfers if they trigger the extra fee conditions. However, the severity and profitability of this vulnerability are high only if the conditions for 'extra_fee' are met, which is not clear from the provided code.",
        "correctness": 7,
        "severity": 6,
        "profitability": 6,
        "reason": "The function applies an 'extra fee' which is extremely high at 9000% if the conditions for 'extra_fee' are met. This could unintentionally lead to a massive reduction in tokens for users during transfers if they trigger the extra fee conditions, making the token practically unusable and highly risky for users.",
        "code": "function calculateFee(uint256 feeIndex, uint256 amount, bool extra_fee) internal returns(uint256) { if(extra_fee) { uint256 extraFee = (amount * extra_fee_percent) / (10**(_feeDecimal + 2)); _marketingFeeCollected += extraFee; return extraFee; } uint256 marketingFee = (amount * _marketingFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 donationFee = (amount * _donationFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 liquidityFee = (amount * _liquidityFee[feeIndex]) / (10**(_feeDecimal + 2)); _marketingFeeCollected += marketingFee; _donationFeeCollected += donationFee; _liquidityFeeCollected += liquidityFee; return marketingFee + donationFee + liquidityFee; }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol",
        "final_score": 6.5
    },
    {
        "function_name": "setBlacklist",
        "vulnerability": "Centralized Control Vulnerability",
        "criticism": "The reasoning is correct. The 'setBlacklist' function does allow the owner to arbitrarily blacklist any address, which undermines the decentralized nature of blockchain. However, the severity and profitability of this vulnerability are high only if the owner decides to exploit this power.",
        "correctness": 7,
        "severity": 5,
        "profitability": 5,
        "reason": "The 'setBlacklist' function allows the owner to arbitrarily blacklist any address, effectively freezing their tokens and preventing them from transferring their holdings. This central authority undermines the decentralized nature of blockchain and can be exploited by the owner to maliciously block any user from interacting with the contract.",
        "code": "function setBlacklist(address account, bool isBlacklisted) external onlyOwner { blacklist[account] = isBlacklisted; }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol",
        "final_score": 6.0
    },
    {
        "function_name": "swap",
        "vulnerability": "Reentrancy Vulnerability",
        "criticism": "The reasoning is partially correct. The 'swap()' function does use the 'sendViaCall()' function, which can potentially be used for reentrancy attacks. However, the function is wrapped with a 'lockTheSwap' modifier, which prevents direct reentrancy within the same function. Therefore, the severity and profitability of this vulnerability are low unless the 'lockTheSwap' modifier is bypassed.",
        "correctness": 5,
        "severity": 3,
        "profitability": 3,
        "reason": "The 'swap()' function uses the 'sendViaCall()' function, which transfers Ether and can potentially be used for reentrancy attacks if the receiving contract is malicious and re-enters the contract logic. Although the function is wrapped with a 'lockTheSwap' modifier, which prevents direct reentrancy within the same function, it should be ensured that all state changes are completed before making external calls.",
        "code": "function swap() private lockTheSwap { uint totalCollected = _marketingFeeCollected + _donationFeeCollected + _liquidityFeeCollected; uint amountToSwap = _marketingFeeCollected + _donationFeeCollected + (_liquidityFeeCollected / 2); uint amountTokensToLiquidity = totalCollected - amountToSwap; if(minTokensBeforeSwap > totalCollected) return; address[] memory sellPath = new address[](2); sellPath[0] = address(this); sellPath[1] = router.WETH(); uint balanceBefore = address(this).balance; _approve(address(this), address(router), amountToSwap); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, sellPath, address(this), block.timestamp ); uint amountFee = address(this).balance - balanceBefore; uint amountMarketing = (amountFee * _marketingFeeCollected) / totalCollected; if(amountMarketing > 0) sendViaCall(payable(marketing_wallet), amountMarketing); uint amountDonation = (amountFee * _donationFeeCollected) / totalCollected; if(amountDonation > 0) sendViaCall(payable(donation_wallet), amountDonation); uint256 amountETHLiquidity = address(this).balance; if(amountTokensToLiquidity > 0){ _approve(address(this), address(router), amountTokensToLiquidity); router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountTokensToLiquidity, 0, 0, liquidity_wallet, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountTokensToLiquidity); } _marketingFeeCollected = 0; _donationFeeCollected = 0; _liquidityFeeCollected = 0; emit Swap(totalCollected, amountMarketing, amountDonation); }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol",
        "final_score": 4.0
    }
]