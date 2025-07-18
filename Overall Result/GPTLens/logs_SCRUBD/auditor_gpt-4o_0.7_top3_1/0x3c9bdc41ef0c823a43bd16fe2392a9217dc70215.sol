[
    {
        "function_name": "withdrawLiquidityTokens",
        "code": "function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external { require(numPoolTokensToWithdraw > 0); staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated, \"You must migrate\"); require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, \"Pool token balance too low\"); uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400; require(daysStaked >= minStakeDurationDays); uint tokensOwed = calculateTokensOwed(msg.sender); tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance); thisStaker.lockedRewardBalance = 0; thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw); thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(msg.sender, tokensOwed); uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows for the external call to `minter.liquidityRewards` before updating the staker's balance. If the external call is malicious, it can re-enter and call `withdrawLiquidityTokens` again, potentially causing the contract to pay out more than intended.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "emergencyWithdrawLiquidityTokens",
        "code": "function emergencyWithdrawLiquidityTokens() external { staker storage thisStaker = stakers[msg.sender]; uint poolTokenBalance = thisStaker.poolTokenBalance; thisStaker.poolTokenBalance = 0; thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; thisStaker.lockedRewardBalance = 0; thisStaker.hasMigrated = true; uniswapPair.transfer(msg.sender, poolTokenBalance); }",
        "vulnerability": "Unprotected emergency withdrawal",
        "reason": "The function does not check for the staking duration or any other conditions before allowing users to withdraw their entire pool token balance. This can be exploited by users to circumvent the minimum staking duration requirement and withdraw without penalty.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "reinvestRewards",
        "code": "function reinvestRewards(bool locked, uint _numTokensToReinvest) external payable { staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated); if(locked) { thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.sub(_numTokensToReinvest); minter.liquidityRewards(address(this), _numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } else { uint numTokensToReinvest = calculateTokensOwed(msg.sender); thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(address(this), numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value:msg.value}(address(pampToken), numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } }",
        "vulnerability": "Locked rewards manipulation",
        "reason": "The function allows users to specify a number of tokens to reinvest from their locked rewards without sufficient checks. Attackers can specify a higher amount than available, potentially leading to underflow or incorrect token handling.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    }
]