[
    {
        "function_name": "emergencyWithdrawLiquidityTokens",
        "code": "function emergencyWithdrawLiquidityTokens() external {\n    staker storage thisStaker = stakers[msg.sender];\n    uint poolTokenBalance = thisStaker.poolTokenBalance;\n    thisStaker.poolTokenBalance = 0;\n    thisStaker.startTimestamp = block.timestamp;\n    thisStaker.lastTimestamp = block.timestamp;\n    thisStaker.lockedRewardBalance = 0;\n    thisStaker.hasMigrated = true;\n    uniswapPair.transfer(msg.sender, poolTokenBalance);\n}",
        "vulnerability": "Lack of minimum stake duration check",
        "reason": "The function allows a staker to withdraw their entire pool token balance without checking if they have met the minimum stake duration. This can be exploited by attackers to stake and immediately withdraw liquidity tokens without adhering to the required duration, defeating the purpose of the staking mechanism.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "withdrawLiquidityTokens",
        "code": "function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {\n    require(numPoolTokensToWithdraw > 0);\n    staker storage thisStaker = stakers[msg.sender];\n    require(thisStaker.hasMigrated, \"You must migrate\");\n    require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, \"Pool token balance too low\");\n    uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;\n    require(daysStaked >= minStakeDurationDays);\n    uint tokensOwed = calculateTokensOwed(msg.sender);\n    tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance);\n    thisStaker.lockedRewardBalance = 0;\n    thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);\n    thisStaker.startTimestamp = block.timestamp;\n    thisStaker.lastTimestamp = block.timestamp;\n    minter.liquidityRewards(msg.sender, tokensOwed);\n    uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);\n}",
        "vulnerability": "Rewards calculation manipulation",
        "reason": "An attacker can repeatedly withdraw small amounts of liquidity tokens to frequently reset the `startTimestamp` and `lastTimestamp`, potentially leading to manipulation of rewards calculation and claiming disproportionately high rewards over time.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    },
    {
        "function_name": "reinvestRewards",
        "code": "function reinvestRewards(bool locked, uint _numTokensToReinvest) external payable {\n    staker storage thisStaker = stakers[msg.sender];\n    require(thisStaker.hasMigrated);\n    if(locked) {\n        thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.sub(_numTokensToReinvest);\n        minter.liquidityRewards(address(this), _numTokensToReinvest);\n        (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToReinvest, 0, 0, address(this), now+86400);\n        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);\n    } else {\n        uint numTokensToReinvest = calculateTokensOwed(msg.sender);\n        thisStaker.lastTimestamp = block.timestamp;\n        minter.liquidityRewards(address(this), numTokensToReinvest);\n        (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value:msg.value}(address(pampToken), numTokensToReinvest, 0, 0, address(this), now+86400);\n        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);\n    }\n}",
        "vulnerability": "Locked rewards underflow",
        "reason": "The function does not check if `_numTokensToReinvest` is less than or equal to `lockedRewardBalance` when `locked` is true, potentially causing an underflow when subtracting from `lockedRewardBalance`, which could lead to incorrect state and potential exploitation.",
        "file_name": "0x3c9bdc41ef0c823a43bd16fe2392a9217dc70215.sol"
    }
]