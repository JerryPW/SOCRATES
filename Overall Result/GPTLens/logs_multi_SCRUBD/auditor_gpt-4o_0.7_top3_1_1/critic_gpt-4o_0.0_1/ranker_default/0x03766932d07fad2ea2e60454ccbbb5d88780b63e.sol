[
    {
        "function_name": "owner_rescueExcessTokens",
        "vulnerability": "Lack of Access Control",
        "criticism": "The reasoning is correct. The function owner_rescueExcessTokens lacks an access control modifier like onlyOwner, which allows any user to call this function and transfer excess tokens to the feeWallet. This is a significant vulnerability as it can lead to unauthorized token extraction. The severity is high because it can result in a loss of tokens from the contract. The profitability is also high because an attacker can directly profit by transferring tokens to a wallet they control.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function owner_rescueExcessTokens does not have the onlyOwner modifier, allowing anyone to call this function and transfer excess tokens to the feeWallet, which could lead to unauthorized token extraction.",
        "code": "function owner_rescueExcessTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), feeWallet, excessTokens); }",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol",
        "final_score": 8.5
    },
    {
        "function_name": "owner_updateSwapEnabled",
        "vulnerability": "Incorrect Functionality",
        "criticism": "The reasoning is correct. The function owner_updateSwapEnabled is supposed to update the swapEnabled state variable based on the input parameter _swapEnable. However, it always sets swapEnabled to false, ignoring the input. This is a logical error that can lead to the inability to enable swaps once they are disabled. The severity is moderate because it affects the functionality of the contract but does not directly lead to a loss of funds. The profitability is low because it does not provide a direct financial gain to an attacker.",
        "correctness": 9,
        "severity": 5,
        "profitability": 1,
        "reason": "The function owner_updateSwapEnabled is meant to update the swapEnabled state variable based on the input _swapEnable. However, it always sets swapEnabled to false, ignoring the input parameter. This could result in the inability to enable swaps once disabled.",
        "code": "function owner_updateSwapEnabled(bool _swapEnable) external { swapEnabled = false; }",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol",
        "final_score": 6.0
    },
    {
        "function_name": "_getTaxValues",
        "vulnerability": "Incorrect Logic in Tax Calculation",
        "criticism": "The reasoning is correct. The function _getTaxValues has a flawed logic for calculating the sell tax. By subtracting a value derived from the contract's balance divided by the feeDenominator from the marketing tax, it can result in unintended negative tax rates. This can lead to zero or negative taxes, impacting the expected tax collection. The severity is moderate because it affects the contract's ability to collect taxes as intended, but it does not directly lead to a loss of funds. The profitability is low because it does not provide a direct financial gain to an attacker.",
        "correctness": 9,
        "severity": 5,
        "profitability": 1,
        "reason": "The function _getTaxValues has incorrect logic for calculating the sell tax. It attempts to subtract a value derived from the contract's balance divided by the feeDenominator from the marketing tax, which can lead to unintended negative tax rates. This could potentially allow for zero or negative taxes during certain conditions, impacting the expected tax collection.",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol",
        "final_score": 6.0
    }
]