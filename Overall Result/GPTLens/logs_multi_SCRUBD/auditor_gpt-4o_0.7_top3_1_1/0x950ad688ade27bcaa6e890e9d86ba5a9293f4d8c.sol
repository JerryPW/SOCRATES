[
    {
        "function_name": "function () payable public",
        "code": "function () payable public { require(!crowdsaleClosed); uint amount = msg.value; amountRaised += amount; amountRemaining+= amount; tokenReward.transfer(msg.sender, amount / price); emit FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The fallback function transfers tokens to the `msg.sender` without updating the state variables first. This may allow for reentrancy attacks where an attacker could recursively call the fallback function and drain the contract by repeatedly getting tokens.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect Token Transfer Logic",
        "reason": "If the funding goal is not reached, the remaining tokens are transferred to the beneficiary, which might not be the intended behavior. This could lead to loss of tokens from the contract without proper checks on the token amount available for transfer.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The `send` function is used to transfer Ether to the beneficiary, which forwards only 2300 gas and can fail silently. This can result in Ether being stuck in the contract if the transfer fails due to low gas or other issues.",
        "file_name": "0x950ad688ade27bcaa6e890e9d86ba5a9293f4d8c.sol"
    }
]