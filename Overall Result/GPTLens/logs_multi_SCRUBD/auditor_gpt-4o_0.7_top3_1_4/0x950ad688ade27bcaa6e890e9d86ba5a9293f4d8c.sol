[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `send` to transfer ether to the beneficiary allows a potential reentrancy attack. If the beneficiary is a contract, it could call back into the `safeWithdrawal` function before `amountRemaining` is set to 0, allowing the attacker to withdraw funds multiple times.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect token distribution logic",
        "reason": "If the funding goal is not reached, the contract attempts to transfer tokens to the beneficiary equivalent to the shortfall in funding. This could result in an incorrect distribution if the token contract does not have sufficient tokens, or if the logic of rewarding tokens in case of a funding shortfall is not intended.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 5000 * 1 ether; deadline = 1532361600; price = 10 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Hardcoded deadline",
        "reason": "The deadline is hardcoded to a specific timestamp, which has likely already passed. This means the crowdsale will always be considered closed, preventing any contributions or withdrawals. This is a severe oversight as it makes the contract non-functional in real-world scenarios.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    }
]