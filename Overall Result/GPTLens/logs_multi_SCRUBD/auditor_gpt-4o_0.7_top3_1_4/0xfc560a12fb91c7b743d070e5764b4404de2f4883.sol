[
    {
        "function_name": "function ()",
        "code": "function () public payable { require(!crowdsaleClosed); require(!(now <= startTime)); require(!(amountRaised >= fundingGoal)); uint totalContribution = balanceOf[msg.sender]; bool exstingContributor = totalContribution > 0; uint amount = msg.value; bool moreThanMinAmount = amount >= minContribution; bool lessThanMaxTotalContribution = amount + totalContribution <= maxContribution; require(moreThanMinAmount); require(lessThanMaxTotalContribution); if (lessThanMaxTotalContribution && moreThanMinAmount) { balanceOf[msg.sender] += amount; fundedAmount[msg.sender] += amount; emit FundTransfer(msg.sender, amount, true); if (!exstingContributor) { buyers[buyerCount] = msg.sender; buyerCount += 1; } amountRaised += amount; } }",
        "vulnerability": "No refund mechanism for contributors.",
        "reason": "The fallback function allows users to contribute to the crowdsale, but there is no mechanism to refund contributions if the funding goal is not met. This could result in contributors losing their funds if the goal is not achieved.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Potential integer overflow in token distribution.",
        "reason": "The calculation for token distribution uses multiplication and division which could potentially result in an integer overflow. This could allow attackers to receive more tokens than intended if the calculation overflows.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterWithdrawalDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { emit FundTransfer(beneficiary, amountRaised, false); } uint totalTokens = tokenReward.balanceOf(address(this)); uint remainingTokens = totalTokens; for (uint i=0; i<buyerCount; i++) { address buyerId = buyers[i]; uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; if (remainingTokens >= amount) { tokenReward.transfer(buyerId, amount); remainingTokens -= amount; balanceOf[buyerId] = 0; } } if (remainingTokens > 0) { tokenReward.transfer(beneficiary, remainingTokens); } } }",
        "vulnerability": "Reentrancy vulnerability in beneficiary withdrawal.",
        "reason": "The function sends ether to the beneficiary using `send`, which only forwards 2300 gas. However, if reentrancy occurs before the state is updated, it could lead to inconsistent contract state and potential reentrancy attacks.",
        "file_name": "0xfc560a12fb91c7b743d070e5764b4404de2f4883.sol"
    }
]