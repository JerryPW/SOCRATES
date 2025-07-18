[
    {
        "function_name": "swapTokensForETH",
        "vulnerability": "Lack of slippage control",
        "criticism": "The reasoning is correct. The function does not check for slippage, which could lead to significant losses due to unfavorable price changes. The severity is high because it could lead to significant financial losses. The profitability is moderate because while an external attacker cannot directly profit from this vulnerability, they could potentially exploit it indirectly through front-running.",
        "correctness": 9,
        "severity": 8,
        "profitability": 5,
        "reason": "The function `swapTokensForETH` carries out a token swap without checking for slippage. This could result in significant losses if the price changes unfavorably between transaction submission and confirmation. By setting the `amountOutMin` to 0, there is no guarantee on the minimum output of ETH, which could be exploited by front-running bots or lead to a poor exchange rate.",
        "code": "function swapTokensForETH(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = UniswapV2Router.WETH(); UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "_transfer",
        "vulnerability": "Potential bot marking",
        "criticism": "The reasoning is correct. The function could potentially mark legitimate users as bots, which could lead to them being blacklisted or restricted from trading. However, the severity and profitability of this vulnerability are low because it does not directly lead to financial losses and an external attacker cannot profit from it.",
        "correctness": 9,
        "severity": 3,
        "profitability": 0,
        "reason": "The `_transfer` function marks addresses as bots if they participate in transactions within a certain block window after liquidity is added. This could be exploited or lead to legitimate user addresses being incorrectly marked as bots, especially in the early stages of liquidity provision, causing those users to be blacklisted or restricted from trading.",
        "code": "function _transfer(address from, address to, uint256 amount) private { if (liqAddedBlockNumber == 0 && AutomatedMarketMakerPairs[to]) { liqAddedBlockNumber = block.number; } require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(!IsBot(from), \"ERC20: address blacklisted (bot)\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= balanceOf(from), \"You are trying to transfer more than your balance\"); bool takeFee = !(IsWalletExcludedFromFee(from) || IsWalletExcludedFromFee(to)); if (takeFee) { if (AutomatedMarketMakerPairs[from]) { if (block.number < liqAddedBlockNumber + blocksToWait) { MarkBot(to, true); } AppliedRatesPercentage = BuyingTaxes; require(amount <= HardCapBuy, \"amount must be <= maxTxAmountBuy\" ); } else { AppliedRatesPercentage = SellTaxes; require(amount <= HardCapSell,\"amount must be <= maxTxAmountSell\"); } } if ( !InSwap && !AutomatedMarketMakerPairs[from] && SwapEnabled && from != owner() && to != owner() && from != address(UniswapV2Router) ) { swapAndLiquify(); } _tokenTransfer(from, to, amount, takeFee); }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "SwapPct",
        "vulnerability": "Reentrancy risk",
        "criticism": "The reasoning is correct. The function transfers ETH to external addresses before resetting fee accumulations, which could potentially be exploited through reentrancy attacks. The severity is high because it could lead to significant financial losses. The profitability is high because an attacker could potentially drain funds from the contract.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The `SwapPct` function involves transferring ETH to external addresses (`DevAddress` and `MarketingAddress`) before resetting fee accumulations. This sequence can be exploited through reentrancy attacks, where an attacker could call back into the contract before state changes are finalized, potentially allowing them to manipulate the contract\u2019s state or drain funds.",
        "code": "function SwapPct(uint256 pct) public { uint256 balance = (balanceOf(address(this)) * pct) / 100; if(balance > 0) { uint256 tokensForLP = (balance * LPDistributionPct)/100; uint256 tokensForLiquidity = tokensForLP / 2; uint256 tokensToSwap = balance - tokensForLiquidity; swapTokensForETH(tokensToSwap); uint256 contractBalance = address(this).balance; uint256 devShare = (contractBalance * DevDistributionPct)/100; uint256 mktShare = (contractBalance * MarketingDistributionPct)/100; DevAddress.transfer(devShare); MarketingAddress.transfer(mktShare); uint256 eth = address(this).balance; UniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), tokensForLiquidity, 0, 0, DevAddress, block.timestamp ); AccumulatedFeeForDistribution.LiquidityFee = 0; AccumulatedFeeForDistribution.DevFee = 0; AccumulatedFeeForDistribution.MarketingFee = 0; TotalSwapped += tokensForLiquidity; emit LiquidityAdded(tokensForLiquidity, eth); } }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    }
]