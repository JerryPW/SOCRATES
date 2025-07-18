[
    {
        "function_name": "owner_updateSwapEnabled",
        "code": "function owner_updateSwapEnabled(bool _swapEnable) external { swapEnabled = false; }",
        "vulnerability": "Irreversible swap disable",
        "reason": "The function `owner_updateSwapEnabled` is supposed to update the `swapEnabled` state variable based on the input `_swapEnable`. However, it is hardcoded to always set `swapEnabled` to `false`, rendering the function useless for enabling swaps once disabled. This could be exploited by the owner to permanently disable swaps, potentially harming liquidity and affecting token holders.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from,address to,uint256 amount) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= maxTransAmount || _isExcludedFromMaxBalance[from], \"Transfer amount exceeds the _maxTxAmount.\"); if(!_isExcludedFromMaxBalance[to]) require(balanceOf(to) + amount <= maxWalletSize, \"Transfer amount exceeds the maxWallet.\"); if (balanceOf(address(this)) >= swapLimit && swapEnabled && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner() ) swapAndLiquify(); uint256 tmp = amount; if(shouldExclude(from, to)) {amount = amount * buyTax.lpTax;} _tOwned[from] -= amount; amount = tmp; uint256 transferAmount = amount; if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){ transferAmount = _getTaxValues(amount, from, to == pair); } _tOwned[to] += transferAmount; emit Transfer(from, to, transferAmount); }",
        "vulnerability": "Incorrect tax deduction logic",
        "reason": "The function `_transfer` contains a bug in the tax deduction logic. The line `if(shouldExclude(from, to)) {amount = amount * buyTax.lpTax;}` incorrectly attempts to modify the `amount` based on `buyTax.lpTax`, which is not a valid operation since it doesn't deduct a percentage but rather scales the amount incorrectly. This logic error can lead to unexpected behavior during transfers and could be exploited to manipulate token amounts.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    },
    {
        "function_name": "_getTaxValues",
        "code": "function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){ Tax memory tmpTaxes = buyTax; uint256 _lpFee = address(this).balance; if (isSell){ tmpTaxes = Tax(sellTax.marketingTax - (_lpFee / feeDenominator), sellTax.lpTax); } uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100; uint tokensForLP = amount * tmpTaxes.lpTax / 100; if(tokensForMarketing > 0) totalTokensFromTax.marketingTokens += tokensForMarketing; if(tokensForLP > 0) totalTokensFromTax.lpTokens += tokensForLP; uint totalTaxedTokens = tokensForMarketing + tokensForLP; _tOwned[address(this)] += totalTaxedTokens; if(totalTaxedTokens > 0) emit Transfer (from, address(this), totalTaxedTokens); return (amount - totalTaxedTokens); }",
        "vulnerability": "Dynamic tax manipulation via balance",
        "reason": "In the function `_getTaxValues`, when calculating sell taxes, the marketing tax is adjusted by subtracting `(_lpFee / feeDenominator)`, which is dependent on the contract's ETH balance. This introduces a vulnerability where an attacker could manipulate the contract's balance (by sending ETH to it) to reduce or eliminate the marketing tax on sell transactions, potentially bypassing intended fee mechanisms and gaining unfair advantage.",
        "file_name": "0x03766932d07fad2ea2e60454ccbbb5d88780b63e.sol"
    }
]