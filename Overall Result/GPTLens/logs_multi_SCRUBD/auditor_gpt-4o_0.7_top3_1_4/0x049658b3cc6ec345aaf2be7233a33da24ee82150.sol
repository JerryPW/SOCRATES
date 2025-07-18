[
    {
        "function_name": "internalTransfer",
        "code": "function internalTransfer(address from, address to, uint256 amount) internal { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"ERC20: Transfer amount must be greater than zero\"); require(!isBot[from], \"ERC20: Can not transfer from BOT\"); if(!live){ require(isTaxExcluded[from] || isTaxExcluded[to], \"ERC20: Trading Is Not Live!\"); } if (maxWalletOn == true && ! isMaxWalletExcluded[to]) { require(balanceOf(to).add(amount) <= maxWallet, \"ERC20: Max amount of tokens for wallet reached\"); } if(limitsOn){ if (from != owner() && to != owner() && to != address(0) && to != dead && to != uniV2Pair) { for (uint x = 0; x < 2; x++) { if(block.number == activeTradingBlock.add(x)) { isSniper[to] = true; }}}} if(contractBlocker) { require( !isContract(to) && isContractsExcluded[from] || !isContract(from) && isContractsExcluded[to] || isContract(from) && isContractsExcluded[to] || isContract(to) && isContractsExcluded[from] );} uint256 totalTokensToSwap = liquidityTokens.add(marketingTokens); uint256 contractTokenBalance = balanceOf(address(this)); bool overMinimumTokenBalance = contractTokenBalance >= minTaxSwap; if (!inSwapAndLiquify && swapAndLiquifyStatus && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !isTaxExcluded[to] && !isTaxExcluded[from] && to == uniV2Pair && overMinimumTokenBalance) { taxTokenSwap(); } if (isTaxExcluded[from] || isTaxExcluded[to]) { marketingTax = 0; liquidityTax = 0; divForSplitTax = marketingTax.add(liquidityTax); } else { if (from == uniV2Pair) { marketingTax = taxBuyMarketing; liquidityTax = taxBuyLiquidity; divForSplitTax = taxBuyMarketing.add(taxBuyLiquidity); }else if (to == uniV2Pair) { marketingTax = taxSellMarketing; liquidityTax = taxSellLiquidity; divForSplitTax = taxSellMarketing.add(taxSellLiquidity); if(isSniper[from] && sniperPenaltyEnd >= block.timestamp){ marketingTax = 85; liquidityTax = 10; divForSplitTax = marketingTax.add(liquidityTax); } }else { require(!isSniper[from] || sniperPenaltyEnd <= block.timestamp, \"ERC20: Snipers can not transfer till penalty time is over\"); marketingTax = 0; liquidityTax = 0; }} tokenTransfer(from, to, amount); }",
        "vulnerability": "DOS by block stuffing",
        "reason": "The function marks an address as a sniper based on the block number during trading launch. An attacker could potentially manipulate block numbers to mark legitimate users as snipers unfairly, causing denial of service for them.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { bool success; (success,) = address(owner()).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Unrestricted withdrawal",
        "reason": "The function allows the contract owner to withdraw all ETH from the contract without any restrictions or checks. This centralization of control poses a risk if the owner account is compromised.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Potential manipulation of market price",
        "reason": "The function allows burning of a significant portion of tokens from the liquidity pool, which can be used to manipulate the token's market price by reducing the available supply in the pool. Although limited to 10% per call, repeated calls can have substantial impacts.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    }
]