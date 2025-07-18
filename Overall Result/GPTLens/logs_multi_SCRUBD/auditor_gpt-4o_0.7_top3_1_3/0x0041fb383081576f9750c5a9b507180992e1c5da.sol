[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() external onlyOwner { require(!tradingEnabled); tradingEnabled = true; launchblock = block.number; launchtimestamp = block.timestamp; emit TradingEnabled(); }",
        "vulnerability": "Lack of anti-sniping mechanism",
        "reason": "The enableTrading function allows the owner to enable trading without any anti-sniping measures, such as a blacklist or adjustable trading delay. This can be exploited by bots or malicious users who can monitor the blockchain and immediately execute trades at the moment of trading activation, potentially leading to unfair advantages and financial losses for regular users.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "updateFees",
        "code": "function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy, uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner { buyMarketingFees = marketingBuy; buyLiquidityFee = liquidityBuy; sellMarketingFees = marketingSell; sellLiquidityFee = liquiditySell; buyDevFee = devBuy; sellDevFee = devSell; totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee); totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee); require(totalSellFees <= 99 && totalBuyFees <= 99, \"total fees cannot be higher than 15%\"); emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees, buyLiquidityFee, buyDevFee); }",
        "vulnerability": "Incorrect fee limit check",
        "reason": "The updateFees function allows the owner to set fees up to 99% despite the require statement's intent to limit total fees to 15%. This discrepancy arises from the wrong condition in the require statement (`require(totalSellFees <= 99 && totalBuyFees <= 99, \"total fees cannot be higher than 15%\");`). The actual condition allows for fees to be set extremely high, which can be detrimental to users trading the token due to excessive transaction costs.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    },
    {
        "function_name": "airdropToWallets",
        "code": "function airdropToWallets( address[] memory airdropWallets, uint256[] memory amount ) external onlyOwner { require(airdropWallets.length == amount.length, \"Arrays must be the same length\"); require(airdropWallets.length <= 200, \"Wallets list length must be <= 200\"); for (uint256 i = 0; i < airdropWallets.length; i++) { address wallet = airdropWallets[i]; uint256 airdropAmount = amount[i] * (10**18); super._transfer(msg.sender, wallet, airdropAmount); } }",
        "vulnerability": "Potential overflow in airdrop amounts",
        "reason": "The airdropToWallets function multiplies each amount by 10^18 without checking for overflow. If a large value is unintentionally specified in the amount array, it could result in an integer overflow, causing the function to misbehave and potentially transferring significantly more tokens than intended. This could be exploited to disrupt tokenomics or drain tokens from the owner's balance.",
        "file_name": "0x0041fb383081576f9750c5a9b507180992e1c5da.sol"
    }
]