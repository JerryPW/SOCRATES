[
    {
        "function_name": "safeWithdrawal",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is partially correct. The use of 'send' does indeed forward a limited amount of gas, which can prevent reentrancy in some cases. However, the function does not use a reentrancy guard, and the state update occurs after the external call, which is a common pattern that can lead to reentrancy vulnerabilities. The severity is moderate because it depends on the beneficiary's contract behavior. The profitability is moderate as well, as an attacker could potentially exploit this to withdraw more funds than intended.",
        "correctness": 6,
        "severity": 5,
        "profitability": 5,
        "reason": "The use of 'send' function can lead to reentrancy attacks because it forwards a limited amount of gas, allowing the beneficiary to call safeWithdrawal recursively before amountRemaining is set to 0. This could lead to unauthorized withdrawals.",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "checkGoalReached",
        "vulnerability": "Incorrect token transfer on goal not reached",
        "criticism": "The reasoning is correct. The function incorrectly transfers tokens to the beneficiary when the funding goal is not reached, which is not the intended behavior. This could lead to a loss of tokens for contributors. The expression for calculating the token amount is also potentially incorrect, which could exacerbate the issue. The severity is high because it directly affects the fairness of the crowdsale. The profitability is low for an external attacker but could be high for the beneficiary.",
        "correctness": 8,
        "severity": 7,
        "profitability": 3,
        "reason": "In the case where the funding goal is not reached, the contract transfers tokens to the beneficiary instead of refunding contributors. The expression for the token amount might also be a potential miscalculation, leading to erroneous token transfers.",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "Crowdsale (Constructor)",
        "vulnerability": "Hardcoded deadline",
        "criticism": "The reasoning is correct. The hardcoded deadline is a past date, which means the crowdsale is permanently closed. This prevents any participation and could lead to a loss of funds for contributors who send ETH without realizing the crowdsale is closed. The severity is high because it completely breaks the functionality of the crowdsale. The profitability is low because it does not provide a direct financial gain to an attacker, but it does prevent the intended use of the contract.",
        "correctness": 9,
        "severity": 8,
        "profitability": 1,
        "reason": "The deadline is hardcoded to a specific timestamp (1533866400), which is a past date in August 2018. This means the crowdsale is permanently closed, preventing any participation and leading to potential loss of funds for contributors who send ETH.",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 8334 * 1 ether; deadline = 1533866400; price = 100 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]