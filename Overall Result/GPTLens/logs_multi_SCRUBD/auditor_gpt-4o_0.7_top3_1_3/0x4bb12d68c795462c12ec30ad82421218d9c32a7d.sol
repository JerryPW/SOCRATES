[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { require(crowdsaleClosed); if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `send` to transfer ether, which forwards 2300 gas, and does not protect against reentrancy. Attackers can use a fallback function to call `safeWithdrawal` again before `balanceOf[msg.sender]` is set to 0, allowing them to withdraw funds multiple times.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "releaseTenPercent",
        "code": "function releaseTenPercent() afterDeadline { require(crowdsaleClosed); require(percent <= 90); if (fundingGoalReached && beneficiary == msg.sender) { percent += 10; } }",
        "vulnerability": "Unrestricted increment of percent",
        "reason": "The increment of `percent` is unchecked and unrestricted, meaning the beneficiary can repeatedly call this function to increase the percent beyond 100, potentially manipulating reward calculations in unexpected ways.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable { if (crowdsaleClosed) { uint amount2 = balanceOf[msg.sender]; uint rewardPercent = percent - percentOf[msg.sender]; require(amount2 > 0 && rewardPercent > 0); percentOf[msg.sender] = percent; uint rewardAmount2 = amount2 * 10**18 * rewardPercent / price / 100; tokenReward.transfer(msg.sender, rewardAmount2); RewardToken(msg.sender, rewardAmount2, rewardPercent); } else { uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; percentOf[msg.sender] = percent; uint rewardAmount = amount * 10**18 * percent / price / 100; tokenReward.transfer(msg.sender, rewardAmount); FundTransfer(msg.sender, amount, true); RewardToken(msg.sender, rewardAmount, percent); } }",
        "vulnerability": "Potential integer overflow",
        "reason": "The calculations for `rewardAmount` and `rewardAmount2` involve multiplication and division with user-controlled values. Without checks for overflows, an attacker could manipulate these calculations to incorrectly issue token rewards.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    }
]