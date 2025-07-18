[
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect token transfer logic",
        "reason": "If the funding goal is not reached, the function attempts to transfer tokens to the beneficiary based on the shortfall amount. This logic is flawed because it effectively allows the contract to mint tokens for the beneficiary without having collected the corresponding ether, essentially giving the beneficiary free tokens for unmet goals.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Incorrect order of state updates and external calls",
        "reason": "The function uses 'send' to transfer ether to the beneficiary, which only forwards 2300 gas. If the transfer fails, the function does not revert, leaving 'amountRemaining' unchanged. However, it updates the 'amountRemaining' to 0 only after a successful send, which could lead to inconsistencies if the call fails or if the beneficiary is a contract that requires more gas.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 5000 * 1 ether; deadline = 1532361600; price = 10 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Hardcoded deadline",
        "reason": "The deadline is hardcoded to a past timestamp (1532361600 corresponds to July 23, 2018). As 'now' will always be greater than this deadline, the crowdsale is effectively non-functional as it prevents any contributions from being made.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    }
]