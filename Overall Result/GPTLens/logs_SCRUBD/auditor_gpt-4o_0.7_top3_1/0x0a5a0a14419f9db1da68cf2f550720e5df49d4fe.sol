[
    {
        "function_name": "emergencyWithdrawToken",
        "code": "function emergencyWithdrawToken() external onlyOwner { require(_msgSender() != address(0), \"Vault: Invalid address\"); uint256 tokenAmount = _yzy.balanceOf(address(this)); require(tokenAmount > 0, \"Vault: Insufficient amount\"); _yzy.transfer(_msgSender(), tokenAmount); emit EmergencyWithdrawToken(address(this), _msgSender(), tokenAmount); }",
        "vulnerability": "Owner can drain all tokens",
        "reason": "The `emergencyWithdrawToken` function allows the contract owner to transfer all the `YZY` tokens from the contract to themselves without any restrictions. This is a centralization risk and can lead to a loss of funds for users relying on the contract. An attacker who gains control of the owner account could exploit this to drain the contract.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "stake",
        "code": "function stake() external payable returns (bool) { require(!isContract(_msgSender()), \"Vault: Could not be contract.\"); require(msg.value >= _minDepositETHAmount, \"Vault: insufficient staking amount.\"); uint256 initialBalance = _yzyETHV2Pair.balanceOf(address(this)); require(swapAndLiquifyForYZY(msg.value), \"Vault: Failed to get LP tokens.\"); uint256 newBalance = _yzyETHV2Pair.balanceOf(address(this)).sub(initialBalance); StakerInfo storage staker = _stakers[_msgSender()]; if (staker.stakedAmount > 0) { claimYzyReward(); claimSwapReward(); } else { staker.lastClimedBlockForYzyReward = block.number; staker.lastClimedBlockForSwapReward = block.number; } staker.stakedAmount = staker.stakedAmount.add(newBalance); staker.lockedTo = _lockPeriod.add(block.timestamp); emit Staked(_msgSender(), newBalance); return _sendLotteryAmount(); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `stake` function calls `swapAndLiquifyForYZY`, which involves external calls to the Uniswap router. This can allow for a reentrancy attack if the called contract is malicious. The state updates occur after these external calls, making the contract vulnerable. An attacker could potentially manipulate the staking process by re-entering the contract before the state is fully updated.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "unstake",
        "code": "function unstake(uint256 amount) external returns (bool) { require(!isContract(_msgSender()), \"Vault: Could not be contract.\"); StakerInfo storage staker = _stakers[_msgSender()]; require( staker.stakedAmount > 0 && amount > 0 && amount <= staker.stakedAmount, \"Vault: Invalid amount to unstake.\" ); claimYzyReward(); claimSwapReward(); if (_enabledLock && _stakers[_msgSender()].lockedTo > 0 && block.timestamp < _stakers[_msgSender()].lockedTo ) { uint256 feeAmount = amount.mul(uint256(_earlyUnstakeFee)).div(10000); _yzyETHV2Pair.transfer(_daoTreasury, feeAmount); _yzyETHV2Pair.transfer(_msgSender(), amount.sub(feeAmount)); } else { _yzyETHV2Pair.transfer(_msgSender(), amount); } staker.stakedAmount = staker.stakedAmount.sub(amount); emit Unstaked(_msgSender(), amount); return _sendLotteryAmount(); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to the `stake` function, the `unstake` function also calls external functions (e.g., `claimYzyReward` and transfers) before updating the contract's state. This sequence allows for potential reentrancy attacks where attackers could repeatedly enter the function and manipulate the staked amounts or rewards before the contract state is updated correctly.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    }
]