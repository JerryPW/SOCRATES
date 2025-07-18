[
    {
        "function_name": "checkGoalReached",
        "code": "function checkGoalReached() public afterDeadline { if (amountRaised >= fundingGoal){ emit GoalReached(beneficiary, amountRaised); } else { tokenReward.transfer(beneficiary, (fundingGoal-amountRaised) * 6 / price); } crowdsaleClosed = true; }",
        "vulnerability": "Token transfer to beneficiary if goal not reached",
        "reason": "If the funding goal is not reached, the contract sends the remaining tokens equivalent to (fundingGoal-amountRaised) * 6 / price to the beneficiary. This is a logical flaw because typically, if the goal is not met, the contributors should receive a refund or equivalent compensation, not the beneficiary getting additional tokens. This could be exploited by a malicious beneficiary who could end up with more tokens than intended.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public afterDeadline { if (beneficiary == msg.sender) { if (beneficiary.send(amountRemaining)) { amountRemaining =0; emit FundTransfer(beneficiary, amountRemaining, false); } } }",
        "vulnerability": "Unsafe use of send for Ether transfer",
        "reason": "The use of the send function to transfer Ether is unsafe because it only forwards 2300 gas, which may not be enough for complex fallback functions, potentially causing a transaction to fail unexpectedly. A more secure method would be to use call.value(). This vulnerability could allow an attacker to prevent the withdrawal of funds by deploying a contract with a fallback function that consumes more than 2300 gas.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    },
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, address addressOfTokenUsedAsReward ) public { beneficiary = ifSuccessfulSendTo; fundingGoal = 8334 * 1 ether; deadline = 1533866400; price = 100 szabo; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Hardcoded deadline",
        "reason": "The deadline is hardcoded to a specific timestamp (1533866400), which is a past date (August 2018). This means that the crowdsale can never be open for contributions as the deadline has already passed. This is a severe issue as it effectively renders the crowdsale non-functional. An attacker could exploit this by deploying the contract as is and misleading potential contributors.",
        "file_name": "0x91d7e5895f7a635ba8bdce9e2be544e5e527135f.sol"
    }
]