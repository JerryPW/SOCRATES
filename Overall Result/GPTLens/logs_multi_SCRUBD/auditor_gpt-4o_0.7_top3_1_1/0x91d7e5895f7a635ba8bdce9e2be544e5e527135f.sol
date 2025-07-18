[
    {
        "function_name": "function ()",
        "code": "function () payable public { require(!crowdsaleClosed); uint amount = msg.value; amountRaised += amount; amountRemaining+= amount; tokenReward.transfer(msg.sender, amount * 6 / price); emit FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Token Reward Calculation Flaw",
        "reason": "The function calculates the token reward using 'amount * 6 / price', which assumes a fixed exchange rate between the ether contributed and the tokens distributed. This could lead to incorrect token distribution if the price or exchange rate changes unexpectedly or is manipulated, leading to unfair token allocation.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "vulnerability": "Token Transfer on Goal Failure",
        "reason": "If the funding goal is not reached, the contract transfers tokens to the beneficiary using the same flawed calculation as in the fallback function. This could result in an excessive or insufficient amount of tokens being transferred, especially if the tokenReward contract has a different logic or balance state, leading to potential token loss or beneficiary gain.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'beneficiary.send(amountRemaining)' is unsafe because it only forwards 2300 gas, which might not be enough for the recipient if they have a fallback function with logic. It also does not handle reentrancy properly, potentially allowing a reentrancy attack if the beneficiary is a contract with malicious intent.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]