[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `beneficiary.send(amountRaised)` can lead to a reentrancy attack. An attacker could create a fallback function that would call `safeWithdrawal` again before `balanceOf[buyerId]` is reset to zero, allowing them to withdraw multiple times.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Potential integer overflow",
        "reason": "The calculation `((balanceOf[buyerId] * 500) * 125) / 100` could lead to an integer overflow, especially if `balanceOf[buyerId]` is large. This can result in incorrect token amounts being transferred.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (beneficiary == msg.sender) { if (amountRaised >= fundingGoal){ fundingGoalReached = true; emit GoalReached(beneficiary, amountRaised); } crowdsaleClosed = true; } }",
        "vulnerability": "Incorrect access control",
        "reason": "The `checkGoalReached` function can only be called by the beneficiary, which may lead to a scenario where the goal is reached, but the beneficiary does not call this function, thereby preventing the closing of the crowdsale. This can leave the contract in a persistent state where funds are locked.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    }
]