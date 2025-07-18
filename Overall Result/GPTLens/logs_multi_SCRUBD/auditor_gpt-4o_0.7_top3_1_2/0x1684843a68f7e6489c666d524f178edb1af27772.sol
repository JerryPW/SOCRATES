[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Authorization Privilege Escalation",
        "reason": "The function allows the owner to transfer ownership to a new address and automatically grants the new owner authorization. If the ownership is transferred to a malicious address, it could permanently lock out legitimate users or perform unauthorized actions.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    },
    {
        "function_name": "setCanTransferBeforeLaunch",
        "code": "function setCanTransferBeforeLaunch(address holder, bool exempt) external onlyOwner { canAddLiquidityBeforeLaunch[holder] = exempt; isTxLimitExempt[holder] = exempt; isFeeExempt[holder] = exempt; }",
        "vulnerability": "Pre-launch Exemption Manipulation",
        "reason": "The owner can exempt any address from transaction limits, fees, and liquidity restrictions before the launch. This could allow the owner or an authorized party to perform actions that are unfair to other participants, such as avoiding fees or bypassing transaction limits.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    },
    {
        "function_name": "clearStuckBalance",
        "code": "function clearStuckBalance(uint256 amountPercentage) external onlyOwner { uint256 amountETH = address(this).balance; payable(investmentFeeReceiver).transfer((amountETH * amountPercentage) / 100); }",
        "vulnerability": "Potential Misuse of Contract's Balance",
        "reason": "The function allows the owner to transfer a percentage of the contract's ETH balance to the investment fee receiver. This poses a risk of draining funds from the contract, especially if the owner is compromised or acts maliciously.",
        "file_name": "0x1684843a68f7e6489c666d524f178edb1af27772.sol"
    }
]