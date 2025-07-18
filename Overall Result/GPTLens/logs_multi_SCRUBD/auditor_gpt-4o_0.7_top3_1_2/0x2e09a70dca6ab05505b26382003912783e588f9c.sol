[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual {\n    require(_previousOwner == msg.sender, \"You don't have permission to unlock\");\n    require(now > _lockTime , \"Contract is locked until 7 days\");\n    emit OwnershipTransferred(_owner, _previousOwner);\n    _owner = _previousOwner;\n}",
        "vulnerability": "Time manipulation",
        "reason": "The function uses 'now' which is a deprecated alias for 'block.timestamp'. Miners can manipulate the block timestamp slightly, potentially allowing for early unlocking of the contract. This could be exploited by an attacker to regain ownership of the contract sooner than intended if they are the previous owner.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "airdrop",
        "code": "function airdrop(address payable [] memory holders, uint256 [] memory balances) public onlyOwner() {\n    require(holders.length == balances.length, \"Incorrect input\");\n    uint256 deployer_balance = _rOwned[_msgSender()];\n    uint256 currentRate = _getRate();\n    for (uint8 i = 0; i < holders.length; i++) {\n        uint256 balance = balances[i] * 10 ** 9;\n        uint256 new_r_owned = currentRate.mul(balance);\n        _rOwned[holders[i]] = _rOwned[holders[i]] + new_r_owned;\n        emit Transfer(_msgSender(), holders[i], balance);\n        deployer_balance = deployer_balance.sub(new_r_owned);\n    }\n    _rOwned[_msgSender()] = deployer_balance;\n}",
        "vulnerability": "Lack of validation in airdrop",
        "reason": "The function trusts the input entirely without additional checks, allowing the owner to potentially issue airdrops that exceed their balance. This could lead to an unintended inflation of total tokens held by user wallets, especially if the owner manipulates the 'balances' with very large numbers, potentially resulting in a denial of service or financial inconsistencies.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {\n    uint256 liquidityPart = 0;\n    if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;\n    uint256 distributionPart = contractTokenBalance.sub(liquidityPart);\n    uint256 liquidityHalfPart = liquidityPart.div(2);\n    uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);\n    uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);\n    swapTokensForEth(totalETHSwap);\n    uint256 newBalance = address(this).balance;\n    uint256 devBalance = _pendingDevelopmentFees.mul(newBalance).div(totalETHSwap);\n    uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);\n    if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);\n    if (devBalance > 0 && devBalance < address(this).balance) dev.call{ value: devBalance }(\"\");\n    if (address(this).balance > 0) marketing.call{ value: address(this).balance }(\"\");\n    _pendingDevelopmentFees = 0;\n    _pendingLiquidityFees = 0;\n}",
        "vulnerability": "Unrestricted call to external address",
        "reason": "The function sends remaining ETH to external addresses 'dev' and 'marketing' using low-level 'call' without checks. If these addresses are contracts with fallback/receive functions, they could re-enter and manipulate the contract state. This could result in reentrancy attacks, where an attacker could drain funds or manipulate other parts of the contract logic.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    }
]