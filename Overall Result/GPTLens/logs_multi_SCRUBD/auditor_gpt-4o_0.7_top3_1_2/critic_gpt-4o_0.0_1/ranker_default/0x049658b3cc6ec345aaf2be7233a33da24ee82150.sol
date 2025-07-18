[
    {
        "function_name": "manualBurnTokensFromLP",
        "vulnerability": "Potential misuse of token burning",
        "criticism": "The reasoning is correct in identifying that the function allows the owner to burn tokens from the liquidity pool, which could be used to manipulate the market by reducing liquidity. The imposed limit does mitigate the risk to some extent, but the potential for market manipulation remains. The severity is moderate because it can impact token price and availability significantly. The profitability is moderate as well, as it could be used to influence market conditions for personal gain.",
        "correctness": 8,
        "severity": 6,
        "profitability": 5,
        "reason": "The function allows the owner to burn tokens from the liquidity pool. While there is a limit imposed, this function could still be used to manipulate the market by reducing liquidity significantly, impacting token price and availability.",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol",
        "final_score": 6.75
    },
    {
        "function_name": "internalTransfer",
        "vulnerability": "Block-based sniper detection",
        "criticism": "The reasoning is correct in identifying that using `block.number` for sniper detection can be manipulated by miners. Miners can potentially reorder transactions within a block or manipulate the block number to bypass the detection mechanism. This could indeed lead to unfair trading conditions. However, the severity is moderate because it requires miner collusion, which is not trivial. The profitability is also moderate, as it could allow malicious actors to avoid penalties, but it requires specific conditions to be met.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The use of `block.number` for sniper detection can be manipulated by miners, allowing them to bypass the detection mechanism. This could lead to unfair trading conditions and allow malicious actors to avoid penalties.",
        "code": "function internalTransfer(address from, address to, uint256 amount) internal { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"ERC20: Transfer amount must be greater than zero\"); require(!isBot[from], \"ERC20: Can not transfer from BOT\"); if(!live){ require(isTaxExcluded[from] || isTaxExcluded[to], \"ERC20: Trading Is Not Live!\"); } if (maxWalletOn == true && ! isMaxWalletExcluded[to]) { require(balanceOf(to).add(amount) <= maxWallet, \"ERC20: Max amount of tokens for wallet reached\"); } if(limitsOn){ if (from != owner() && to != owner() && to != address(0) && to != dead && to != uniV2Pair) { for (uint x = 0; x < 2; x++) { if(block.number == activeTradingBlock.add(x)) { isSniper[to] = true; }}}} if(contractBlocker) { require( !isContract(to) && isContractsExcluded[from] || !isContract(from) && isContractsExcluded[to] || isContract(from) && isContractsExcluded[to] || isContract(to) && isContractsExcluded[from] );} uint256 totalTokensToSwap = liquidityTokens.add(marketingTokens); uint256 contractTokenBalance = balanceOf(address(this)); bool overMinimumTokenBalance = contractTokenBalance >= minTaxSwap; if (!inSwapAndLiquify && swapAndLiquifyStatus && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !isTaxExcluded[to] && !isTaxExcluded[from] && to == uniV2Pair && overMinimumTokenBalance) { taxTokenSwap(); } if (isTaxExcluded[from] || isTaxExcluded[to]) { marketingTax = 0; liquidityTax = 0; divForSplitTax = marketingTax.add(liquidityTax); } else { if (from == uniV2Pair) { marketingTax = taxBuyMarketing; liquidityTax = taxBuyLiquidity; divForSplitTax = taxBuyMarketing.add(taxBuyLiquidity); }else if (to == uniV2Pair) { marketingTax = taxSellMarketing; liquidityTax = taxSellLiquidity; divForSplitTax = taxSellMarketing.add(taxSellLiquidity); if(isSniper[from] && sniperPenaltyEnd >= block.timestamp){ marketingTax = 85; liquidityTax = 10; divForSplitTax = marketingTax.add(liquidityTax); } }else { require(!isSniper[from] || sniperPenaltyEnd <= block.timestamp, \"ERC20: Snipers can not transfer till penalty time is over\"); marketingTax = 0; liquidityTax = 0; }} tokenTransfer(from, to, amount); }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol",
        "final_score": 6.5
    },
    {
        "function_name": "GoLive",
        "vulnerability": "Liquidity addition with contract balance",
        "criticism": "The reasoning is partially correct. Requiring the contract to have ETH before going live does introduce a dependency on external funding, which could be a risk if not managed correctly. However, the risk of accidental locks of ETH is overstated, as the function does not inherently lock ETH but rather uses it for liquidity. The severity is low because the risk is more about operational management rather than a technical vulnerability. The profitability is low because it does not provide a direct avenue for exploitation.",
        "correctness": 6,
        "severity": 3,
        "profitability": 2,
        "reason": "Requiring the contract to have ETH before going live could lead to accidental locks of ETH if funds are not properly managed. It also introduces a dependency on external funding, which could be a risk if the owner does not manage funds correctly.",
        "code": "function GoLive() external onlyOwner returns (bool){ require(!live, \"ERC20: Trades already Live!\"); activeTradingBlock = block.number; sniperPenaltyEnd = block.timestamp.add(5 days); IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniV2Router = _uniV2Router; uniV3Router = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45; isContractsExcluded[address(uniV2Router)] = true; isContractsExcluded[address(uniV3Router)] = true; isMaxWalletExcluded[address(uniV2Router)] = true; internalApprove(address(this), address(uniV2Router), tokenSupply); uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH()); isContractsExcluded[address(uniV2Pair)] = true; isMaxWalletExcluded[address(uniV2Pair)] = true; require(address(this).balance > 0, \"ERC20: Must have ETH on contract to Go Live!\"); addLiquidity(balanceOf(address(this)), address(this).balance); launchSetLiquidityAddress(dead); maxWalletOn = true; swapAndLiquifyStatus = true; limitsOn = true; live = true; return true; }",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol",
        "final_score": 4.25
    }
]