[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached && now >= finalDeadline) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached && treasury == msg.sender) { if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The safeWithdrawal function uses msg.sender.send(amount), which sends Ether to the sender without using the transfer method (which forwards only a fixed amount of gas). This allows for a reentrancy attack where an attacker can call back into the contract before the state changes are finalized, potentially draining funds.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Lack of input validation for ABIOAmount",
        "reason": "The function does not check whether the ABIOAmount calculated as amount / weiPerABIO results in a correct number of tokens. If weiPerABIO is set to a value that doesn't divide the sent Ether amount perfectly, it might lead to unexpected token allocation or rounding errors, potentially allowing an attacker to exploit the price calculation.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "burnRestTokens",
        "code": "function burnRestTokens() afterDeadline{ require(!restTokensBurned); abioToken.burnMyBalance(); restTokensBurned = true; }",
        "vulnerability": "No access control",
        "reason": "The burnRestTokens function lacks proper access control. Any user can call this function after the deadline, which might lead to unintended burning of tokens if the function is triggered by someone other than the intended actor.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    }
]