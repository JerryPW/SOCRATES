[
    {
        "function_name": "ETHsend",
        "code": "function ETHsend(uint256 userAmount, uint256 userNum) public payable { require(secondaryUserLock[msg.sender] == false); secondaryUserLock[msg.sender] = true; require(userAmount <= ethAmount[key[msg.sender]]); require(userAmount > 1); require(ethAmount[key[msg.sender]] > 1); totalETH -= userAmount; ethAmount[key[msg.sender]] -= userAmount; buccTransfer = BuccV2(v2Address); require(!KeyLock()); address payable lookUP = payable(buccTransfer.findUser(userNum)); require(lookUP != 0x0000000000000000000000000000000000000000, \"Address not added to contract.\"); keylock = now; lookUP.transfer(userAmount); buccTransfer.specialTransfer(userNum, 0); secondaryUserLock[msg.sender] = false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether before updating the secondaryUserLock state, which can be exploited through reentrancy by the recipient to call back into the contract, potentially altering the contract's state in an unintended manner.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _pid, uint256 input) public { require(userLock[msg.sender] == false); userLock[msg.sender] = true; PoolInfo storage pool = poolInfo[_pid]; UserInfo storage user = userInfo[_pid][msg.sender]; require(user.amount >= input, \"withdraw: not good\"); hasJoined[msg.sender] = false; fellowBuccaneers -= 1; updatePool(_pid); uint256 collectRewards = user.amount.mul(pool.accBuccMultiplierEarned).div(1e12).sub(user.rewardDebt); require(collectRewards <= contractTokens, \"Not enough tokens\"); secretBUCCTransfer(collectRewards); contractTokens -= collectRewards; user.amount = user.amount.sub(input); user.rewardDebt = user.amount.mul(pool.accBuccMultiplierEarned).div(1e12); pool.lpToken.safeTransfer(address(msg.sender), input); userLock[msg.sender] = false; }",
        "vulnerability": "Integer underflow in rewards calculation",
        "reason": "The subtraction operation `user.amount.mul(pool.accBuccMultiplierEarned).div(1e12).sub(user.rewardDebt)` may lead to an integer underflow if `user.rewardDebt` is greater than the calculated reward amount, which can cause incorrect reward distributions.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    },
    {
        "function_name": "sendtoRecipient",
        "code": "function sendtoRecipient(uint256 userNum, uint256 _amount) internal { buccTransfer = BuccV2(v2Address); uint256 buccBal = buccTransfer.balanceOf(address(this)); require(userNum != 0, \"Address not added to contract.\"); require(_amount < contractTokens, \"Not enough tokens\"); if (_amount > buccBal) { buccTransfer.specialTransfer(userNum, buccBal); contractTokens = 0; } else { buccTransfer.specialTransfer(userNum, _amount); contractTokens -= _amount; } }",
        "vulnerability": "Contract balance inconsistency",
        "reason": "The function does not correctly handle the case where `_amount` could be more than `contractTokens`, leading to potential inconsistencies between the actual balance and the contract's bookkeeping, which can be exploited by attackers to withdraw more tokens than they are entitled to.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    }
]