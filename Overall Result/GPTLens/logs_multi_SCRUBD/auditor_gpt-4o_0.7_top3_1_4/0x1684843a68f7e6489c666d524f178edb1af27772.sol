[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Lack of Ownership Transfer Restrictions",
        "reason": "The function does not check if the new owner address is valid (e.g., non-zero address). This could potentially lead to loss of ownership if the owner mistakenly transfers ownership to an invalid address.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    },
    {
        "function_name": "clearStuckBalance",
        "code": "function clearStuckBalance(uint256 amountPercentage) external onlyOwner { uint256 amountETH = address(this).balance; payable(investmentFeeReceiver).transfer((amountETH * amountPercentage) / 100); }",
        "vulnerability": "Potential Misuse of Funds",
        "reason": "This function allows the owner to withdraw ETH from the contract without any restrictions on the percentage, potentially enabling them to drain the entire balance of the contract.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    },
    {
        "function_name": "setCanTransferBeforeLaunch",
        "code": "function setCanTransferBeforeLaunch(address holder, bool exempt) external onlyOwner { canAddLiquidityBeforeLaunch[holder] = exempt; isTxLimitExempt[holder] = exempt; isFeeExempt[holder] = exempt; }",
        "vulnerability": "Potential Bypassing of Trading Restrictions",
        "reason": "This function allows the owner to exempt specified addresses from trading limits and fees before the official launch. If misused, it can enable unauthorized trading or manipulation of token distribution before launch.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    }
]