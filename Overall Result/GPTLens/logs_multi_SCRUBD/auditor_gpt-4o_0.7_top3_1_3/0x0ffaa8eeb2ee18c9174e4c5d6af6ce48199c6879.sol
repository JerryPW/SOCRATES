[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _pid, uint256 input) public { require(userLock[msg.sender] == false); userLock[msg.sender] = true; PoolInfo storage pool = poolInfo[_pid]; UserInfo storage user = userInfo[_pid][msg.sender]; require(user.amount >= input, \"withdraw: not good\"); hasJoined[msg.sender] = false; fellowBuccaneers -= 1; updatePool(_pid); uint256 collectRewards = user.amount.mul(pool.accBuccMultiplierEarned).div(1e12).sub(user.rewardDebt); require(collectRewards <= contractTokens, \"Not enough tokens\"); secretBUCCTransfer(collectRewards); contractTokens -= collectRewards; user.amount = user.amount.sub(input); user.rewardDebt = user.amount.mul(pool.accBuccMultiplierEarned).div(1e12); pool.lpToken.safeTransfer(address(msg.sender), input); userLock[msg.sender] = false; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function does not follow the checks-effects-interactions pattern. The `safeTransfer` function of the `pool.lpToken` is called before updating the `user.amount` and setting the `userLock[msg.sender]` to false. This allows an attacker to reenter the function and perform actions multiple times, potentially draining the contract.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    },
    {
        "function_name": "addContractTokens",
        "code": "function addContractTokens(uint256 amount) public { buccTransfer = BuccV2(v2Address); buccTransfer.transferFrom(msg.sender, address(this), amount); contractTokens += amount; }",
        "vulnerability": "Missing Authorization Check",
        "reason": "There is no authorization check for this function, allowing any user to call it and potentially interfere with the token balance logic. An attacker could call this function to manipulate the `contractTokens` balance without restrictions.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    },
    {
        "function_name": "sendtoRecipient",
        "code": "function sendtoRecipient(uint256 userNum, uint256 _amount) internal { buccTransfer = BuccV2(v2Address); uint256 buccBal = buccTransfer.balanceOf(address(this)); require(userNum != 0, \"Address not added to contract.\"); require(_amount < contractTokens, \"Not enough tokens\"); if (_amount > buccBal) { buccTransfer.specialTransfer(userNum, buccBal); contractTokens = 0; } else { buccTransfer.specialTransfer(userNum, _amount); contractTokens -= _amount; } }",
        "vulnerability": "Unchecked Address Validity",
        "reason": "The function does not properly handle cases where the `userNum` does not correspond to a valid address or is manipulated. This could lead to funds being sent to an unintended or malicious address, resulting in a loss of tokens. The validity of `userNum` is only superficially checked, increasing the risk of exploitation.",
        "file_name": "0x0ffaa8eeb2ee18c9174e4c5d6af6ce48199c6879.sol"
    }
]