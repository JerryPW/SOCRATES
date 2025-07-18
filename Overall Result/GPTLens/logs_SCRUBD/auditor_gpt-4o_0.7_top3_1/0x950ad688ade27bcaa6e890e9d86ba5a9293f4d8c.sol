[
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) / price); } crowdsaleClosed = true; }",
        "vulnerability": "Token transfer without validation",
        "reason": "In the checkGoalReached function, if the funding goal is not met, the contract transfers a certain amount of tokens to the beneficiary without checking if the transfer is successful. This can lead to scenarios where the token transfer fails (due to lack of approval or other reasons), but the contract still proceeds to close the crowdsale, potentially leading to a loss of tokens that were meant to be transferred.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The safeWithdrawal function directly uses the .send method to transfer ether to the beneficiary. If the beneficiary is a contract, it can execute a fallback function that could potentially reenter the safeWithdrawal function before amountRemaining is set to 0, allowing the attacker to drain the contract funds.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable public { require(!crowdsaleClosed); uint amount = msg.value; amountRaised += amount; amountRemaining+= amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Token price manipulation",
        "reason": "The fallback function calculates the number of tokens to transfer based on a fixed price. If the token has a fluctuating market value, this fixed rate can be exploited by attackers to purchase tokens at a lower price when the market value is high, leading to potential financial losses for the token issuer.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    }
]