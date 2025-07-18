[
    {
        "function_name": "SwapPct",
        "vulnerability": "Potential Reentrancy",
        "criticism": "The reasoning correctly identifies a potential reentrancy risk due to the transfer of ETH to external addresses before calling the addLiquidityETH function. If the DevAddress or MarketingAddress is controlled by an attacker, they could exploit this to perform a reentrancy attack. However, the severity is moderate because it requires control over specific addresses, and the profitability is also moderate as it depends on the amount of ETH in the contract.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The SwapPct function transfers ETH to external addresses before re-entering into the UniswapV2Router's addLiquidityETH function. If an attacker controls the DevAddress or MarketingAddress, they could potentially perform a reentrancy attack by executing code upon receiving the ETH transfer. This could lead to undesired behavior such as draining the contract balance.",
        "code": "function SwapPct(uint256 pct) public { uint256 balance = (balanceOf(address(this)) * pct) / 100; if(balance > 0) { uint256 tokensForLP = (balance * LPDistributionPct)/100; uint256 tokensForLiquidity = tokensForLP / 2; uint256 tokensToSwap = balance - tokensForLiquidity; swapTokensForETH(tokensToSwap); uint256 contractBalance = address(this).balance; uint256 devShare = (contractBalance * DevDistributionPct)/100; uint256 mktShare = (contractBalance * MarketingDistributionPct)/100; DevAddress.transfer(devShare); MarketingAddress.transfer(mktShare); uint256 eth = address(this).balance; UniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), tokensForLiquidity, 0, 0, DevAddress, block.timestamp ); AccumulatedFeeForDistribution.LiquidityFee = 0; AccumulatedFeeForDistribution.DevFee = 0; AccumulatedFeeForDistribution.MarketingFee = 0; TotalSwapped += tokensForLiquidity; emit LiquidityAdded(tokensForLiquidity, eth); } }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol",
        "final_score": 6.5
    },
    {
        "function_name": "swapAndLiquify",
        "vulnerability": "Reentrancy Risk",
        "criticism": "The reasoning correctly identifies a reentrancy risk similar to the SwapPct function. The function transfers ETH to external addresses before calling addLiquidityETH, which could be exploited if the addresses are compromised. The severity is moderate due to the specific conditions required for exploitation, and the profitability is moderate as it depends on the contract's ETH balance.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "Similar to the SwapPct function, the swapAndLiquify function transfers ETH to two external addresses (DevAddress and MarketingAddress) before executing the addLiquidityETH function. If the DevAddress or MarketingAddress is compromised, or if the external address is able to execute code on receiving ETH, it could lead to a reentrancy attack, potentially draining the contract's ETH balance.",
        "code": "function swapAndLiquify() private swaping { if(balanceOf(address(this)) > 0) { uint256 tokensToSwap = AccumulatedFeeForDistribution.LiquidityFee / 2; uint256 tokensForLiquidity = AccumulatedFeeForDistribution.LiquidityFee - tokensToSwap; swapTokensForETH(AccumulatedFeeForDistribution.DevFee + AccumulatedFeeForDistribution.MarketingFee + tokensToSwap); uint256 contractBalance = address(this).balance; uint256 devShare = (contractBalance* DevDistributionPct)/100; uint256 mktShare = (contractBalance * MarketingDistributionPct)/100; DevAddress.transfer(devShare); MarketingAddress.transfer(mktShare); uint256 eth = address(this).balance; UniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), tokensForLiquidity, 0, 0, DevAddress, block.timestamp ); AccumulatedFeeForDistribution.LiquidityFee = 0; AccumulatedFeeForDistribution.DevFee = 0; AccumulatedFeeForDistribution.MarketingFee = 0; TotalSwapped += tokensForLiquidity; emit LiquidityAdded(tokensForLiquidity, eth); } }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol",
        "final_score": 6.5
    },
    {
        "function_name": "_transfer",
        "vulnerability": "Potential DoS via Bot Marking",
        "criticism": "The reasoning is correct in identifying a potential Denial of Service (DoS) vulnerability. The function marks addresses as bots if transactions occur within a certain number of blocks after liquidity is added. This could be exploited by an attacker to mark legitimate users as bots, preventing them from transferring tokens. The severity is moderate as it affects user experience, and the profitability is low since it doesn't directly benefit the attacker financially.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The _transfer function marks an address as a bot if a transaction occurs within a specific number of blocks after liquidity is added. An attacker could potentially exploit this by front-running the liquidity addition, causing legitimate users to be marked as bots and preventing them from participating in token transfers. This can lead to a Denial of Service (DoS) attack on legitimate users.",
        "code": "function _transfer(address from, address to, uint256 amount) private { if (liqAddedBlockNumber == 0 && AutomatedMarketMakerPairs[to]) { liqAddedBlockNumber = block.number; } require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(!IsBot(from), \"ERC20: address blacklisted (bot)\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= balanceOf(from), \"You are trying to transfer more than your balance\"); bool takeFee = !(IsWalletExcludedFromFee(from) || IsWalletExcludedFromFee(to)); if (takeFee) { if (AutomatedMarketMakerPairs[from]) { if (block.number < liqAddedBlockNumber + blocksToWait) { MarkBot(to, true); } AppliedRatesPercentage = BuyingTaxes; require(amount <= HardCapBuy, \"amount must be <= maxTxAmountBuy\" ); } else { AppliedRatesPercentage = SellTaxes; require(amount <= HardCapSell,\"amount must be <= maxTxAmountSell\"); } } if ( !InSwap && !AutomatedMarketMakerPairs[from] && SwapEnabled && from != owner() && to != owner() && from != address(UniswapV2Router) ) { swapAndLiquify(); } _tokenTransfer(from, to, amount, takeFee); }",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol",
        "final_score": 5.75
    }
]