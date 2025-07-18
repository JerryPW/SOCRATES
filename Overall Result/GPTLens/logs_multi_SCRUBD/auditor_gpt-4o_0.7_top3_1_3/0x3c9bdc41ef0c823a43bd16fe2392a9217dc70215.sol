[
    {
        "function_name": "stakeLiquidityTokens",
        "code": "function stakeLiquidityTokens(uint256 numPoolTokensToStake) external { require(numPoolTokensToStake > 0); require(stakingEnabled, \"Staking is currently disabled.\"); uint previousBalance = uniswapPair.balanceOf(address(this)); uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake); uint postBalance = uniswapPair.balanceOf(address(this)); require(previousBalance.add(numPoolTokensToStake) == postBalance); staker storage thisStaker = stakers[msg.sender]; if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) { thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; } else { uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance); assert(percent > 0); if(percent > 1) { percent = percent.div(2); } if(percent.add(thisStaker.startTimestamp) > block.timestamp) { thisStaker.startTimestamp = block.timestamp; } else { thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent); } } thisStaker.hasMigrated = true; thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake); }",
        "vulnerability": "Lack of allowance check",
        "reason": "The function uses `transferFrom` to transfer tokens from the user to the contract but does not check if the user has granted sufficient allowance to the contract for the transfer. If the allowance is not set properly, the transaction will revert, causing usability issues.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "emergencyWithdrawLiquidityTokens",
        "code": "function emergencyWithdrawLiquidityTokens() external { staker storage thisStaker = stakers[msg.sender]; uint poolTokenBalance = thisStaker.poolTokenBalance; thisStaker.poolTokenBalance = 0; thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; thisStaker.lockedRewardBalance = 0; thisStaker.hasMigrated = true; uniswapPair.transfer(msg.sender, poolTokenBalance); }",
        "vulnerability": "Lack of restrictions on emergency withdrawal",
        "reason": "The function allows users to withdraw all their liquidity tokens in an emergency without any checks or restrictions like minimum staking duration. This could be exploited to withdraw funds prematurely, bypassing any intended locking mechanisms.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "withdrawLiquidityTokens",
        "code": "function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external { require(numPoolTokensToWithdraw > 0); staker storage thisStaker = stakers[msg.sender]; require(thisStaker.hasMigrated, \"You must migrate\"); require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, \"Pool token balance too low\"); uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400; require(daysStaked >= minStakeDurationDays); uint tokensOwed = calculateTokensOwed(msg.sender); tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance); thisStaker.lockedRewardBalance = 0; thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw); thisStaker.startTimestamp = block.timestamp; thisStaker.lastTimestamp = block.timestamp; minter.liquidityRewards(msg.sender, tokensOwed); uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw); }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The function updates the staker's balance and timestamps after transferring tokens and rewards, which makes it vulnerable to reentrancy attacks. An attacker could exploit this by recursively calling the function to withdraw more than their actual balance.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    }
]