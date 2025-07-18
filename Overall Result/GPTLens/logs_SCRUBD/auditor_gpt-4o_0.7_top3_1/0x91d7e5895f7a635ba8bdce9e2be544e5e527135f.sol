[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Unsafe use of send function",
        "reason": "The use of `send` is unsafe because it only forwards 2300 gas, which may not be enough for complex fallback functions in the receiving contract. Moreover, it does not throw an exception on failure, making it difficult to handle errors correctly. If the `send` fails, the contract will not reset `amountRemaining`, potentially leading to repeated withdrawal attempts.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect token reward logic",
        "reason": "In the `checkGoalReached` function, if the funding goal is not met, tokens are transferred to the beneficiary based on the shortfall amount. This logic is flawed because it essentially rewards the beneficiary with tokens even though the funding goal was not achieved, which could be financially detrimental to the project and unfair to contributors.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 8334 * 1 ether; deadline = 1533866400; price = 100 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Hardcoded deadline",
        "reason": "The deadline is hardcoded to a specific timestamp (1533866400), which means that the crowdsale will only function correctly within a specific time frame. This can lead to the contract becoming obsolete if the specified date is in the past, rendering the crowdsale ineffective.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]