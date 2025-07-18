[
    {
        "function_name": "owner_updateSwapEnabled",
        "code": "function owner_updateSwapEnabled(bool _swapEnable) external { swapEnabled = false; }",
        "vulnerability": "Logic error in enabling swap functionality",
        "reason": "The function is supposed to update the 'swapEnabled' state variable based on the parameter '_swapEnable'. However, it unconditionally sets 'swapEnabled' to 'false', regardless of the input. This logic error means that once this function is called, the swap functionality will be disabled permanently, unless corrected by another function. This could be exploited by the contract owner to disable swapping, affecting liquidity and potentially causing harm to token holders who rely on swapping for liquidity.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "owner_rescueExcessTokens",
        "code": "function owner_rescueExcessTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), feeWallet, excessTokens); }",
        "vulnerability": "Potential for misuse in token rescue",
        "reason": "The function allows the contract owner to transfer any tokens from the contract's balance that are deemed 'excess' to the 'feeWallet'. There is no restriction on the timing or frequency of this operation, which could allow the owner to drain the contract of its tokens, affecting liquidity and potentially harming token holders. This is especially dangerous if the contract accumulates tokens for specific purposes like providing liquidity or paying rewards.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify() private lockTheSwap{ if(totalTokensFromTax.marketingTokens > 0){ uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens); if(ethSwapped > 0){ payable(feeWallet).transfer(ethSwapped); totalTokensFromTax.marketingTokens = 0; } } if(totalTokensFromTax.lpTokens > 0){ uint half = totalTokensFromTax.lpTokens / 2; uint otherHalf = totalTokensFromTax.lpTokens - half; uint balAutoLP = swapTokensForETH(half); if (balAutoLP > 0) addLiquidity(otherHalf, balAutoLP); totalTokensFromTax.lpTokens = 0; } emit SwapAndLiquify(); _lastSwap = block.timestamp; }",
        "vulnerability": "Inefficient liquidity provision and potential for front-running",
        "reason": "The function performs token swaps and liquidity provision without considering slippage or price impact. This can result in large price fluctuations or unfavorable rates during swaps, especially if the liquidity pool is small, leading to losses. Additionally, the function does not use any mechanisms to prevent front-running, allowing for potential market manipulation. Attackers could monitor the blockchain for swap transactions and execute their trades before to take advantage of the expected price changes, to the detriment of the contract and its users.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    }
]