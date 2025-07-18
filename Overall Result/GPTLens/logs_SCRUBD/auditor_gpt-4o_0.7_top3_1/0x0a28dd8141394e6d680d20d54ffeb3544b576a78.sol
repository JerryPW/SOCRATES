[
    {
        "function_name": "getAward",
        "code": "function getAward(uint[] _playNos) public returns(bool _result){ require(_playNos.length > 0); _result = false; for(uint i = 0;i < _playNos.length;i++){ _result = _getAward(_playNos[i]); } }",
        "vulnerability": "Blockhash-based randomness vulnerability",
        "reason": "The function getAward relies on blockhash to generate randomness, which can be manipulated by miners since they can control block parameters. This makes it possible for miners to influence the outcome of the award process, potentially allowing them to unfairly win bets or manipulate the game's results.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "_userRefund",
        "code": "function _userRefund(address _to) internal returns(bool _result){ require (_to != 0x0); _result = false; lock(); uint256 amount = userEtherOf[msg.sender]; if(amount > 0){ if(msg.sender == shareholder){ checkPayShareholder(); } else{ userEtherOf[msg.sender] = 0; _to.transfer(amount); } _result = true; } else{ _result = false; } unLock(); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The _userRefund function is vulnerable to reentrancy attacks because it transfers Ether before updating the user's balance. An attacker could exploit this by recursively calling the userRefund function before the userEtherOf[msg.sender] is set to 0, draining all the funds associated with their account.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "checkPayLoan",
        "code": "function checkPayLoan() public returns (bool _result) { _result = false; uint256 toLoan = calLoanAmount(); if(toLoan > 0){ if(isStopPlay && now > stopTime.add(1 days)){ if(toLoan > userEtherOf[shareholder]){ toLoan = userEtherOf[shareholder]; userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan); userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan); } else{ userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan); userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan); } currentLoanPerson = 0x0; currentDayRate10000 = 0; currentLoanAmount = 0; currentLoanDayTime = now; _result = true; emit OnPayLoan(msg.sender, now, toLoan); return; } if (userEtherOf[shareholder] >= minBankerEther.add(toLoan)){ userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan); userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan); currentLoanPerson = 0x0; currentDayRate10000 = 0; currentLoanAmount = 0; currentLoanDayTime = now; _result = true; emit OnPayLoan(msg.sender,now,toLoan); return; } } }",
        "vulnerability": "Integer overflow/underflow vulnerability",
        "reason": "The checkPayLoan function does not use SafeMath for arithmetic operations, particularly when updating balances and calculating loan amounts. This could lead to integer overflow/underflow, allowing attackers to manipulate loan amounts or balances, potentially leading to large, unintended payouts or incorrect state changes.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    }
]