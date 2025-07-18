[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function has a reentrancy vulnerability due to the use of `send` to transfer ether. An attacker can use a smart contract with a fallback function to repeatedly call the payable function before the state variables `resAmount` and `balanceOf` are updated, potentially draining the contract of funds.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devWithdrawal",
        "code": "function devWithdrawal(uint num, uint den) { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; uint wAmount = num / den; if (beneficiary.send(wAmount)) { FundTransfer(beneficiary, wAmount, false); } }",
        "vulnerability": "Integer Division and Incorrect Withdrawal Amount Calculation",
        "reason": "The division `num / den` can lead to inaccurate calculations if `num` is not perfectly divisible by `den`, potentially allowing the beneficiary to withdraw an incorrect (and possibly larger) amount than intended. Additionally, the division could result in zero if `num` is less than `den`, preventing any withdrawal.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devResWithdrawal",
        "code": "function devResWithdrawal() { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; if (beneficiary.send(resAmount)) { FundTransfer(beneficiary, resAmount, false); resAmount = 0; } }",
        "vulnerability": "Reentrancy",
        "reason": "This function is vulnerable to reentrancy attacks because it uses `send` to transfer ether before updating the `resAmount` state variable. An attacker with control over the beneficiary address can call back into the contract, exploiting this reentrancy to drain funds.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    }
]