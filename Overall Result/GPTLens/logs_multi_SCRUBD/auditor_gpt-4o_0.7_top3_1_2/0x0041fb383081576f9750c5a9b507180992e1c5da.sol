[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() external onlyOwner { require(!tradingEnabled); tradingEnabled = true; launchblock = block.number; launchtimestamp = block.timestamp; emit TradingEnabled(); }",
        "vulnerability": "No anti-bot measures",
        "reason": "The enableTrading function does not incorporate any anti-bot measures. When trading is enabled, bots can quickly exploit the absence of restrictions to buy tokens in large quantities before regular users have a chance to participate. This can lead to price manipulation and unfair distribution of tokens.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "transferAdmin",
        "code": "function transferAdmin(address newOwner) public onlyOwner { _isExcludedFromFees[newOwner] = true; canTransferBeforeTradingIsEnabled[newOwner] = true; transferOwnership(newOwner); }",
        "vulnerability": "Privilege escalation",
        "reason": "The transferAdmin function allows the current owner to transfer admin privileges to a new address while excluding the new owner from fees and enabling transfers before trading is officially enabled. This can be exploited by the owner to give themselves or another address unfair advantages, such as bypassing trading restrictions and fee structures intended for regular users.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "updateFees",
        "code": "function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy, uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner { buyMarketingFees = marketingBuy; buyLiquidityFee = liquidityBuy; sellMarketingFees = marketingSell; sellLiquidityFee = liquiditySell; buyDevFee = devBuy; sellDevFee = devSell; totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee); totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee); require(totalSellFees <= 99 && totalBuyFees <= 99, \"total fees cannot be higher than 15%\"); emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees, buyLiquidityFee, buyDevFee); }",
        "vulnerability": "High fee adjustment",
        "reason": "The updateFees function allows the owner to set the fees up to 99%. Although there is a check in place to ensure the total fees do not exceed 15%, the commented limit suggests a potential for misconfiguration. If the limit is bypassed or the code is changed, fees can be set to unreasonable levels, which can be detrimental to users and discourage trading.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    }
]