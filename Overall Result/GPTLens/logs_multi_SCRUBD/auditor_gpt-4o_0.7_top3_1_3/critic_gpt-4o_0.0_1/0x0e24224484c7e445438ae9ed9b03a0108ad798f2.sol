[
    {
        "function_name": "calculateFee",
        "vulnerability": "Excessive Fee Imposition",
        "criticism": "The reasoning is partially correct. The function does allow for an extra fee to be imposed, which could be significant if the `extra_fee_percent` is set to a high value. However, the claim of a 90% fee is speculative without knowing the actual value of `extra_fee_percent`. The severity is moderate as it can impact usability and value, but it is a design choice rather than a vulnerability. Profitability is low for external attackers as they cannot directly exploit this for gain.",
        "correctness": 6,
        "severity": 5,
        "profitability": 1,
        "reason": "The function can impose an excessive extra fee of up to 90% (9000 basis points) when `extra_fee` is true, severely impacting the token's usability and value. This condition could be triggered by enabling restrictions and not whitelisting certain addresses, leading to exorbitant fees.",
        "code": "function calculateFee(uint256 feeIndex, uint256 amount, bool extra_fee) internal returns(uint256) { if(extra_fee) { uint256 extraFee = (amount * extra_fee_percent) / (10**(_feeDecimal + 2)); _marketingFeeCollected += extraFee; return extraFee; } uint256 marketingFee = (amount * _marketingFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 donationFee = (amount * _donationFee[feeIndex]) / (10**(_feeDecimal + 2)); uint256 liquidityFee = (amount * _liquidityFee[feeIndex]) / (10**(_feeDecimal + 2)); _marketingFeeCollected += marketingFee; _donationFeeCollected += donationFee; _liquidityFeeCollected += liquidityFee; return marketingFee + donationFee + liquidityFee; }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    },
    {
        "function_name": "swap",
        "vulnerability": "Reentrancy Risk with Unprotected External Calls",
        "criticism": "The reasoning is incorrect. The `lockTheSwap` modifier is designed to prevent reentrancy within the `swap` function, which mitigates the risk of reentrancy attacks. Additionally, the external calls are made to well-known contracts (Uniswap router), which are unlikely to have malicious fallback functions. The severity and profitability are low as the risk is already mitigated by the modifier.",
        "correctness": 3,
        "severity": 2,
        "profitability": 1,
        "reason": "The function `swap` contains multiple external calls to the Uniswap router and to wallets without any checks for reentrancy, aside from the `lockTheSwap` modifier that prevents reentrancy within the `swap` function itself. This could be exploited if any called contract has a fallback that calls back into this contract before state variables are updated, potentially resulting in the loss of funds.",
        "code": "function swap() private lockTheSwap { uint totalCollected = _marketingFeeCollected + _donationFeeCollected + _liquidityFeeCollected; uint amountToSwap = _marketingFeeCollected + _donationFeeCollected + (_liquidityFeeCollected / 2); uint amountTokensToLiquidity = totalCollected - amountToSwap; if(minTokensBeforeSwap > totalCollected) return; address[] memory sellPath = new address[](2); sellPath[0] = address(this); sellPath[1] = router.WETH(); uint balanceBefore = address(this).balance; _approve(address(this), address(router), amountToSwap); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, sellPath, address(this), block.timestamp ); uint amountFee = address(this).balance - balanceBefore; uint amountMarketing = (amountFee * _marketingFeeCollected) / totalCollected; if(amountMarketing > 0) sendViaCall(payable(marketing_wallet), amountMarketing); uint amountDonation = (amountFee * _donationFeeCollected) / totalCollected; if(amountDonation > 0) sendViaCall(payable(donation_wallet), amountDonation); uint256 amountETHLiquidity = address(this).balance; if(amountTokensToLiquidity > 0){ _approve(address(this), address(router), amountTokensToLiquidity); router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountTokensToLiquidity, 0, 0, liquidity_wallet, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountTokensToLiquidity); } _marketingFeeCollected = 0; _donationFeeCollected = 0; _liquidityFeeCollected = 0; emit Swap(totalCollected, amountMarketing, amountDonation); }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    },
    {
        "function_name": "transferOwnership",
        "vulnerability": "Ownership Transfer Risk",
        "criticism": "The reasoning is correct in identifying a potential risk when transferring ownership to a contract that may not handle ownership correctly. However, this is more of a user error risk rather than a vulnerability in the code itself. The severity is low as it requires the owner to make a mistake, and profitability is non-existent for external attackers.",
        "correctness": 7,
        "severity": 2,
        "profitability": 0,
        "reason": "The `transferOwnership` function allows the contract owner to transfer ownership to another address, but it does not consider the possibility of accidentally transferring ownership to a contract that does not handle ownership correctly, which could lead to permanent loss of ownership control if not handled properly by the recipient contract.",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); _transferOwnership(newOwner); }",
        "file_name": "0x0e24224484c7e445438ae9ed9b03a0108ad798f2.sol"
    }
]