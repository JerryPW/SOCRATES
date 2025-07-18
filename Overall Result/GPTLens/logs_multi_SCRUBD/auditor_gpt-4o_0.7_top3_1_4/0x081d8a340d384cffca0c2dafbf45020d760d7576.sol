[
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); _approve(address(this), address(router), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); (bool success, ) = treasuryAddress.call{value: (ETHAmount.treasury * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.treasury = 0; (success, ) = developmentAddress.call{value: (ETHAmount.development * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.development = 0; }",
        "vulnerability": "Incorrect ETH transfer calculations",
        "reason": "The function attempts to distribute ETH to the treasury and development addresses using division based on `tokenAmount`. However, the calculations for the ETH distribution are incorrect because they rely on the current balance of the contract, which can be manipulated by an attacker to drain the contract's ETH balance.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "updateTreasuryWallet",
        "code": "function updateTreasuryWallet(address newWallet) external onlyOwner addressValidation(newWallet) { require(treasuryAddress != newWallet, 'SOLIDBLOCK: Wallet already set'); treasuryAddress = newWallet; _isExcludedFromFee[treasuryAddress]; }",
        "vulnerability": "Missing exclusion from fee",
        "reason": "The function is intended to update the treasury wallet and set it as excluded from fees. However, the line `_isExcludedFromFee[treasuryAddress];` does not perform any operation to actually exclude the new treasury address from fees. This could lead to unintended transactions fees for the treasury wallet.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "airdropTokens",
        "code": "function airdropTokens(address[] memory recipients, uint256[] memory amounts) external onlyOwner { require(recipients.length == amounts.length,\"Invalid size\"); address sender = msg.sender; for(uint256 i; i<recipients.length; i++){ address recipient = recipients[i]; uint256 rAmount = amounts[i]*_getRate(); _rOwned[sender] = _rOwned[sender]- rAmount; _rOwned[recipient] = _rOwned[recipient] + rAmount; emit Transfer(sender, recipient, amounts[i]); } }",
        "vulnerability": "Potential integer overflow",
        "reason": "The function multiplies `amounts[i]` by the rate obtained from `_getRate()`, which could potentially lead to an integer overflow if `amounts[i]` is large enough. This would result in incorrect token transfers or even allow an attacker to exploit the overflow to manipulate balances.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    }
]