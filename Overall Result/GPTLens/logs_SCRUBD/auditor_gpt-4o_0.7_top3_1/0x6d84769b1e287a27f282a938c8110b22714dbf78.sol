[
    {
        "function_name": "function() payable stopOnPause",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Reentrancy",
        "reason": "This fallback function allows Ether to be sent to the contract and updates state variables before transferring tokens. If the `abioToken.transfer` function calls back into this contract (either directly or indirectly), it could reenter this function and potentially double spend the amount or manipulate balances before the state variables are updated correctly.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached && now >= finalDeadline) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached && treasury == msg.sender) { if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Unsafe use of send",
        "reason": "The use of `send` is generally discouraged as it forwards a limited amount of gas and can fail for various reasons, which may not be related to the contract's logic. This could result in a denial-of-service (DoS) scenario where funds are locked in the contract if the `send` fails repeatedly.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    },
    {
        "function_name": "tokenFallback",
        "code": "function tokenFallback(address _from, uint _value, bytes _data) external{ require(_from == abioToken.owner() || _from == owner); volume = _value; paused = false; deadline = now + length; emit ICOStart(_value, weiPerABIO, minInvestment); }",
        "vulnerability": "Arbitrary unpausing",
        "reason": "This function allows the contract to be unpaused by anyone who can call `tokenFallback` with the `abioToken.owner()` or `owner` address, which could be manipulated if the token contract is compromised or if the owner is not secure. This allows an attacker to potentially restart the ICO at will by sending tokens to this contract, bypassing the intended pause mechanism.",
        "file_name": "0x6d84769b1e287a27f282a938c8110b22714dbf78.sol"
    }
]