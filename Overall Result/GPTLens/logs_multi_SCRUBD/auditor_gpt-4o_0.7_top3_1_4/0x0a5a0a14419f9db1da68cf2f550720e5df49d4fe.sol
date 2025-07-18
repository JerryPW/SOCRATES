[
    {
        "function_name": "claimYzyReward",
        "code": "function claimYzyReward() public returns (bool) { (uint256 available, uint256 pending) = getYzyReward(_msgSender()); require(available > 0 || pending > 0, \"Vault: No rewards\"); StakerInfo storage staker = _stakers[_msgSender()]; if (available > 0) { require( safeYzyTransfer(_msgSender(), available), \"Vault: Failed to transfer.\" ); } if (pending > 0) { uint256 burnAmount = pending.mul(_burnFee).div(10000); _yzy.burnFromVault(burnAmount); safeYzyTransfer(_msgSender(), pending.sub(burnAmount)); staker.lastClimedBlockForYzyReward = block.number; } else if (available > 0) { staker.lastClimedBlockForYzyReward = _getLastAvailableClaimedBlock( staker.lastClimedBlockForYzyReward, block.number, _claimPeriodForYzyReward ); } emit ClaimedYzyReward(_msgSender(), available, pending); return _sendLotteryAmount(); }",
        "vulnerability": "Reentrancy",
        "reason": "The `claimYzyReward` function transfers tokens to the user and then updates the state variable `lastClimedBlockForYzyReward`. This sequence allows for potential reentrancy attacks where an attacker can re-enter the function before the state is updated, allowing them to claim rewards multiple times.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "stake",
        "code": "function stake() external payable returns (bool) { require(!isContract(_msgSender()), \"Vault: Could not be contract.\"); require(msg.value >= _minDepositETHAmount, \"Vault: insufficient staking amount.\"); uint256 initialBalance = _yzyETHV2Pair.balanceOf(address(this)); require(swapAndLiquifyForYZY(msg.value), \"Vault: Failed to get LP tokens.\"); uint256 newBalance = _yzyETHV2Pair.balanceOf(address(this)).sub(initialBalance); StakerInfo storage staker = _stakers[_msgSender()]; if (staker.stakedAmount > 0) { claimYzyReward(); claimSwapReward(); } else { staker.lastClimedBlockForYzyReward = block.number; staker.lastClimedBlockForSwapReward = block.number; } staker.stakedAmount = staker.stakedAmount.add(newBalance); staker.lockedTo = _lockPeriod.add(block.timestamp); emit Staked(_msgSender(), newBalance); return _sendLotteryAmount(); }",
        "vulnerability": "Reentrancy",
        "reason": "The `stake` function calls `claimYzyReward` and `claimSwapReward`, both of which involve external calls to transfer funds before updating state variables. This sequence can be exploited through reentrancy to manipulate rewards or staking amounts.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "emergencyWithdrawToken",
        "code": "function emergencyWithdrawToken() external onlyOwner { require(_msgSender() != address(0), \"Vault: Invalid address\"); uint256 tokenAmount = _yzy.balanceOf(address(this)); require(tokenAmount > 0, \"Vault: Insufficient amount\"); _yzy.transfer(_msgSender(), tokenAmount); emit EmergencyWithdrawToken(address(this), _msgSender(), tokenAmount); }",
        "vulnerability": "Privilege Escalation",
        "reason": "The `emergencyWithdrawToken` function allows the owner to withdraw all YZY tokens from the contract without any restrictions. If the owner's private key is compromised, an attacker could drain all tokens from the contract.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    }
]