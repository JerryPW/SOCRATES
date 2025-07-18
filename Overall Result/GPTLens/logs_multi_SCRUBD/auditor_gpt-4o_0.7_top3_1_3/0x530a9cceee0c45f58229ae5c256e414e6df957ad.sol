[
    {
        "function_name": "function ()",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers tokens to the sender before updating the state variables such as abioSold. This allows an attacker to re-enter the function by recursively calling it through the transfer, potentially causing incorrect balances and token allocations.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached) { require(treasury == msg.sender); if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' which forwards 2300 gas to the recipient, preventing state change after an external call. However, in the case of a reentrant call, the ethBalances[msg.sender] can be manipulated before the state is updated, allowing an attacker to withdraw more funds than they are entitled to.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "prolong",
        "code": "function prolong(uint _timeInMins) external onlyOwner{ require(!didProlong); require(now <= deadline - 4 days); uint t = _timeInMins * 1 minutes; require(t <= 3 weeks); deadline += t; length += t; didProlong = true; emit Prolonged(msg.sender, deadline); }",
        "vulnerability": "Deadline manipulation",
        "reason": "The owner can extend the ICO deadline by up to 3 weeks, possibly without the consent of the participants. This can be unfair to investors who expect the ICO to close at a specific time, affecting their decision-making and the potential success or failure of the token sale.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    }
]