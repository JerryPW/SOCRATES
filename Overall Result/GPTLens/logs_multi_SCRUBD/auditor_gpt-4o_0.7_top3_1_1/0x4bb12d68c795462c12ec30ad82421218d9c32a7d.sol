[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed) { uint amount2 = balanceOf[msg.sender]; uint rewardPercent = percent - percentOf[msg.sender]; require(amount2 > 0 && rewardPercent > 0); percentOf[msg.sender] = percent; uint rewardAmount2 = amount2 * 10**18 * rewardPercent / price / 100; tokenReward.transfer(msg.sender, rewardAmount2); RewardToken(msg.sender, rewardAmount2, rewardPercent); } else { uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; percentOf[msg.sender] = percent; uint rewardAmount = amount * 10**18 * percent / price / 100; tokenReward.transfer(msg.sender, rewardAmount); FundTransfer(msg.sender, amount, true); RewardToken(msg.sender, rewardAmount, percent); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function allows for reentrancy attacks because it transfers tokens to the sender before updating the sender\u2019s balance (in the case where `crowdsaleClosed` is true). An attacker can repeatedly call the fallback function to drain tokens by invoking a reentrant call through the token contract.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { require(crowdsaleClosed); if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Unsafe use of send",
        "reason": "The `send` function is used which only forwards 2300 gas and does not throw an exception on failure. This can lead to a situation where an attacker prevents withdrawals by using a contract that consumes more than 2300 gas or reverts, causing funds to be stuck in the contract.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "releaseTenPercent",
        "code": "function releaseTenPercent() afterDeadline { require(crowdsaleClosed); require(percent <= 90); if (fundingGoalReached && beneficiary == msg.sender) { percent += 10; } }",
        "vulnerability": "Unbounded growth of percent",
        "reason": "The `percent` can be increased indefinitely as long as it is less than or equal to 90. This allows the beneficiary to call `releaseTenPercent` multiple times after the crowdsale, potentially manipulating the percent calculation logic in the fallback function for personal gain, though limited by the 90 percent check.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    }
]