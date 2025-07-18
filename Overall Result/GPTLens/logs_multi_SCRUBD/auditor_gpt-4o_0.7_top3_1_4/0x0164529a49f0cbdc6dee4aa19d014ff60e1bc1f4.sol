[
    {
        "function_name": "burnTokensFromLiquidityPool",
        "code": "function burnTokensFromLiquidityPool() private lockTheSwap { uint liquidity = balanceOf(marketPair); uint tokenBurnAmount = liquidity.div(burnRateInBasePoints); if(tokenBurnAmount > 0) { _burn(marketPair, tokenBurnAmount); v2Pair.sync(); tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount); nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60)); emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp); } }",
        "vulnerability": "Potential Manipulation of Liquidity Pool",
        "reason": "The function `burnTokensFromLiquidityPool` burns tokens from the liquidity pool directly, which can cause an imbalance and lead to slippage or price manipulation. The burning process does not consider the pool's impact on price stability, potentially allowing attackers to exploit this by predicting price movements after a burn, leading to financial losses for traders.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); _approve(address(this), address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); uint256 ethBalance = address(this).balance; uint256 halfShare = ethBalance.div(2); payable(feeOne).transfer(halfShare); payable(feeTwo).transfer(halfShare); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function `swapTokensForEth` performs a token swap and then transfers ETH to two addresses without using a reentrancy guard. This makes it vulnerable to reentrancy attacks where an attacker could call back into the contract before state updates are finalized, potentially draining the contract's ETH balance.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "blockUnblockAddress",
        "code": "function blockUnblockAddress(address[] memory addresses, bool doBlock) private { for (uint256 i = 0; i < addresses.length; i++) { address addr = addresses[i]; if(doBlock) { botWallets[addr] = true; } else { delete botWallets[addr]; } } }",
        "vulnerability": "Arbitrary Blocking",
        "reason": "The function `blockUnblockAddress` allows the owner to arbitrarily block or unblock addresses. This centralized control can be exploited by the owner to unfairly restrict certain addresses from trading, leading to potential censorship and loss of funds for affected users.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    }
]