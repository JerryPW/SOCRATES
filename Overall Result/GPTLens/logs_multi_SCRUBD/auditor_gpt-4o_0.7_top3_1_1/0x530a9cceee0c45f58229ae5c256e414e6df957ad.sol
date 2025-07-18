[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached) { require(treasury == msg.sender); if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' to transfer ether, which only forwards 2300 gas, but does not use checks-effects-interactions pattern. This allows for a reentrancy attack where an attacker can repeatedly call the contract, draining funds before the state updates.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Arithmetic precision loss",
        "reason": "The calculation of 'ABIOAmount' using integer division can lead to a loss of precision, resulting in the under-distribution of tokens to investors. This can cause disputes or an unintended advantage to the contract owner if more tokens remain undistributed.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "prolong",
        "code": "function prolong(uint _timeInMins) external onlyOwner{ require(!didProlong); require(now <= deadline - 4 days); uint t = _timeInMins * 1 minutes; require(t <= 3 weeks); deadline += t; length += t; didProlong = true; emit Prolonged(msg.sender, deadline); }",
        "vulnerability": "Deadline manipulation vulnerability",
        "reason": "The owner can extend the ICO deadline by up to 3 weeks, a significant amount of time, without any restrictions besides having not prolonged before. This undermines investor trust as the owner can change the rules of the ICO after it has started, potentially leading to a longer lock-up of investor funds.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    }
]