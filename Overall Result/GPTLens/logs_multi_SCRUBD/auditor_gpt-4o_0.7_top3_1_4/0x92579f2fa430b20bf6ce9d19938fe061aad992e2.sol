[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); require(tokensLeft >= amount / price); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); tokensLeft = tokenReward.getBalanceOf(address(this)); if (tokensLeft == 0) { crowdsaleClosed = true; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function is susceptible to a reentrancy attack because it updates the state variables (balanceOf, amountRaised) before transferring tokens to the sender. If the token contract is malicious, it could call back into this function before the variables are updated, potentially allowing an attacker to drain tokens or Ether from the contract.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Unsafe use of send() for Ether transfer",
        "reason": "The use of send() to transfer Ether is unsafe because it only forwards 2300 gas, potentially causing the transfer to fail if the recipient requires more gas. This could lead to funds being locked in the contract. Additionally, using send() makes the contract susceptible to reentrancy attacks. The state update should occur after the send operation to prevent reentrancy vulnerabilities.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "bringBackTokens",
        "code": "function bringBackTokens() afterDeadline { require(tokensLeft > 0); if (msg.sender == beneficiary) { tokenReward.transfer(beneficiary, tokensLeft); tokensLeft = tokenReward.getBalanceOf(address(this)); } }",
        "vulnerability": "Potential for token loss",
        "reason": "The function bringBackTokens allows the beneficiary to transfer all remaining tokens back to themselves after the deadline. However, if the token contract does not support the transfer of all tokens at once, or if there is a problem with the token contract, it could lead to the loss of tokens, leaving them stuck in the contract permanently.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    }
]