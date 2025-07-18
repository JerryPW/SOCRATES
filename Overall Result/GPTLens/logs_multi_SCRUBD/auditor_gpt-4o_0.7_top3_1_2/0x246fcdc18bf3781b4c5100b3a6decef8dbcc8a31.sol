[
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), \"Owner cannot claim native tokens\"); if (token == address(0x0)) { payable(msg.sender).sendValue(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Potential misuse by owner",
        "reason": "The claimStuckTokens function allows the owner to transfer any ERC20 tokens held by the contract to themselves, except for the native token. While restricted to the owner, this functionality can be misused to drain tokens sent to the contract inadvertently, potentially harming users who mistakenly transfer tokens to the contract address.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    },
    {
        "function_name": "setBuyFeePercentages",
        "code": "function setBuyFeePercentages(uint256 _taxFeeonBuy, uint256 _buybackBurnFeeOnBuy, uint256 _marketingFeeonBuy) external onlyOwner { taxFeeonBuy = _taxFeeonBuy; buybackBurnFeeOnBuy = _buybackBurnFeeOnBuy; marketingFeeonBuy = _marketingFeeonBuy; totalBuyFees = _taxFeeonBuy + _buybackBurnFeeOnBuy + _marketingFeeonBuy; require(totalBuyFees <= 10, \"Buy fees cannot be greater than 10%\"); emit BuyFeesChanged(taxFeeonBuy, buybackBurnFeeOnBuy, marketingFeeonBuy); }",
        "vulnerability": "Fee manipulation by owner",
        "reason": "The setBuyFeePercentages function allows the owner to modify the buy fee percentages up to a maximum of 10%. This level of control over transaction fees can be exploited by the owner to impose high fees unexpectedly, which could adversely affect token holders and traders.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    },
    {
        "function_name": "setSellFeePercentages",
        "code": "function setSellFeePercentages(uint256 _taxFeeonSell, uint256 _buybackBurnFeeOnSell, uint256 _marketingFeeonSell) external onlyOwner { taxFeeonSell = _taxFeeonSell; buybackBurnFeeOnSell = _buybackBurnFeeOnSell; marketingFeeonSell = _marketingFeeonSell; totalSellFees = _taxFeeonSell + _buybackBurnFeeOnSell + _marketingFeeonSell; require(totalSellFees <= 10, \"Sell fees cannot be greater than 10%\"); emit SellFeesChanged(taxFeeonSell, buybackBurnFeeOnSell, marketingFeeonSell); }",
        "vulnerability": "Fee manipulation by owner",
        "reason": "The setSellFeePercentages function allows the owner to adjust sell fee percentages up to a 10% cap, giving the owner the ability to impose high fees on sellers. This could be exploited to penalize sellers or create an unfavorable trading environment, impacting the token's market dynamics.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    }
]