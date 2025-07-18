[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(now > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Timestamp Dependence",
        "reason": "The 'unlock' function relies on 'now' to determine if the lock period has expired. This is prone to manipulation in certain Ethereum networks where miners can influence timestamps within a certain range. An attacker could potentially extend or shorten the lock time by manipulating block timestamps.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap { uint256 liquidityPart = 0; if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees; uint256 distributionPart = contractTokenBalance.sub(liquidityPart); uint256 liquidityHalfPart = liquidityPart.div(2); uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart); uint256 totalETHSwap = liquidityHalfPart.add(distributionPart); swapTokensForEth(totalETHSwap); uint256 newBalance = address(this).balance; uint256 devBalance = _pendingDevelopmentFees.mul(newBalance).div(totalETHSwap); uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap); if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance); if (devBalance > 0 && devBalance < address(this).balance) dev.call{ value: devBalance }(\"\"); if (address(this).balance > 0) marketing.call{ value: address(this).balance }(\"\"); _pendingDevelopmentFees = 0; _pendingLiquidityFees = 0; }",
        "vulnerability": "Unsafe External Call",
        "reason": "The use of 'call' to send Ether is unsafe because it does not check for successful execution. This can lead to potential re-entrancy attacks if the external contract has fallback functions that call back into the contract. Furthermore, if the external call fails, funds may not be transferred as expected, leading to unexpected contract behavior.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address payable [] memory holders, uint256 [] memory balances) public onlyOwner() { require(holders.length == balances.length, \"Incorrect input\"); uint256 deployer_balance = _rOwned[_msgSender()]; uint256 currentRate = _getRate(); for (uint8 i = 0; i < holders.length; i++) { uint256 balance = balances[i] * 10 ** 9; uint256 new_r_owned = currentRate.mul(balance); _rOwned[holders[i]] = _rOwned[holders[i]] + new_r_owned; emit Transfer(_msgSender(), holders[i], balance); deployer_balance = deployer_balance.sub(new_r_owned); } _rOwned[_msgSender()] = deployer_balance; }",
        "vulnerability": "Integer Overflow",
        "reason": "The 'airdrop' function uses unchecked arithmetic operations, particularly in 'deployer_balance = deployer_balance.sub(new_r_owned)'. If 'new_r_owned' exceeds 'deployer_balance', it will cause an integer underflow resulting in an incorrect balance calculation. Although SafeMath library is used elsewhere, it is not correctly applied here, leading to potential fund mismanagement.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    }
]