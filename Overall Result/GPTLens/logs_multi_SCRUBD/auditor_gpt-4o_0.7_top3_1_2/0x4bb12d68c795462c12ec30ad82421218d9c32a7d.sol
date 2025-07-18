[
    {
        "function_name": "function()",
        "code": "function () payable { if (crowdsaleClosed) { uint amount2 = balanceOf[msg.sender]; uint rewardPercent = percent - percentOf[msg.sender]; require(amount2 > 0 && rewardPercent > 0); percentOf[msg.sender] = percent; uint rewardAmount2 = amount2 * 10**18 * rewardPercent / price / 100; tokenReward.transfer(msg.sender, rewardAmount2); RewardToken(msg.sender, rewardAmount2, rewardPercent); } else { uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; percentOf[msg.sender] = percent; uint rewardAmount = amount * 10**18 * percent / price / 100; tokenReward.transfer(msg.sender, rewardAmount); FundTransfer(msg.sender, amount, true); RewardToken(msg.sender, rewardAmount, percent); } }",
        "vulnerability": "Reentrancy attack",
        "reason": "The fallback function allows token transfers before updating critical state variables, which may lead to reentrancy attacks. Attackers can exploit this by repeatedly calling the function and draining tokens before the state is updated.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { require(crowdsaleClosed); if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Unsafe usage of send",
        "reason": "The use of send to transfer ether is unsafe because it only forwards 2300 gas, which may not be sufficient if the recipient has a fallback function that requires more gas. This can cause transactions to fail, preventing legitimate users from withdrawing their funds.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "releaseTenPercent",
        "code": "function releaseTenPercent() afterDeadline { require(crowdsaleClosed); require(percent <= 90); if (fundingGoalReached && beneficiary == msg.sender) { percent += 10; } }",
        "vulnerability": "Improper access control",
        "reason": "The releaseTenPercent function allows the beneficiary to increase the percent without any limit checks after the crowdsale has ended. There is no mechanism to ensure that this increase is not abused, potentially allowing the beneficiary to unfairly distribute more tokens than intended.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    }
]