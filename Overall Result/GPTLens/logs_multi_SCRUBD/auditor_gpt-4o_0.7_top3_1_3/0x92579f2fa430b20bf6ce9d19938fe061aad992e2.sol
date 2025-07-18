[
    {
        "function_name": "function",
        "code": "function () payable { require(!crowdsaleClosed); require(tokensLeft >= amount / price); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); tokensLeft = tokenReward.getBalanceOf(address(this)); if (tokensLeft == 0) { crowdsaleClosed = true; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows sending Ether to the contract and transferring tokens to the sender without using a mutex or checks-effects-interactions pattern. An attacker could re-enter this function by calling it recursively during the token transfer, manipulating the state variables like `balanceOf` and `amountRaised` to their advantage.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Unsafe usage of send() function",
        "reason": "The `send` function is used for transferring Ether, which only forwards 2300 gas, potentially causing the transaction to fail if the receiving contract requires more gas. This can lead to funds being stuck in the contract if the fallback function of the recipient consumes more than 2300 gas. Additionally, if the send fails, the logic to revert the state could be bypassed.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() afterDeadline { if (amountRaised >= fundingGoal) { fundingGoalReached = true; crowdsaleClosed = true; GoalReached(beneficiary, amountRaised); } }",
        "vulnerability": "Potential for incorrect state update",
        "reason": "The function updates `fundingGoalReached` and `crowdsaleClosed` states without checking for potential reentrancy or other conditions that could lead to incorrect state. If `checkGoalReached` is not called properly after the deadline, the contract may not update its state correctly, potentially leaving funds locked or incorrectly distributed.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    }
]