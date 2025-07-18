[
    {
        "function_name": "emergencyWithdraw",
        "code": "function emergencyWithdraw(uint amount) external noContractsAllowed nonReentrant payable { require(amount > 0, \"invalid amount!\"); require(amount <= depositTokenBalance[msg.sender], \"Cannot withdraw more than deposited!\"); require(block.timestamp.sub(depositTime[msg.sender]) > LOCKUP_DURATION, \"You recently deposited, please wait before withdrawing.\"); updateAccount(msg.sender); depositTokenBalance[msg.sender] = depositTokenBalance[msg.sender].sub(amount); totalDepositedTokens = totalDepositedTokens.sub(amount); uint oldCTokenBalance = IERC20(TRUSTED_CTOKEN_ADDRESS).balanceOf(address(this)); uint oldEtherBalance = address(this).balance; require(CEther(TRUSTED_CTOKEN_ADDRESS).redeemUnderlying(amount) == 0, \"redeemUnderlying failed!\"); uint newCTokenBalance = IERC20(TRUSTED_CTOKEN_ADDRESS).balanceOf(address(this)); uint newEtherBalance = address(this).balance; uint depositTokenReceived = newEtherBalance.sub(oldEtherBalance); uint cTokenRedeemed = oldCTokenBalance.sub(newCTokenBalance); IWETH(TRUSTED_DEPOSIT_TOKEN_ADDRESS).deposit{value: depositTokenReceived}(); require(cTokenRedeemed <= cTokenBalance[msg.sender], \"redeem exceeds balance!\"); cTokenBalance[msg.sender] = cTokenBalance[msg.sender].sub(cTokenRedeemed); totalCTokens = totalCTokens.sub(cTokenRedeemed); decreaseTokenBalance(TRUSTED_CTOKEN_ADDRESS, cTokenRedeemed); totalTokensWithdrawnByUser[msg.sender] = totalTokensWithdrawnByUser[msg.sender].add(depositTokenReceived); uint feeAmount = depositTokenReceived.mul(FEE_PERCENT_X_100).div(ONE_HUNDRED_X_100); uint depositTokenReceivedAfterFee = depositTokenReceived.sub(feeAmount); IERC20(TRUSTED_DEPOSIT_TOKEN_ADDRESS).safeTransfer(msg.sender, depositTokenReceivedAfterFee); if (depositTokenBalance[msg.sender] == 0) { holders.remove(msg.sender); } emit Withdraw(msg.sender, depositTokenReceived); }",
        "vulnerability": "Fee not handled",
        "reason": "The function does not handle the fee by calling the 'handleFee' and 'handleEthFee' functions as seen in the normal 'withdraw' function. This could potentially result in incorrect fee distribution and economic loss.",
        "file_name": "0x01de5bce5c5ee4f92e8f4183f6f4e4f12f9a86cd.sol"
    },
    {
        "function_name": "claimAnyToken",
        "code": "function claimAnyToken(address token, uint amount) external onlyOwner { require(now > contractStartTime.add(ADMIN_CAN_CLAIM_AFTER), \"Contract not expired yet!\"); if (token == address(0)) { msg.sender.transfer(amount); return; } IERC20(token).safeTransfer(msg.sender, amount); }",
        "vulnerability": "Inadequate access control and potential theft",
        "reason": "Although the function is restricted to the owner, it allows the owner to withdraw any tokens from the contract after a certain period. This could be abused to withdraw all funds from the contract, including those belonging to users, leading to a complete loss of user funds.",
        "file_name": "0x01de5bce5c5ee4f92e8f4183f6f4e4f12f9a86cd.sol"
    },
    {
        "function_name": "distributeEthDivs",
        "code": "function distributeEthDivs(uint amount) private { if (totalDepositedTokens == 0) return; totalEthDivPoints = totalEthDivPoints.add(amount.mul(POINT_MULTIPLIER).div(totalDepositedTokens)); totalEthDisbursed = totalEthDisbursed.add(amount); increaseTokenBalance(address(0), amount); emit EtherRewardDisbursed(amount); }",
        "vulnerability": "Incorrect handling of zero balance scenario",
        "reason": "The function does not handle the case where 'totalDepositedTokens' is zero. This can lead to division by zero errors or incorrect calculations, potentially allowing an attacker to manipulate dividend distributions when no tokens are deposited.",
        "file_name": "0x01de5bce5c5ee4f92e8f4183f6f4e4f12f9a86cd.sol"
    }
]