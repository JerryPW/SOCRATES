[
    {
        "function_name": "safeWithdrawal",
        "vulnerability": "Unsafe Ether Transfer",
        "criticism": "The reasoning is correct. The `send` function is used to transfer Ether to the beneficiary, which can fail silently due to low gas or other issues. This can result in Ether being stuck in the contract. The severity and profitability of this vulnerability are high because it can lead to loss of Ether.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The `send` function is used to transfer Ether to the beneficiary, which forwards only 2300 gas and can fail silently. This can result in Ether being stuck in the contract if the transfer fails due to low gas or other issues.",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol",
        "final_score": 8.5
    },
    {
        "function_name": "function () payable public",
        "vulnerability": "Reentrancy Vulnerability",
        "criticism": "The reasoning is correct. The fallback function does not update the state variables before transferring tokens, which could potentially allow for reentrancy attacks. However, the severity and profitability of this vulnerability are high only if the contract has a significant amount of tokens to be drained.",
        "correctness": 9,
        "severity": 7,
        "profitability": 7,
        "reason": "The fallback function transfers tokens to the `msg.sender` without updating the state variables first. This may allow for reentrancy attacks where an attacker could recursively call the fallback function and drain the contract by repeatedly getting tokens.",
        "code": "function () payable public { require(!crowdsaleClosed); uint amount = msg.value; amountRaised += amount; amountRemaining+= amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); }",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol",
        "final_score": 8.0
    },
    {
        "function_name": "checkGoalReached",
        "vulnerability": "Incorrect Token Transfer Logic",
        "criticism": "The reasoning is correct. If the funding goal is not reached, the remaining tokens are transferred to the beneficiary, which might not be the intended behavior. However, the severity and profitability of this vulnerability are low because it is based on the contract's funding goal and the amount of tokens available.",
        "correctness": 9,
        "severity": 3,
        "profitability": 2,
        "reason": "If the funding goal is not reached, the remaining tokens are transferred to the beneficiary, which might not be the intended behavior. This could lead to loss of tokens from the contract without proper checks on the token amount available for transfer.",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) / price); } crowdsaleClosed = true; }",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol",
        "final_score": 5.75
    }
]