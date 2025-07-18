[
    {
        "function_name": "fallback function",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function is vulnerable to reentrancy because it updates the state variables (amountRaised, resAmount, etc.) before transferring tokens and ether. An attacker can exploit this by recursively calling the fallback function, causing the state variables to be manipulated improperly and potentially draining funds.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devWithdrawal",
        "code": "function devWithdrawal(uint num, uint den) { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; uint wAmount = num / den; if (beneficiary.send(wAmount)) { FundTransfer(beneficiary, wAmount, false); } }",
        "vulnerability": "Integer Division Error",
        "reason": "The function calculates the withdrawal amount using integer division (num / den). If 'den' is greater than 'num', this will result in 'wAmount' being zero, potentially leading to an incorrect transfer amount that does not reflect the intended portion of funds.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { if (!minimumTargetReached && crowdsaleClosed) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } }",
        "vulnerability": "Reentrancy",
        "reason": "The safeWithdrawal function is vulnerable to reentrancy similar to the fallback function. The balance of the sender is set to zero before sending the amount, which allows an attacker to re-enter the function and potentially withdraw more than intended by manipulating the balance.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    }
]