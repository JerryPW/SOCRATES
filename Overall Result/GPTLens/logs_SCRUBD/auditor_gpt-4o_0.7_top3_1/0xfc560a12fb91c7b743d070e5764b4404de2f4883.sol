[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' to transfer Ether to the beneficiary. If the beneficiary is a contract, it could reenter the 'safeWithdrawal' function before the state changes are finalized, potentially allowing repeated withdrawals. This can lead to the draining of all funds from the contract.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Inadequate token distribution logic",
        "reason": "The function calculates token distribution based on a fixed formula that doesn't consider the actual amount of tokens available or the actual contribution made by each buyer. This can result in either under-distribution or over-distribution of tokens, leading to potential loss for either the buyers or the contract.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (beneficiary == msg.sender) { if (amountRaised >= fundingGoal){ fundingGoalReached = true; emit GoalReached(beneficiary, amountRaised); } crowdsaleClosed = true; } }",
        "vulnerability": "Incorrect access control",
        "reason": "The 'checkGoalReached' function can only be called by the beneficiary, which means if the beneficiary does not call this function, the goal status might never be updated, potentially preventing the closure of the crowdsale and subsequent actions. This can be exploited by a malicious or negligent beneficiary.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    }
]