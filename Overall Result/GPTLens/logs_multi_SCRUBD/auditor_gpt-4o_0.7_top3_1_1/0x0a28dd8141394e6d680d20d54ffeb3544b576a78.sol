[
    {
        "function_name": "userRefund",
        "code": "function userRefund() public returns(bool _result) { return _userRefund(msg.sender); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The userRefund function is vulnerable to reentrancy attacks because it transfers Ether to the caller before updating the state. An attacker can exploit this by recursively calling userRefund to drain the contract's balance. The lock() mechanism does not protect against reentrancy as it is unset after the transfer.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "_getAward",
        "code": "function _getAward(uint _playNo) private returns(bool _result){ require(_playNo < playNo); _result = false; betInfo storage bi = playerBetInfoOf[_playNo]; require(block.number > bi.BlockNumber); require(!bi.IsReturnAward); lock(); uint awardNum = 0; uint256 awardAmount = 0; uint256 totalBetAmount = 0; uint256 maxBetAmount = 0; uint256 totalAmount = 0; for(uint i=0;i <bi.BetNums.length;i++){ if(bi.BetAmounts[i] > maxBetAmount){ maxBetAmount = bi.BetAmounts[i]; } totalBetAmount = totalBetAmount.add(bi.BetAmounts[i]); } totalAmount = maxBetAmount.mul(winMultiplePer).div(100); if(totalBetAmount >= totalAmount){ totalAmount = totalBetAmount; } if(bi.BlockNumber.add(256) >= block.number){ uint256 randomNum = bi.EventId%1000000; bytes32 encrptyHash = keccak256(bi.Player,block.blockhash(bi.BlockNumber),uintToString(randomNum)); awardNum = uint(encrptyHash)%22; awardNum = awardNum.add(1); bi.AwardNum = awardNum; for(uint n=0;n <bi.BetNums.length;n++){ if(bi.BetNums[n] == awardNum){ awardAmount = bi.BetAmounts[n].mul(winMultiplePer).div(100); bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[bi.Player] = userEtherOf[bi.Player].add(awardAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount.sub(awardAmount)); break; } } } if(!bi.IsReturnAward){ bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount); } emit OnGetAward(bi.Player,_playNo,bi.BetNums,bi.BlockNumber,bi.BetAmounts,getEventId(),awardNum,awardAmount); _result = true; unLock(); }",
        "vulnerability": "Predictable randomness",
        "reason": "The function uses block.blockhash and other predictable inputs to generate randomness. This can be manipulated by miners to their advantage, allowing them to predict the outcome of the award mechanism and potentially gain an unfair advantage.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "calLoanAmount",
        "code": "function calLoanAmount() public view returns (uint256 _result){ _result = 0; if(currentLoanPerson != 0x0 && currentLoanAmount > 0){ _result = currentLoanAmount; uint d = now.sub(currentLoanDayTime).div(1 days); for(uint i = 0; i < d; i++){ _result = _result.mul(currentDayRate10000.add(10000)).div(10000); } } }",
        "vulnerability": "Arithmetic overflow",
        "reason": "The function calLoanAmount has a potential overflow issue when calculating the loan amount over time. If the duration is large enough, the multiplication in the loop can lead to an overflow, resulting in incorrect calculations of the loan amount.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    }
]