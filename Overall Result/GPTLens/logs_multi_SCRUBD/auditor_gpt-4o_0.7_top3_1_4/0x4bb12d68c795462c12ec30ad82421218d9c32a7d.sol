[
    {
        "function_name": "function () payable",
        "code": "function () payable { if (crowdsaleClosed) { uint amount2 = balanceOf[msg.sender]; uint rewardPercent = percent - percentOf[msg.sender]; require(amount2 > 0 && rewardPercent > 0); percentOf[msg.sender] = percent; uint rewardAmount2 = amount2 * 10**18 * rewardPercent / price / 100; tokenReward.transfer(msg.sender, rewardAmount2); RewardToken(msg.sender, rewardAmount2, rewardPercent); } else { uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; percentOf[msg.sender] = percent; uint rewardAmount = amount * 10**18 * percent / price / 100; tokenReward.transfer(msg.sender, rewardAmount); FundTransfer(msg.sender, amount, true); RewardToken(msg.sender, rewardAmount, percent); } }",
        "vulnerability": "Re-entrancy vulnerability",
        "reason": "The fallback function makes external calls to the token contract's transfer function before updating the state variables. This opens up a re-entrancy attack vector where a malicious token contract could call back into the fallback function, potentially draining funds or corrupting the contract state.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { require(crowdsaleClosed); if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Use of send function",
        "reason": "The use of the 'send' function is dangerous as it only forwards a limited amount of gas, which can lead to unexpected failures during fund transfers. This may cause funds to get stuck in the contract if the recipient is a contract that requires more gas. Additionally, the fallback to reset the balance if 'send' fails can lead to loss of funds if subsequent attempts also fail.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "releaseTenPercent",
        "code": "function releaseTenPercent() afterDeadline { require(crowdsaleClosed); require(percent <= 90); if (fundingGoalReached && beneficiary == msg.sender) { percent += 10; } }",
        "vulnerability": "Arbitrary increase of percent",
        "reason": "The function allows the beneficiary to arbitrarily increase the percent value by 10 after the crowdsale is closed, without any restrictions or checks on the necessity or purpose of this increase. This can lead to unregulated manipulation of the percent value, potentially affecting the distribution of future rewards.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    }
]