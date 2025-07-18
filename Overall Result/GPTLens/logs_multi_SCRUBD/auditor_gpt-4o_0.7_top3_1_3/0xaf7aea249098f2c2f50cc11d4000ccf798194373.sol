[
    {
        "function_name": "withdraw",
        "code": "function withdraw() atStage(Stages.Ended) { require(raised >= minAmount); uint256 ethBalance = this.balance; uint256 ethFees = ethBalance * 5 / 10**3; creator.transfer(ethFees); beneficiary.transfer(ethBalance - ethFees); stage = Stages.Withdrawn; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers ether to the creator and beneficiary before updating the contract's state (stage = Stages.Withdrawn). This allows for a reentrancy attack where the recipient can call back into the contract and influence the state incorrectly, potentially leading to multiple withdrawals.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund() atStage(Stages.Ended) { require(raised < minAmount); uint256 receivedAmount = balances[msg.sender]; balances[msg.sender] = 0; if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) { balances[msg.sender] = receivedAmount; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The refund function zeroes out the user's balance before attempting to send ether back to them. If the send fails and reverts the balance, an attacker could exploit this by re-entering the contract during the send operation, allowing them to call refund multiple times and withdraw more than they should.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    },
    {
        "function_name": "toZT",
        "code": "function toZT(uint256 _wei) returns (uint256 amount) { uint256 rate = 0; if (stage != Stages.Ended && now >= start && now <= end) { if (now <= start + ratePreICOEnd) { rate = ratePreICO; } else if (now <= start + rateAngelDayEnd) { rate = rateAngelDay; } else if (now <= start + rateFirstWeekEnd) { rate = rateFirstWeek; } else if (now <= start + rateSecondWeekEnd) { rate = rateSecondWeek; } else if (now <= start + rateThirdWeekEnd) { rate = rateThirdWeek; } else if (now <= start + rateLastWeekEnd) { rate = rateLastWeek; } } uint256 ztAmount = _wei * rate * 10**8 / 1 ether; if (raised > minAmount) { uint256 multiplier = raised / minAmount; for (uint256 i = 0; i < multiplier; i++) { ztAmount = ztAmount * 965936329 / 10**9; } } return ztAmount; }",
        "vulnerability": "Integer overflow/underflow",
        "reason": "The toZT function performs arithmetic operations without checking for overflows or underflows. Specifically, the multiplication and division operations when calculating ztAmount and adjusting it based on the multiplier can lead to overflow or underflow, resulting in incorrect token calculations and potential exploitation by attackers.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    }
]