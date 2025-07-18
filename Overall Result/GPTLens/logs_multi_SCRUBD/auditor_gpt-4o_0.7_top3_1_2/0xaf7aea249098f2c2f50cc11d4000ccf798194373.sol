[
    {
        "function_name": "refund",
        "code": "function refund() atStage(Stages.Ended) { require(raised < minAmount); uint256 receivedAmount = balances[msg.sender]; balances[msg.sender] = 0; if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) { balances[msg.sender] = receivedAmount; } }",
        "vulnerability": "reentrancy",
        "reason": "The refund function is vulnerable to reentrancy attacks because it sends ether to the user's address before setting the balance to zero. An attacker could potentially call this function recursively before the balances[msg.sender] = 0 is executed, allowing them to drain the contract balance.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() atStage(Stages.Ended) { require(raised >= minAmount); uint256 ethBalance = this.balance; uint256 ethFees = ethBalance * 5 / 10**3; creator.transfer(ethFees); beneficiary.transfer(ethBalance - ethFees); stage = Stages.Withdrawn; }",
        "vulnerability": "lack of access control",
        "reason": "The withdraw function lacks proper access control, allowing anyone to call it once the stage is Stages.Ended and the raised amount is above the minimum. This could lead to unauthorized withdrawals.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    },
    {
        "function_name": "toZT",
        "code": "function toZT(uint256 _wei) returns (uint256 amount) { uint256 rate = 0; if (stage != Stages.Ended && now >= start && now <= end) { if (now <= start + ratePreICOEnd) { rate = ratePreICO; } else if (now <= start + rateAngelDayEnd) { rate = rateAngelDay; } else if (now <= start + rateFirstWeekEnd) { rate = rateFirstWeek; } else if (now <= start + rateSecondWeekEnd) { rate = rateSecondWeek; } else if (now <= start + rateThirdWeekEnd) { rate = rateThirdWeek; } else if (now <= start + rateLastWeekEnd) { rate = rateLastWeek; } } uint256 ztAmount = _wei * rate * 10**8 / 1 ether; if (raised > minAmount) { uint256 multiplier = raised / minAmount; for (uint256 i = 0; i < multiplier; i++) { ztAmount = ztAmount * 965936329 / 10**9; } } return ztAmount; }",
        "vulnerability": "integer overflow",
        "reason": "The toZT function does not properly check for integer overflows when calculating the ztAmount. Large values of _wei or the iterative multiplication could cause an overflow, resulting in incorrect token amounts being issued.",
        "file_name": "0xaf7aea249098f2c2f50cc11d4000ccf798194373.sol"
    }
]