[
    {
        "function_name": "emergencyWithdrawToken",
        "code": "function emergencyWithdrawToken() external onlyOwner { require(_msgSender() != address(0), \"Vault: Invalid address\"); uint256 tokenAmount = _yzy.balanceOf(address(this)); require(tokenAmount > 0, \"Vault: Insufficient amount\"); _yzy.transfer(_msgSender(), tokenAmount); emit EmergencyWithdrawToken(address(this), _msgSender(), tokenAmount); }",
        "vulnerability": "Owner can drain all funds",
        "reason": "The emergencyWithdrawToken function allows the owner to transfer all YZY tokens from the contract to their own address. This centralizes control and poses a significant risk to all stakers, as the owner could maliciously or accidentally drain all funds, leading to a total loss for the stakers.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "_sendLotteryAmount",
        "code": "function _sendLotteryAmount() internal returns (bool) { if (!_enabledLottery || _lotteryAmount <= 0) return false; uint256 usdcReserve = 0; uint256 ethReserve1 = 0; uint256 yzyReserve = 0; uint256 ethReserve2 = 0; address token0 = _usdcETHV2Pair.token0(); if (token0 == address(_weth)){ (ethReserve1, usdcReserve, ) = _usdcETHV2Pair.getReserves(); } else { (usdcReserve, ethReserve1, ) = _usdcETHV2Pair.getReserves(); } token0 = _yzyETHV2Pair.token0(); if (token0 == address(_weth)){ (ethReserve2, yzyReserve, ) = _yzyETHV2Pair.getReserves(); } else { (yzyReserve, ethReserve2, ) = _yzyETHV2Pair.getReserves(); } if (ethReserve1 <= 0 || yzyReserve <= 0) return false; uint256 yzyPrice = usdcReserve.mul(1 ether).div(ethReserve1).mul(ethReserve2).div(yzyReserve); uint256 lotteryValue = yzyPrice.mul(_lotteryAmount).div(1 ether); if (lotteryValue > 0 && lotteryValue >= _lotteryLimit) { uint256 amount = _lotteryLimit.mul(1 ether).div(yzyPrice); if (amount > _lotteryAmount) amount = _lotteryAmount; _yzy.transfer(_msgSender(), amount); _lotteryAmount = _lotteryAmount.sub(amount); _lotteryPaidOut = _lotteryPaidOut.add(amount); emit SentLotteryAmount(_msgSender(), amount, true); winnerInfo.push( WinnerInfo({ winner: _msgSender(), amount: amount, timestamp: block.timestamp }) ); } return false; }",
        "vulnerability": "Potential reentrancy issue",
        "reason": "The _sendLotteryAmount function involves multiple state changes after an external call to transfer tokens. If a malicious contract is used as the recipient, it could call back into the contract before the state changes are finalized, potentially exploiting the function to win multiple lottery rounds or manipulate balances.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    },
    {
        "function_name": "stake",
        "code": "function stake() external payable returns (bool) { require(!isContract(_msgSender()), \"Vault: Could not be contract.\"); require(msg.value >= _minDepositETHAmount, \"Vault: insufficient staking amount.\"); uint256 initialBalance = _yzyETHV2Pair.balanceOf(address(this)); require(swapAndLiquifyForYZY(msg.value), \"Vault: Failed to get LP tokens.\"); uint256 newBalance = _yzyETHV2Pair.balanceOf(address(this)).sub(initialBalance); StakerInfo storage staker = _stakers[_msgSender()]; if (staker.stakedAmount > 0) { claimYzyReward(); claimSwapReward(); } else { staker.lastClimedBlockForYzyReward = block.number; staker.lastClimedBlockForSwapReward = block.number; } staker.stakedAmount = staker.stakedAmount.add(newBalance); staker.lockedTo = _lockPeriod.add(block.timestamp); emit Staked(_msgSender(), newBalance); return _sendLotteryAmount(); }",
        "vulnerability": "Reentrancy risk in staking logic",
        "reason": "The stake function calls swapAndLiquifyForYZY, which performs external calls and then proceeds to update the staker's information. An attacker could exploit this by re-entering the contract through the external calls, potentially manipulating the staking process or draining funds by interrupting the flow before state updates are completed.",
        "file_name": "0x0a5a0a14419f9db1da68cf2f550720e5df49d4fe.sol"
    }
]