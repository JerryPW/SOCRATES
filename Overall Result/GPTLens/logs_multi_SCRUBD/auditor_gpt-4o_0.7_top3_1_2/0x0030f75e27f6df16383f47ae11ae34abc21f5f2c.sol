[
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Liquidity manipulation",
        "reason": "This function allows the owner to burn a percentage of the liquidity pool tokens, which can manipulate the price and liquidity of the token on decentralized exchanges. This can be exploited to create price volatility and potentially harm traders.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens(uint256 percent) external onlyOwner { internalTransfer(address(this), owner(), tokenSupply*percent/100); }",
        "vulnerability": "Unauthorized token withdrawal",
        "reason": "The function allows the owner to withdraw a percentage of tokens from the contract's balance without any restrictions. This can be exploited by the owner to drain tokens from the contract, which might include user-deposited tokens, leading to a loss for token holders.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "setTaxes",
        "code": "function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner { taxBuyMarketing = buyMarketingTax; taxBuyLiquidity = buyLiquidityTax; taxSellMarketing = sellMarketingTax; taxSellLiquidity = sellLiquidityTax; }",
        "vulnerability": "Tax rate manipulation",
        "reason": "This function allows the owner to set arbitrary tax rates for buying and selling. High taxes can be set to effectively lock user funds or manipulate market behavior, posing a significant risk to users as it can affect their ability to trade tokens freely.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    }
]