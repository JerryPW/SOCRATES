[
    {
        "function_name": "internalTransfer",
        "vulnerability": "Denial of Service through Blacklisting",
        "criticism": "The reasoning is correct in identifying that the function allows marking addresses as 'snipers' or 'bots', which can prevent them from transferring tokens. This can indeed lead to a denial of service for those users if misused by an attacker with ownership privileges. The severity is moderate because it can disrupt user experience and token transferability. The profitability is low because it does not directly benefit an attacker financially, but it can be used to harm specific users.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The function allows marking specific addresses as 'snipers' or 'bots', preventing them from transferring tokens. An attacker with ownership privileges can misuse this functionality to blacklist legitimate addresses, leading to a denial of service for those users.",
        "code": "function internalTransfer(address from, address to, uint256 amount) internal { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"ERC20: Transfer amount must be greater than zero\"); require(!isBot[from], \"ERC20: Can not transfer from BOT\"); if(!live){ require(isTaxExcluded[from] || isTaxExcluded[to], \"ERC20: Trading Is Not Live!\"); } if (maxWalletOn == true && ! isMaxWalletExcluded[to]) { require(balanceOf(to).add(amount) <= maxWallet, \"ERC20: Max amount of tokens for wallet reached\"); } if(limitsOn){ if (from != owner() && to != owner() && to != address(0) && to != dead && to != uniV2Pair) { for (uint x = 0; x < 2; x++) { if(block.number == activeTradingBlock.add(x)) { isSniper[to] = true; }}}} if(contractBlocker) { require( !isContract(to) && isContractsExcluded[from] || !isContract(from) && isContractsExcluded[to] || isContract(from) && isContractsExcluded[to] || isContract(to) && isContractsExcluded[from] );} uint256 totalTokensToSwap = liquidityTokens.add(marketingTokens); uint256 contractTokenBalance = balanceOf(address(this)); bool overMinimumTokenBalance = contractTokenBalance >= minTaxSwap; if (!inSwapAndLiquify && swapAndLiquifyStatus && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !isTaxExcluded[to] && !isTaxExcluded[from] && to == uniV2Pair && overMinimumTokenBalance) { taxTokenSwap(); } if (isTaxExcluded[from] || isTaxExcluded[to]) { marketingTax = 0; liquidityTax = 0; divForSplitTax = marketingTax.add(liquidityTax); } else { if (from == uniV2Pair) { marketingTax = taxBuyMarketing; liquidityTax = taxBuyLiquidity; divForSplitTax = taxBuyMarketing.add(taxBuyLiquidity); }else if (to == uniV2Pair) { marketingTax = taxSellMarketing; liquidityTax = taxSellLiquidity; divForSplitTax = taxSellMarketing.add(taxSellLiquidity); if(isSniper[from] && sniperPenaltyEnd >= block.timestamp){ marketingTax = 85; liquidityTax = 10; divForSplitTax = marketingTax.add(liquidityTax); } }else { require(!isSniper[from] || sniperPenaltyEnd <= block.timestamp, \"ERC20: Snipers can not transfer till penalty time is over\"); marketingTax = 0; liquidityTax = 0; }} tokenTransfer(from, to, amount); }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "vulnerability": "Potential Liquidity Disruption",
        "criticism": "The reasoning is correct in identifying that the function allows the owner to burn up to 10% of the liquidity pool, which can disrupt the token's liquidity and cause price fluctuations. This is a significant risk if an attacker gains control over the contract. The severity is high because it can affect the entire market for the token. The profitability is moderate because an attacker could potentially manipulate the market for financial gain.",
        "correctness": 9,
        "severity": 7,
        "profitability": 5,
        "reason": "The function allows the owner to burn up to 10% of the liquidity pool. This action can significantly disrupt the liquidity of the token in the market, affecting trading and potentially leading to drastic price fluctuations. An attacker who gains control over the contract could manipulate the liquidity to cause harm to the market.",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "withdrawStuckTokens",
        "vulnerability": "Potential Fund Drain by Owner",
        "criticism": "The reasoning is correct in identifying that the function allows the owner to withdraw any percentage of tokens from the contract, which can lead to a complete drain of funds if misused. This is a severe risk if the owner's account is compromised. The severity is very high because it can lead to a total loss of funds for token holders. The profitability is also high because an attacker could drain all tokens for financial gain.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "This function allows the owner to withdraw a specified percentage of tokens from the contract. There is no cap on the percentage, allowing the owner to drain all tokens from the contract. This is a significant risk if the owner's account is compromised or maliciously controlled, leading to a complete loss of funds for the token holders.",
        "code": "function withdrawStuckTokens(uint256 percent) external onlyOwner { internalTransfer(address(this), owner(), tokenSupply*percent/100); }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    }
]