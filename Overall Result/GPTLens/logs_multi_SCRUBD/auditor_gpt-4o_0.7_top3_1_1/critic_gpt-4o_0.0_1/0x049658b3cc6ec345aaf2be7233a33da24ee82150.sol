[
    {
        "function_name": "withdrawStuckTokens",
        "vulnerability": "Owner can withdraw arbitrary tokens",
        "criticism": "The reasoning is correct. The owner of the contract can withdraw arbitrary tokens. This could lead to an arbitrary decrease in the token supply, devaluing existing tokens. However, this isn't inherently a vulnerability, but rather a design decision that might be questionable. The severity is moderate because it is based on the owner's intention. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 4,
        "profitability": 0,
        "reason": "The `withdrawStuckTokens` function allows the owner to transfer a percentage of the total token supply from the contract's balance to the owner's address. This can be exploited by the owner to withdraw an arbitrary number of tokens that might be mistakenly sent to the contract address, which could potentially include user funds. This function lacks a mechanism to restrict the maximum percentage that can be withdrawn, resulting in a risk of significant token loss for users.",
        "code": "function withdrawStuckTokens(uint256 percent) external onlyOwner { internalTransfer(address(this), owner(), tokenSupply*percent/100); }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "vulnerability": "Potential abuse of LP token burning",
        "criticism": "The reasoning is correct. The owner of the contract can burn arbitrary tokens from the LP pool. This could lead to a significant reduction in liquidity, impacting the token's market and price stability. However, the severity is moderate because it is based on the owner's intention. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 4,
        "profitability": 0,
        "reason": "The `manualBurnTokensFromLP` function allows the owner to burn a portion of the liquidity tokens from the LP pool. Although there's a restriction to only burn up to 10% at a time, this could be abused by repeatedly calling the function, leading to a significant reduction of liquidity. This can severely impact the token's market and price stability, as it might result in reduced liquidity and increased price volatility.",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "setTaxes",
        "vulnerability": "Unrestricted tax modification",
        "criticism": "The reasoning is correct. The owner of the contract can arbitrarily set the taxes for buying and selling. This could lead to excessively high taxes, effectively confiscating a large portion of transactions and making the token unusable for trade. The severity is high because it can trap users' funds in the contract. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 9,
        "severity": 8,
        "profitability": 0,
        "reason": "The `setTaxes` function allows the owner to arbitrarily set the taxes for buying and selling without any constraints on their values. This presents a significant risk where the owner could set excessively high taxes, effectively confiscating a large portion of transactions and making the token unusable for trade. This can be particularly damaging to users who might not be aware of sudden tax changes, trapping their funds in the contract.",
        "code": "function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner { taxBuyMarketing = buyMarketingTax; taxBuyLiquidity = buyLiquidityTax; taxSellMarketing = sellMarketingTax; taxSellLiquidity = sellLiquidityTax; }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    }
]