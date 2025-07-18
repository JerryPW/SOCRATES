[
    {
        "function_name": "withdrawLiquidityTokens",
        "code": "function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external { require(numPoolTokensToWithdraw > 0); staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated, \"You must migrate\"); require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, \"Pool token balance too low\"); uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400; require(daysStaked >= minStakeDurationDays); uint tokensOwed = calculateTokensOwed(msg.sender); tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance); thisStaker.lockedRewardBalance = 0; thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw); thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(msg.sender, tokensOwed); uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function transfers uniswapPair tokens to the caller before updating the caller's staker state variables. This allows for a reentrancy attack, where a malicious actor can call withdrawLiquidityTokens() recursively before the state is updated, potentially withdrawing more than their due balance.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "emergencyWithdrawLiquidityTokens",
        "code": "function emergencyWithdrawLiquidityTokens() external { staker storage thisStaker = stakers[msg.sender]; uint poolTokenBalance = thisStaker.poolTokenBalance; thisStaker.poolTokenBalance = 0; thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; thisStaker.lockedRewardBalance = 0; thisStaker.hasMigrated = true; uniswapPair.transfer(msg.sender, poolTokenBalance); }",
        "vulnerability": "Emergency Withdraw without Conditions",
        "reason": "This function allows users to withdraw all their liquidity tokens without any checks or conditions. There should be mechanisms to ensure that only eligible users can perform an emergency withdrawal, otherwise, users can exploit this to bypass staking terms and conditions.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "reinvestRewards",
        "code": "function reinvestRewards(bool locked, uint _numTokensToReinvest) external payable { staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated); if(locked) { thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.sub(_numTokensToReinvest); minter.liquidityRewards(address(this), _numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } else { uint numTokensToReinvest = calculateTokensOwed(msg.sender); thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(address(this), numTokensToReinvest); (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value:msg.value}(address(pampToken), numTokensToReinvest, 0, 0, address(this), now+86400); thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity); } }",
        "vulnerability": "Incorrect Reward Handling",
        "reason": "The function does not verify if the msg.sender has sufficient locked rewards or calculated tokens owed before proceeding with reinvestment. An attacker could manipulate their rewards or bypass checks, leading to inaccurate reward distribution or reinvestment of non-owned tokens.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    }
]