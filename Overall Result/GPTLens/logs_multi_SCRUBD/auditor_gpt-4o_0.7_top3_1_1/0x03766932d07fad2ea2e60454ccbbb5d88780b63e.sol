[
    {
        "function_name": "owner_rescueExcessTokens",
        "code": "function owner_rescueExcessTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), feeWallet, excessTokens); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The function owner_rescueExcessTokens does not have the onlyOwner modifier, allowing anyone to call this function and transfer excess tokens to the feeWallet, which could lead to unauthorized token extraction.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "owner_updateSwapEnabled",
        "code": "function owner_updateSwapEnabled(bool _swapEnable) external { swapEnabled = false; }",
        "vulnerability": "Incorrect Functionality",
        "reason": "The function owner_updateSwapEnabled is meant to update the swapEnabled state variable based on the input _swapEnable. However, it always sets swapEnabled to false, ignoring the input parameter. This could result in the inability to enable swaps once disabled.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "_getTaxValues",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "vulnerability": "Incorrect Logic in Tax Calculation",
        "reason": "The function _getTaxValues has incorrect logic for calculating the sell tax. It attempts to subtract a value derived from the contract's balance divided by the feeDenominator from the marketing tax, which can lead to unintended negative tax rates. This could potentially allow for zero or negative taxes during certain conditions, impacting the expected tax collection.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    }
]