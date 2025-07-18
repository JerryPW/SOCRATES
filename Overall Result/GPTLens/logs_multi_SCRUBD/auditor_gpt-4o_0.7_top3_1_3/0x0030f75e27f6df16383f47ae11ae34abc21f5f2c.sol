[
    {
        "function_name": "launchSetLiquidityAddress",
        "code": "function launchSetLiquidityAddress(address LPAddress) internal {\n    liquidityAddress = payable(LPAddress);\n    isTaxExcluded[liquidityAddress] = true;\n}",
        "vulnerability": "Use of arbitrary address as liquidity address",
        "reason": "The function `launchSetLiquidityAddress` allows setting any arbitrary address as the liquidity address without any validation. This can be exploited by a malicious actor to set an address they control as the liquidity address, potentially diverting funds intended for liquidity provision to themselves.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){\n    require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\");\n    uint256 liquidityPairBalance = this.balanceOf(uniV2Pair);\n    uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2);\n    if (amountToBurn > 0){\n        internalTransfer(uniV2Pair, dead, amountToBurn);\n    }\n    totalBurnedTokens = balanceOf(dead);\n    require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\");\n    IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair);\n    pair.sync();\n    return true;\n}",
        "vulnerability": "Potential for excessive token burning",
        "reason": "The `manualBurnTokensFromLP` function allows the owner to burn tokens from the liquidity pool up to a specified percentage. Though it is capped at 10% per transaction, repeated calls can deplete the liquidity pool, affecting the token's market liquidity and price stability. This can be abused by the owner or if the contract is compromised, adversely affecting token holders.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner {\n    bool success;\n    (success,) = address(owner()).call{value: address(this).balance}(\"\");\n}",
        "vulnerability": "Owner can withdraw all ETH from the contract",
        "reason": "The `withdrawStuckETH` function allows the contract owner to withdraw all ETH from the contract balance. This could be exploited by a malicious owner to siphon off funds, especially if the contract accumulates significant ETH through operations or token sales. This poses a risk to token holders and any parties expecting ETH to be used for contract functionality.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    }
]