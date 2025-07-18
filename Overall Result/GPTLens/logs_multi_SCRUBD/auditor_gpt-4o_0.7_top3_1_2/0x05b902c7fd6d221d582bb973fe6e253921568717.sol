[
    {
        "function_name": "setSellFee",
        "code": "function setSellFee(uint256 _onSellEthBurnFee, uint256 _onSellliquidityFee, uint256 _onSellMarketingFee) public onlyOwner { SELLmarketingFee = _onSellMarketingFee; SELLburnFee = _onSellEthBurnFee; SELLliquidityFee = _onSellliquidityFee; uint256 onSelltotalFees; onSelltotalFees = SELLmarketingFee.add(SELLburnFee).add(SELLliquidityFee); require(onSelltotalFees <= 15, \"Sell Fee should be 15% or less\"); }",
        "vulnerability": "Fee manipulation by owner",
        "reason": "The setSellFee function allows the contract owner to change the sell fees up to a total of 15%. Although there is a limit, the owner can still manipulate the fees to the maximum limit, which could be harmful to the users, especially if the fees are set to the maximum allowed value without prior notice.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "setBuyFee",
        "code": "function setBuyFee(uint256 _onBuyBurnFee, uint256 _onBuyliquidityFee, uint256 _onBuyMarketingFee) public onlyOwner { BUYmarketingFee = _onBuyMarketingFee; BUYburnFee = _onBuyBurnFee; BUYliquidityFee = _onBuyliquidityFee; uint256 onBuytotalFees; onBuytotalFees = BUYmarketingFee.add(BUYburnFee).add(BUYliquidityFee); require(onBuytotalFees <= 15, \"Buy Fee should be 15% or less\"); }",
        "vulnerability": "Fee manipulation by owner",
        "reason": "Similar to the setSellFee function, the setBuyFee function allows the owner to change the buy fees up to a total of 15%. This creates a risk for users as the owner could potentially increase the fees to the maximum without their consent, resulting in unexpected high transaction costs.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "withdrawStuckETh",
        "code": "function withdrawStuckETh() external onlyOwner { require (address(this).balance > 0, \"Can't withdraw negative or zero\"); payable(owner()).transfer(address(this).balance); }",
        "vulnerability": "Potential misuse of contract funds",
        "reason": "The withdrawStuckETh function allows the owner to withdraw all the Ether balance from the contract. This could be misused by a malicious owner to drain Ether that might have been sent to the contract inadvertently or through swap operations, thus resulting in a loss of funds for the users.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    }
]