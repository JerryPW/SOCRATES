[
    {
        "function_name": "owner_rescueExcessTokens",
        "code": "function owner_rescueExcessTokens() public{ uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens; require(balanceOf(address(this)) > pendingTaxTokens); uint excessTokens = balanceOf(address(this)) - pendingTaxTokens; _transfer(address(this), feeWallet, excessTokens); }",
        "vulnerability": "Anyone can call this function",
        "reason": "The function 'owner_rescueExcessTokens' is intended to transfer excess tokens from the contract to a designated fee wallet. However, this function lacks the 'onlyOwner' modifier, allowing any user to call it. This oversight enables malicious users to drain excess tokens from the contract to the feeWallet, effectively executing an unauthorized transfer.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "owner_updateSwapEnabled",
        "code": "function owner_updateSwapEnabled(bool _swapEnable) external { swapEnabled = false; }",
        "vulnerability": "Misleading Functionality",
        "reason": "The 'owner_updateSwapEnabled' function is designed to toggle the 'swapEnabled' state based on the provided boolean '_swapEnable'. However, the function body contains a hardcoded assignment, 'swapEnabled = false;', which disregards the input parameter '_swapEnable'. This oversight prevents the intended functionality of enabling swaps, leading to potential confusion and operational issues.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "_getTaxValues",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "vulnerability": "Incorrect Tax Calculation",
        "reason": "In the '_getTaxValues' function, the marketing tax for sell transactions is adjusted by subtracting '_lpFee / feeDenominator' from 'sellTax.marketingTax'. This calculation directly uses 'address(this).balance', which may not accurately represent the liquidity pool's balance or the context needed for tax adjustments. If the balance is high, it could result in negative taxes, leading to incorrect token deductions and potential manipulation of the contract's tax logic.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    }
]