[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The function involves sending Ether to the beneficiary before updating the state variable `resAmount`. An attacker could exploit this by re-entering the function through the fallback function, potentially causing inconsistent state updates and draining the contract.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "devWithdrawal",
        "code": "function devWithdrawal(uint num, uint den) { if (!minimumTargetReached || !(beneficiary == msg.sender)) throw; uint wAmount = num / den; if (beneficiary.send(wAmount)) { FundTransfer(beneficiary, wAmount, false); } }",
        "vulnerability": "Integer Division Error",
        "reason": "The function calculates `wAmount` using integer division, which can result in truncation and unintentional zero value withdrawal if `num` is less than `den`. This can lead to unintended behavior or denial of service if not handled properly by the beneficiary.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed || (maximumTarget - amountRaised) < msg.value) throw; uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; resAmount += amount; soldTokens += amount / price; tokenReward.transfer(msg.sender, amount / price); FundTransfer(msg.sender, amount, true); if (amountRaised >= minimumTarget && !minimumTargetReached) { minimumTargetReached = true; GoalReached(beneficiary, minimumTarget); } if (minimumTargetReached) { if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, false); resAmount -= amount; } } }",
        "vulnerability": "Unbounded Gas Consumption",
        "reason": "The function lacks bounds on the number of tokens transferred per transaction which could lead to excessive gas consumption. This can be exploited by sending a large transaction to consume the gas limit, making the contract inaccessible due to failed transactions.",
        "file_name": "0xec94d178d97bac527fdcd4b3d4bf41b57d640c5b.sol"
    }
]