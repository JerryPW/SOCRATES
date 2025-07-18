[
    {
        "function_name": "userRefund",
        "code": "function userRefund() public returns(bool _result) { return _userRefund(msg.sender); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `userRefund` function calls `_userRefund`, which transfers Ether to the caller before setting the user balance to zero. This allows for a reentrancy attack, where a malicious actor can call `userRefund` recursively and drain the contract's funds before their balance is updated.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "_getAward",
        "code": "function _getAward(uint _playNo) private returns(bool _result){ require(_playNo < playNo); _result = false; betInfo storage bi = playerBetInfoOf[_playNo]; require(block.number > bi.BlockNumber); require(!bi.IsReturnAward); lock(); uint awardNum = 0; uint256 awardAmount = 0; uint256 totalBetAmount = 0; uint256 maxBetAmount = 0; uint256 totalAmount = 0; for(uint i=0;i <bi.BetNums.length;i++){ if(bi.BetAmounts[i] > maxBetAmount){ maxBetAmount = bi.BetAmounts[i]; } totalBetAmount = totalBetAmount.add(bi.BetAmounts[i]); } totalAmount = maxBetAmount.mul(winMultiplePer).div(100); if(totalBetAmount >= totalAmount){ totalAmount = totalBetAmount; } if(bi.BlockNumber.add(256) >= block.number){ uint256 randomNum = bi.EventId%1000000; bytes32 encrptyHash = keccak256(bi.Player,block.blockhash(bi.BlockNumber),uintToString(randomNum)); awardNum = uint(encrptyHash)%22; awardNum = awardNum.add(1); bi.AwardNum = awardNum; for(uint n=0;n <bi.BetNums.length;n++){ if(bi.BetNums[n] == awardNum){ awardAmount = bi.BetAmounts[n].mul(winMultiplePer).div(100); bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[bi.Player] = userEtherOf[bi.Player].add(awardAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount.sub(awardAmount)); break; } } } if(!bi.IsReturnAward){ bi.IsReturnAward = true; userEtherOf[this] = userEtherOf[this].sub(totalAmount); userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount); } emit OnGetAward(bi.Player,_playNo,bi.BetNums,bi.BlockNumber,bi.BetAmounts,getEventId(),awardNum,awardAmount); _result = true; unLock(); }",
        "vulnerability": "Predictable randomness",
        "reason": "The `_getAward` function uses block hashes and timestamps to generate random numbers. These values can be manipulated by miners, allowing them to predict or influence the outcome of the randomness, potentially leading to unfair advantages or exploitation.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    },
    {
        "function_name": "uintToString",
        "code": "function uintToString(uint v) private pure returns (string) { uint maxlength = 10; bytes memory reversed = new bytes(maxlength); uint i = 0; while (v != 0) { uint remainder = v % 10; v = v / 10; reversed[i++] = byte(48 + remainder); } bytes memory s = new bytes(i); for (uint j = 0; j < i; j++) { s[j] = reversed[i - j - 1]; } string memory str = string(s); return str; }",
        "vulnerability": "Gas inefficiency and incorrect assumptions",
        "reason": "The `uintToString` function assumes a maximum of 10 digits for any uint, which is incorrect for large numbers. This can lead to incorrect string conversions, and the function's logic is gas-inefficient due to multiple memory allocations and loops. This inefficiency could affect contract performance and gas costs.",
        "file_name": "0x0a28dd8141394e6d680d20d54ffeb3544b576a78.sol"
    }
]