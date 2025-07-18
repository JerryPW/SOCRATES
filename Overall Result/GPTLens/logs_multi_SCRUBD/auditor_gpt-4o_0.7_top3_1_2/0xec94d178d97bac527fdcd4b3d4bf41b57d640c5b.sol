[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The fallback function allows contributions to be made while transferring tokens to the sender. The use of 'send' in 'if (beneficiary.send(amount))' is unsafe because it does not handle reentrancy correctly. An attacker could exploit this by recursively calling the fallback function, making multiple contributions before the state is updated, allowing for multiple transfers of tokens to the attacker's address.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devWithdrawal",
        "code": "function devWithdrawal(uint num, uint den) { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; uint wAmount = num / den; if (beneficiary.send(wAmount)) { FundTransfer(beneficiary, wAmount, false); } }",
        "vulnerability": "Arithmetic Precision Error",
        "reason": "The calculation 'uint wAmount = num / den;' can lead to precision errors due to integer division. An attacker could manipulate 'num' and 'den' to cause unexpected results, potentially withdrawing more than intended. This is especially risky if the attacker can influence these input values.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!minimumTargetReached && crowdsaleClosed) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function 'safeWithdrawal' is vulnerable to reentrancy attacks because it uses 'send' to transfer funds back to the sender without applying the checks-effects-interactions pattern. An attacker could exploit this by recursively calling 'safeWithdrawal' to withdraw more than their balance, as the state update 'balanceOf[msg.sender] = 0;' occurs after the external call is made.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    }
]