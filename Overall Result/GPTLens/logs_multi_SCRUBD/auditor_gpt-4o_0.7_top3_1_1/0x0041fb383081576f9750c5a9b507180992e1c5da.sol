[
    {
        "function_name": "updateFees",
        "code": "function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy, uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner { buyMarketingFees = marketingBuy; buyLiquidityFee = liquidityBuy; sellMarketingFees = marketingSell; sellLiquidityFee = liquiditySell; buyDevFee = devBuy; sellDevFee = devSell; totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee); totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee); require(totalSellFees <= 99 && totalBuyFees <= 99, \"total fees cannot be higher than 15%\"); emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees, buyLiquidityFee, buyDevFee); }",
        "vulnerability": "Misleading Fee Limit Check",
        "reason": "The require statement comments indicate that total fees cannot exceed 15%, but the actual check allows up to 99%. This discrepancy can mislead stakeholders and result in unexpectedly high fees, which might deter users or attract regulatory scrutiny.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Irreversible Ownership Renouncement",
        "reason": "Renouncing ownership sets the owner to the zero address, making it impossible to recover or transfer ownership in the future. This could lead to a situation where the contract cannot be upgraded or managed, potentially leaving users unprotected in case of vulnerabilities or the need for updates.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "Sweep",
        "code": "function Sweep() external onlyOwner { uint256 amountBNB = address(this).balance; payable(msg.sender).transfer(amountBNB); }",
        "vulnerability": "Potential Misuse of Sweep Function",
        "reason": "The Sweep function allows the owner to withdraw the entire balance of the contract. Without restrictions or conditions, this can be misused by a malicious owner to drain the contract's funds, harming the interests of other stakeholders and users.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    }
]