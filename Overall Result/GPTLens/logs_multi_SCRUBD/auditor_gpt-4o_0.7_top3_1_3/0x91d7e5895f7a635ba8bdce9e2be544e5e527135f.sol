[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of 'send' function can lead to reentrancy attacks because it forwards a limited amount of gas, allowing the beneficiary to call safeWithdrawal recursively before amountRemaining is set to 0. This could lead to unauthorized withdrawals.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect token transfer on goal not reached",
        "reason": "In the case where the funding goal is not reached, the contract transfers tokens to the beneficiary instead of refunding contributors. The expression for the token amount might also be a potential miscalculation, leading to erroneous token transfers.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "Crowdsale (Constructor)",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 8334 * 1 ether; deadline = 1533866400; price = 100 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Hardcoded deadline",
        "reason": "The deadline is hardcoded to a specific timestamp (1533866400), which is a past date in August 2018. This means the crowdsale is permanently closed, preventing any participation and leading to potential loss of funds for contributors who send ETH.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]