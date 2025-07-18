[
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "vulnerability": "Incorrect Token Transfer Logic",
        "reason": "If the funding goal is not reached, the contract attempts to transfer tokens to the beneficiary. This transfer is incorrectly calculated and executed even though the beneficiary is not supposed to receive tokens in this scenario. An attacker could potentially exploit this by ensuring the funding goal is not met and causing an unintended token transfer to themselves if they set themselves as the beneficiary.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Use of send method",
        "reason": "The use of the 'send' method for transferring Ether is dangerous due to its fixed gas stipend of 2300, which may be insufficient if the beneficiary is a contract with a fallback function requiring more gas. This could lead to failed transfers and potential locking of funds within the contract. An attacker or malicious beneficiary contract could exploit this by consuming more than the gas stipend, causing the withdrawal to fail.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable public { require(!crowdsaleClosed); uint amount = msg.value; amountRaised += amount; amountRemaining+= amount; tokenReward.transfer(msg.sender, amount * 6 / price); emit FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Lack of Checks-Effects-Interactions Pattern",
        "reason": "The fallback function violates the checks-effects-interactions pattern by transferring tokens before updating the state variables. This makes the contract vulnerable to reentrancy attacks, where an attacker could recursively call the fallback function before the state is updated, potentially receiving more tokens than intended. Although tokens are being transferred instead of Ether, the principle still holds, and unexpected behavior could be induced.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]