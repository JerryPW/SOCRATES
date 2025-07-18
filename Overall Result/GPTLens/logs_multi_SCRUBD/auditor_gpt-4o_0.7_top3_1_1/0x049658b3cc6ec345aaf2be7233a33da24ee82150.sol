[
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens(uint256 percent) external onlyOwner { internalTransfer(address(this), owner(), tokenSupply*percent/100); }",
        "vulnerability": "Owner can withdraw arbitrary tokens",
        "reason": "The `withdrawStuckTokens` function allows the owner to transfer a percentage of the total token supply from the contract's balance to the owner's address. This can be exploited by the owner to withdraw an arbitrary number of tokens that might be mistakenly sent to the contract address, which could potentially include user funds. This function lacks a mechanism to restrict the maximum percentage that can be withdrawn, resulting in a risk of significant token loss for users.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Potential abuse of LP token burning",
        "reason": "The `manualBurnTokensFromLP` function allows the owner to burn a portion of the liquidity tokens from the LP pool. Although there's a restriction to only burn up to 10% at a time, this could be abused by repeatedly calling the function, leading to a significant reduction of liquidity. This can severely impact the token's market and price stability, as it might result in reduced liquidity and increased price volatility.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "setTaxes",
        "code": "function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner { taxBuyMarketing = buyMarketingTax; taxBuyLiquidity = buyLiquidityTax; taxSellMarketing = sellMarketingTax; taxSellLiquidity = sellLiquidityTax; }",
        "vulnerability": "Unrestricted tax modification",
        "reason": "The `setTaxes` function allows the owner to arbitrarily set the taxes for buying and selling without any constraints on their values. This presents a significant risk where the owner could set excessively high taxes, effectively confiscating a large portion of transactions and making the token unusable for trade. This can be particularly damaging to users who might not be aware of sudden tax changes, trapping their funds in the contract.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    }
]