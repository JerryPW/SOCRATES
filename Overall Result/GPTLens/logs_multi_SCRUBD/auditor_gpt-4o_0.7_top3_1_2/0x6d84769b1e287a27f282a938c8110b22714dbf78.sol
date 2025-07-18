[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached && now >= finalDeadline) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached && treasury == msg.sender) { if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `safeWithdrawal` function is vulnerable to reentrancy attacks. When the function uses `send`, it sends ether to the recipient and allows control to be transferred back to the recipient's fallback function before updating the state. If an attacker has a fallback function that calls `safeWithdrawal` again, they could potentially withdraw more funds than they are entitled to.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "function () payable stopOnPause",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Arithmetic precision loss",
        "reason": "The calculation of `ABIOAmount` using integer division (`amount / weiPerABIO`) may result in a loss of precision, causing users to receive fewer tokens than expected if `amount` is not exactly divisible by `weiPerABIO`. This can lead to discrepancies and user dissatisfaction.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "burnRestTokens",
        "code": "function burnRestTokens() afterDeadline{ require(!restTokensBurned); abioToken.burnMyBalance(); restTokensBurned = true; }",
        "vulnerability": "Missing authorization",
        "reason": "The `burnRestTokens` function can be called by anyone after the deadline, since it is missing any access control mechanisms. This allows any user to burn the remaining tokens, which may not be the intended behavior and could lead to a loss of funds or tokens.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    }
]