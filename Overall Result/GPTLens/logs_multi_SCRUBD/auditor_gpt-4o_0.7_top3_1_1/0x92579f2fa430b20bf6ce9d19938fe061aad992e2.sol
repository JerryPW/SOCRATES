[
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); require(tokensLeft >= amount / price); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); tokensLeft = tokenReward.getBalanceOf(address(this)); if (tokensLeft == 0) { crowdsaleClosed = true; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "This fallback function issues a transfer to the sender before updating the state variables such as balanceOf[msg.sender] and amountRaised. An attacker could recursively call this function and drain the contract by exploiting the reentrancy vulnerability.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Use of send instead of transfer",
        "reason": "The use of send in Solidity can lead to vulnerabilities as it only forwards 2300 gas, which may not be enough to execute complex fallback functions in certain contracts. This can lead to unexpected failures and potential denial of service conditions, especially if the fallback function in the receiver contract consumes more gas. Using transfer or a call with appropriate gas limits is safer.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () payable { require(!crowdsaleClosed); require(tokensLeft >= amount / price); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); tokensLeft = tokenReward.getBalanceOf(address(this)); if (tokensLeft == 0) { crowdsaleClosed = true; } }",
        "vulnerability": "Incorrect order of operations",
        "reason": "The contract checks the condition tokensLeft >= amount / price before defining the variable amount. This results in a compiler error since amount is being used before it's declared. This oversight would prevent the contract from being deployed as intended.",
        "file_name": "0x92579f2fa430b20bf6ce9d19938fe061aad992e2.sol"
    }
]