[
    {
        "function_name": "emergencyWithdrawLiquidityTokens",
        "code": "function emergencyWithdrawLiquidityTokens() external { staker storage thisStaker = stakers[msg.sender]; uint poolTokenBalance = thisStaker.poolTokenBalance; thisStaker.poolTokenBalance = 0; thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; thisStaker.lockedRewardBalance = 0; thisStaker.hasMigrated = true; uniswapPair.transfer(msg.sender, poolTokenBalance); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The emergencyWithdrawLiquidityTokens function allows any staker to withdraw their entire pool token balance without any restrictions or additional checks. This could be exploited by stakers to withdraw staked tokens prematurely, bypassing any intended locking or staking periods.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "reinvestRewards",
        "code": "function reinvestRewards(bool locked, uint _numTokensToReinvest) external payable { staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated); if(locked) { thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.sub(_numTokensToReinvest); minter.liquidityRewards(address(this), _numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } else { uint numTokensToReinvest = calculateTokensOwed(msg.sender); thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(address(this), numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value:msg.value}(address(pampToken), numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } }",
        "vulnerability": "Incorrect Calculation and Use of Rewards",
        "reason": "The reinvestRewards function, when called with the locked parameter as false, calculates the number of tokens to reinvest using calculateTokensOwed without checking if this amount can be safely added as liquidity. This can lead to incorrect states and potential loss of funds if the calculated rewards do not correspond to valid liquidity additions.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "transferEth",
        "code": "function transferEth(uint _eth) external onlyOwner { msg.sender.transfer(_eth); }",
        "vulnerability": "Potential for Ether Loss",
        "reason": "The transferEth function allows the contract owner to transfer arbitrary amounts of Ether from the contract to themselves. This is a centralization risk, where the owner can drain Ether from the contract, potentially affecting other users reliant on the contract's balance for operations.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    }
]