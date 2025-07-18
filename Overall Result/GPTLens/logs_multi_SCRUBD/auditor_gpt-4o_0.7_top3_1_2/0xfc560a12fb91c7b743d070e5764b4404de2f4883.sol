[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `safeWithdrawal` function makes an external call to `beneficiary.send(amountRaised)`, which is a potential reentrancy point. If the beneficiary is a contract with a fallback function that calls `safeWithdrawal` again, it can drain the funds by repeatedly calling this function before the state is updated. This is a classic reentrancy vulnerability.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor( address ifSuccessfulSendTo, uint fundingGoalInEthers, uint startUnixTime, uint durationInMinutes, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = fundingGoalInEthers * 1 ether; startTime = startUnixTime; deadline = startTime + durationInMinutes * 1 minutes; withdrawlDeadline = deadline + fundsOnHoldAfterDeadline; tokenReward = ligoToken(addressOfTokenUsedAsReward); }",
        "vulnerability": "Unrestricted access",
        "reason": "The constructor allows setting the `beneficiary` to any arbitrary address. If an attacker can deploy the contract and set themselves as the beneficiary, they could potentially withdraw all funds without contributing.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (beneficiary == msg.sender) { if (amountRaised >= fundingGoal){ fundingGoalReached = true; emit GoalReached(beneficiary, amountRaised); } crowdsaleClosed = true; } }",
        "vulnerability": "Logic vulnerability in goal checking",
        "reason": "The `checkGoalReached` function can only be called by the `beneficiary`, which means that if the beneficiary never calls this function, the `crowdsaleClosed` flag will never be set to true, potentially locking funds in the contract indefinitely. Moreover, the `fundingGoal` check and state update should be independent of the caller's identity.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    }
]