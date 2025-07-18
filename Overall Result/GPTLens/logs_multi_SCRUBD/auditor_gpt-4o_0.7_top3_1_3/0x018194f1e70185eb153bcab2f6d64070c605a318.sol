[
    {
        "function_name": "owner_rescueERCTokens",
        "code": "function owner_rescueERCTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), marketingAddr, excessTokens); }",
        "vulnerability": "Unrestricted token withdrawal",
        "reason": "The function `owner_rescueERCTokens` allows any caller to withdraw excess tokens from the contract balance to the marketing address. This function does not enforce any access control such as `onlyOwner`, allowing anyone to potentially exploit this to drain tokens from the contract that are not earmarked for taxes.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "owner_disableSwapEnabled",
        "code": "function owner_disableSwapEnabled() external { swapEnabled = false; }",
        "vulnerability": "Missing access control",
        "reason": "The function `owner_disableSwapEnabled` lacks an `onlyOwner` modifier, allowing any external caller to disable the swap functionality of the contract. This could be exploited by an attacker to disable the swap and potentially interfere with the contract's operations or liquidity provisions.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "_getTaxValues",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "vulnerability": "Incorrect tax calculation",
        "reason": "In the `_getTaxValues` function, the tax calculation for a sell transaction incorrectly subtracts the liquidity pool fee (`_lpFee`) divided by the `feeDenominator` from the marketing tax. This could result in a negative value for the marketing tax, leading to incorrect tax calculations and potential contract malfunction, especially if `_lpFee` is large relative to `feeDenominator`.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    }
]