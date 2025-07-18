[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached && now >= finalDeadline) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached && treasury == msg.sender) { if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `safeWithdrawal` is vulnerable to reentrancy attacks because it updates the balance of the sender only after the `send` call, which can be exploited by attackers to repeatedly call `safeWithdrawal` and drain funds. Implementing a check-effects-interactions pattern or using the `transfer` method instead of `send` can mitigate this risk.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "changeOwner",
        "code": "function changeOwner(address _newOwner) public onlyOwner{ require(_newOwner != address(0x0)); emit ownerTransfer(owner, _newOwner); owner = _newOwner; }",
        "vulnerability": "Ownership takeover vulnerability",
        "reason": "The `changeOwner` function allows the current owner to transfer ownership to a new address, but there is no mechanism to confirm the new owner's acceptance. This could lead to scenarios where ownership is accidentally transferred to an address that is not controlled by a person capable of managing the contract, or potentially misused to transfer ownership to a malicious contract.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "burnRestTokens",
        "code": "function burnRestTokens() afterDeadline{ require(!restTokensBurned); abioToken.burnMyBalance(); restTokensBurned = true; }",
        "vulnerability": "Unconfirmed external call",
        "reason": "The function `burnRestTokens` makes an external call to `abioToken.burnMyBalance()` without checking if the call was successful. If the call fails, the rest of the function will still execute, setting `restTokensBurned` to true, which prevents any further attempts to burn tokens and could leave tokens unburned.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    }
]