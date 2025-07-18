[
    {
        "function_name": "userRefund",
        "code": "function userRefund() public returns(bool _result) { return _userRefund(msg.sender); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The userRefund function calls _userRefund which transfers ether before updating the user's balance. An attacker can exploit this by reentering the function before the balance is set to zero, allowing multiple withdrawals.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "setLock",
        "code": "function setLock() public onlyOwner{ globalLocked = false; }",
        "vulnerability": "Incorrect locking mechanism",
        "reason": "The setLock function allows the owner to set globalLocked to false, which contradicts the lock mechanism intended to prevent reentrancy. This can be called during any operation to enable reentrancy attacks.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "_getAward",
        "code": "function _getAward(uint _playNo) private returns(bool _result){ require(_playNo < playNo); _result = false; betInfo storage bi = playerBetInfoOf[_playNo]; require(block.number > bi.BlockNumber); require(!bi.IsReturnAward); lock(); uint awardNum = 0; uint256 awardAmount = 0; uint256 totalBetAmount = 0; uint256 maxBetAmount = 0; uint256 totalAmount = 0; for(uint i=0;i <bi.BetNums.length;i++){ if(bi.BetAmounts[i] > maxBetAmount){ maxBetAmount = bi.BetAmounts[i]; } totalBetAmount = totalBetAmount.add(bi.BetAmounts[i]); } totalAmount = maxBetAmount.mul(winMultiplePer).div(100); if(totalBetAmount >= totalAmount){ totalAmount = totalBetAmount; } if(bi.BlockNumber.add(256) >= block.number){ uint256 randomNum = bi.EventId%1000000; bytes32 encrptyHash = keccak256(bi.Player,block.blockhash(bi.BlockNumber),uintToString(randomNum)); awardNum = uint(encrptyHash)%22; awardNum = awardNum.add(1); bi.AwardNum = awardNum; for(uint n=0;n <bi.BetNums.length;n++){ if(bi.BetNums[n] == awardNum){ awardAmount = bi.BetAmounts[n].mul(winMultiplePer).div(100); bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[bi.Player] = userEtherOf[bi.Player].add(awardAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount.sub(awardAmount)); break; } } } if(!bi.IsReturnAward){ bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount); } emit OnGetAward(bi.Player,_playNo,bi.BetNums,bi.BlockNumber,bi.BetAmounts,getEventId(),awardNum,awardAmount); _result = true; unLock(); }",
        "vulnerability": "Blockhash dependency vulnerability",
        "reason": "The _getAward function uses block.blockhash for randomness. This is predictable for the last 256 blocks, allowing miners to influence the outcome of the award determination.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    }
]