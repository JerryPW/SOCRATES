[
    {
        "function_name": "owner_rescueERCTokens",
        "code": "function owner_rescueERCTokens() public { uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), marketingAddr, excessTokens); }",
        "vulnerability": "Unrestricted Token Drain",
        "reason": "The function owner_rescueERCTokens() allows the owner to transfer all excess tokens from the contract to the marketing address without any restrictions or time locks. This means that the owner can potentially drain all tokens from the contract, which poses a significant risk to token holders as it allows for potential abuse and could lead to a loss of trust in the contract.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "owner_disableSwapEnabled",
        "code": "function owner_disableSwapEnabled() external { swapEnabled = false; }",
        "vulnerability": "Disabling Swap Arbitrarily",
        "reason": "The owner_disableSwapEnabled() function allows the owner to disable the swap functionality at any time. This can lead to a situation where token holders are unable to trade, effectively freezing their assets. This kind of control undermines the decentralization and trustless nature expected in smart contracts, potentially leading to manipulation or loss of confidence in the token.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify() private lockTheSwap{ if(totalTokensFromTax.marketingTokens > 0){ uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens); if(ethSwapped > 0){ payable(marketingAddr).transfer(ethSwapped); totalTokensFromTax.marketingTokens = 0; } } if(totalTokensFromTax.lpTokens > 0){ uint half = totalTokensFromTax.lpTokens / 2; uint otherHalf = totalTokensFromTax.lpTokens - half; uint balAutoLP = swapTokensForETH(half); if (balAutoLP > 0) addLiquidity(otherHalf, balAutoLP); totalTokensFromTax.lpTokens = 0; } emit SwapAndLiquify(); _lastSwap = block.timestamp; }",
        "vulnerability": "Potential Front-Running",
        "reason": "The swapAndLiquify() function can be front-run by attackers. Since it swaps tokens for ETH and adds liquidity, an attacker can monitor the blockchain for when the balance exceeds the swap limit and then front-run the transaction to profit from price movements. This can lead to significant losses for the contract and its users.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    }
]