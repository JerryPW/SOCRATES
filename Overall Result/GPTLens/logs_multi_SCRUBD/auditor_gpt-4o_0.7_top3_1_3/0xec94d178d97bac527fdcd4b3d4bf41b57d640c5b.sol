[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function performs a call to an external contract `tokenReward.transfer()` and then a send operation `beneficiary.send(amount)`. This is vulnerable to reentrancy attacks since the state changes (e.g., updating `resAmount` and `balanceOf`) occur after the external call. An attacker could re-enter the contract during the `send` operation and manipulate the state, potentially draining funds.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devWithdrawal",
        "code": "function devWithdrawal(uint num, uint den) { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; uint wAmount = num / den; if (beneficiary.send(wAmount)) { FundTransfer(beneficiary, wAmount, false); } }",
        "vulnerability": "Division by Zero",
        "reason": "The `devWithdrawal` function does not check if `den` is zero before performing the division `num / den`. If `den` is zero, this will cause the transaction to throw and potentially lock the contract or cause unintended behavior. This is exploitable if an attacker can influence the values of `num` and `den`.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!minimumTargetReached && crowdsaleClosed) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } }",
        "vulnerability": "Reentrancy",
        "reason": "The `safeWithdrawal` function updates the balance after an external call `msg.sender.send(amount)`. This exposes the contract to reentrancy attacks. An attacker can re-enter the function and manipulate the withdrawal process to extract more funds than allowed.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    }
]