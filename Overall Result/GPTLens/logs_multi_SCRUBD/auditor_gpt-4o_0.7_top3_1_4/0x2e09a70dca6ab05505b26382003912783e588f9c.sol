[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(now > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Time manipulation through `now`",
        "reason": "The use of `now` (which is an alias for `block.timestamp`) to determine lock time can be manipulated by miners. Miners have the ability to slightly adjust timestamps within a block, which could potentially be abused to unlock the contract before the intended lock period is over.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap { uint256 liquidityPart = 0; if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees; uint256 distributionPart = contractTokenBalance.sub(liquidityPart); uint256 liquidityHalfPart = liquidityPart.div(2); uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart); uint256 totalETHSwap = liquidityHalfPart.add(distributionPart); swapTokensForEth(totalETHSwap); uint256 newBalance = address(this).balance; uint256 devBalance = _pendingDevelopmentFees.mul(newBalance).div(totalETHSwap); uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap); if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance); if (devBalance > 0 && devBalance < address(this).balance) dev.call{ value: devBalance }(\"\"); if (address(this).balance > 0) marketing.call{ value: address(this).balance }(\"\"); _pendingDevelopmentFees = 0; _pendingLiquidityFees = 0; }",
        "vulnerability": "Reentrancy with external calls",
        "reason": "The `swapAndLiquify` function makes external calls to `dev` and `marketing` addresses using `.call`. If any of these addresses are a contract, they can reenter into the contract, potentially causing inconsistencies or exploitations. It is important to use a checks-effects-interactions pattern to mitigate this risk.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address payable [] memory holders, uint256 [] memory balances) public onlyOwner() { require(holders.length == balances.length, \"Incorrect input\"); uint256 deployer_balance = _rOwned[_msgSender()]; uint256 currentRate = _getRate(); for (uint8 i = 0; i < holders.length; i++) { uint256 balance = balances[i] * 10 ** 9; uint256 new_r_owned = currentRate.mul(balance); _rOwned[holders[i]] = _rOwned[holders[i]] + new_r_owned; emit Transfer(_msgSender(), holders[i], balance); deployer_balance = deployer_balance.sub(new_r_owned); } _rOwned[_msgSender()] = deployer_balance; }",
        "vulnerability": "Integer overflow with large airdrops",
        "reason": "Using `uint8` for loop iteration in the `airdrop` function can cause an overflow if the `holders` array is larger than 255 elements. This can lead to unexpected behavior or infinite loops if not properly handled.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    }
]