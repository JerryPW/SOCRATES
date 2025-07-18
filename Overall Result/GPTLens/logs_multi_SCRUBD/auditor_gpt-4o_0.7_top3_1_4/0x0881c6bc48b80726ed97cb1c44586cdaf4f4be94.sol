[
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = UniswapV2Router.WETH(); UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The swapTokensForETH function calls an external contract (UniswapV2Router) to swap tokens for ETH, sending ETH to the contract itself. If this contract implements a fallback function that interacts with the state, a reentrancy attack could be initiated by an attacker to manipulate the contract state during the external call.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { if (liqAddedBlockNumber == 0 && AutomatedMarketMakerPairs[to]) { liqAddedBlockNumber = block.number; } require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(!IsBot(from), \"ERC20: address blacklisted (bot)\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= balanceOf(from), \"You are trying to transfer more than your balance\"); bool takeFee = !(IsWalletExcludedFromFee(from) || IsWalletExcludedFromFee(to)); if (takeFee) { if (AutomatedMarketMakerPairs[from]) { if (block.number < liqAddedBlockNumber + blocksToWait) { MarkBot(to, true); } AppliedRatesPercentage = BuyingTaxes; require(amount <= HardCapBuy, \"amount must be <= maxTxAmountBuy\" ); } else { AppliedRatesPercentage = SellTaxes; require(amount <= HardCapSell,\"amount must be <= maxTxAmountSell\"); } } if ( !InSwap && !AutomatedMarketMakerPairs[from] && SwapEnabled && from != owner() && to != owner() && from != address(UniswapV2Router) ) { swapAndLiquify(); } _tokenTransfer(from, to, amount, takeFee); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The _transfer function includes a mechanism to blacklist addresses by marking them as bots. This could potentially be misused by the contract owner or an attacker who gains access to the owner's private key, resulting in a denial of service for legitimate users who are incorrectly marked as bots.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "SwapPct",
        "code": "function SwapPct(uint256 pct) public { uint256 balance = (balanceOf(address(this)) * pct) / 100; if(balance > 0) { uint256 tokensForLP = (balance * LPDistributionPct)/100; uint256 tokensForLiquidity = tokensForLP / 2; uint256 tokensToSwap = balance - tokensForLiquidity; swapTokensForETH(tokensToSwap); uint256 contractBalance = address(this).balance; uint256 devShare = (contractBalance * DevDistributionPct)/100; uint256 mktShare = (contractBalance * MarketingDistributionPct)/100; DevAddress.transfer(devShare); MarketingAddress.transfer(mktShare); uint256 eth = address(this).balance; UniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), tokensForLiquidity, 0, 0, DevAddress, block.timestamp ); AccumulatedFeeForDistribution.LiquidityFee = 0; AccumulatedFeeForDistribution.DevFee = 0; AccumulatedFeeForDistribution.MarketingFee = 0; TotalSwapped += tokensForLiquidity; emit LiquidityAdded(tokensForLiquidity, eth); } }",
        "vulnerability": "Arbitrary Token Swap",
        "reason": "The SwapPct function allows any user to trigger token swaps and liquidity additions by specifying a percentage of the contract's balance. If misconfigured or called with unfavorable timing, this could lead to unexpected or excessive swapping, potentially leading to economic loss or manipulation of token price.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    }
]