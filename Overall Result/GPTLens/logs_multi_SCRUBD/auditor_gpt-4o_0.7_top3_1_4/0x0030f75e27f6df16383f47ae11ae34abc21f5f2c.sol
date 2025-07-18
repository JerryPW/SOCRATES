[
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens(uint256 percent) external onlyOwner { internalTransfer(address(this), owner(), tokenSupply*percent/100); }",
        "vulnerability": "Owner can withdraw any tokens from the contract",
        "reason": "The withdrawStuckTokens function allows the owner to transfer a percentage of the token supply from the contract to their own address. This can be exploited by the owner to drain the contract's token balance, which could be detrimental to token holders as it may lead to a loss of liquidity or manipulation of token price.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Potential liquidity manipulation by the owner",
        "reason": "The manualBurnTokensFromLP function allows the owner to burn tokens from the liquidity pool up to 10% of the liquidity pool's balance per call. This could potentially be used by the owner to manipulate the token's liquidity and price, which might not be in the best interest of all token holders.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "setTaxes",
        "code": "function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner { taxBuyMarketing = buyMarketingTax; taxBuyLiquidity = buyLiquidityTax; taxSellMarketing = sellMarketingTax; taxSellLiquidity = sellLiquidityTax; }",
        "vulnerability": "Owner can arbitrarily change tax rates",
        "reason": "The setTaxes function enables the contract owner to change the marketing and liquidity tax rates for both buying and selling transactions. This power can be abused to set excessively high tax rates, effectively trapping users into unfavorable trading conditions and potentially dissuading trading activity.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    }
]