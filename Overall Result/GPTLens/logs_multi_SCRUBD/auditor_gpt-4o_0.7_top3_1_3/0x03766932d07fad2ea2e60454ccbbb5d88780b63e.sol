[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) { _transfer(sender, recipient, amount); _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount); return true; }",
        "vulnerability": "Arithmetic Underflow in Allowance Update",
        "reason": "The `_approve` function is called to update the allowance after the `_transfer` function, but it does not check if the allowance is sufficient. If `amount` is greater than the current allowance, this will cause an underflow error, which will revert the transaction. This issue can be exploited by trying to transfer more tokens than allowed, causing a denial of service.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "owner_rescueExcessTokens",
        "code": "function owner_rescueExcessTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), feeWallet, excessTokens); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The function `owner_rescueExcessTokens` does not have an `onlyOwner` modifier, meaning that any user can call this function to transfer excess tokens from the contract to the `feeWallet`, even if they are not the owner. This can be exploited by malicious actors to drain excess tokens from the contract.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "_getTaxValues",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "vulnerability": "Incorrect Tax Calculation",
        "reason": "The calculation of `tmpTaxes` during a sell transaction is incorrect as it directly subtracts `_lpFee / feeDenominator` from `sellTax.marketingTax`, which can result in a negative value if `_lpFee` is larger than `sellTax.marketingTax * feeDenominator`. This can cause incorrect token tax values to be calculated, potentially leading to unintended behavior in tax distribution.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    }
]