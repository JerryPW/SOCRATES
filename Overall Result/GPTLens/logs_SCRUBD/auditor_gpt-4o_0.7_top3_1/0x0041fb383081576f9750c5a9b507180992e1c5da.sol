[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() external onlyOwner { require(!tradingEnabled); tradingEnabled = true; launchblock = block.number; launchtimestamp = block.timestamp; emit TradingEnabled(); }",
        "vulnerability": "No restriction on trading enablement",
        "reason": "The function allows the owner to enable trading at any time without any restrictions or conditions. This can lead to potential unfair advantages, such as allowing the owner to trade before others or enabling trading at a favorable time for themselves, which could be considered a form of market manipulation.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "setAutomatedMarketMakerPair",
        "code": "function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner { _setAutomatedMarketMakerPair(pair, value); }",
        "vulnerability": "Centralized control over AMM pairs",
        "reason": "The owner has the exclusive ability to set or unset automated market maker pairs. This centralization could be exploited by the owner to manipulate trading by adding or removing liquidity pairs at will, potentially impacting the token's market behavior and price.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "updateFees",
        "code": "function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy, uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner { buyMarketingFees = marketingBuy; buyLiquidityFee = liquidityBuy; sellMarketingFees = marketingSell; sellLiquidityFee = liquiditySell; buyDevFee = devBuy; sellDevFee = devSell; totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee); totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee); require(totalSellFees <= 99 && totalBuyFees <= 99, \"total fees cannot be higher than 15%\"); emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees, buyLiquidityFee, buyDevFee); }",
        "vulnerability": "Excessive fee setting",
        "reason": "Although the function attempts to limit fees to 99% instead of the commented 15%, the owner can still set fees extremely high, up to 99%. This could lead to scenarios where users' transactions are almost entirely consumed by fees, effectively nullifying their value and potentially defrauding users.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    }
]