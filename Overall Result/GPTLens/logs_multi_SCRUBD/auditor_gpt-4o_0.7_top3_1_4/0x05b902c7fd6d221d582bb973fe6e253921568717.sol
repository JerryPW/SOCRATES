[
    {
        "function_name": "setSellFee",
        "code": "function setSellFee(uint256 _onSellEthBurnFee, uint256 _onSellliquidityFee, uint256 _onSellMarketingFee) public onlyOwner { SELLmarketingFee = _onSellMarketingFee; SELLburnFee = _onSellEthBurnFee; SELLliquidityFee = _onSellliquidityFee; uint256 onSelltotalFees; onSelltotalFees = SELLmarketingFee.add(SELLburnFee).add(SELLliquidityFee); require(onSelltotalFees <= 15, \"Sell Fee should be 15% or less\"); }",
        "vulnerability": "Centralization of control",
        "reason": "The `setSellFee` function allows the owner to set the sell fees. Although there's a cap of 15%, this still gives significant control to the owner to adjust fees, which can be used maliciously to impact token holders adversely.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "setBuyFee",
        "code": "function setBuyFee(uint256 _onBuyBurnFee, uint256 _onBuyliquidityFee, uint256 _onBuyMarketingFee) public onlyOwner { BUYmarketingFee = _onBuyMarketingFee; BUYburnFee = _onBuyBurnFee; BUYliquidityFee = _onBuyliquidityFee; uint256 onBuytotalFees; onBuytotalFees = BUYmarketingFee.add(BUYburnFee).add(BUYliquidityFee); require(onBuytotalFees <= 15, \"Buy Fee should be 15% or less\"); }",
        "vulnerability": "Centralization of control",
        "reason": "Similar to `setSellFee`, the `setBuyFee` function allows the owner to adjust buy fees up to 15%. This can be used to manipulate market conditions in favor of the owner, potentially harming investors.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "withdrawStuckETh",
        "code": "function withdrawStuckETh() external onlyOwner{ require (address(this).balance > 0, \"Can't withdraw negative or zero\"); payable(owner()).transfer(address(this).balance); }",
        "vulnerability": "Owner can withdraw contract balance",
        "reason": "The `withdrawStuckETh` function allows the owner to withdraw the entire balance of ETH from the contract. While this function is often implemented to recover accidentally sent ETH, it poses a risk if the contract accumulates funds from other sources, enabling the owner to withdraw all funds, possibly without the knowledge or consent of token holders.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    }
]