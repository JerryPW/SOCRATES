[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Potential unauthorized access",
        "reason": "The `transferOwnership` function doesn't reset the authorization status of the previous owner, which could lead to unauthorized access if the previous owner still has actions that require authorization.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "_transferFrom",
        "code": "function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) { if(inSwap){ return _basicTransfer(sender, recipient, amount); } if(!authorizations[sender] && !authorizations[recipient]){ require(tradingActive,\"Trading not open yet\"); } if(blacklistMode){ require(!isBlacklisted[sender] && !isBlacklisted[recipient],\"Blacklisted\"); } if(block.number <= launchBlock + deadBlocks && sender == address(pair) && recipient != address(router) && recipient != address(this) && recipient != address(pair)){ isBlacklisted[recipient] = true; emit BoughtEarly(recipient); } if (!authorizations[sender] && recipient != address(this) && recipient != address(DEAD) && recipient != pair && recipient != marketingFeeReceiver && recipient != devFeeReceiver && recipient != autoLiquidityReceiver){ uint256 heldTokens = balanceOf(recipient); require((heldTokens + amount) <= _maxWalletToken,\"Total Holding is currently limited, you can not buy that much.\");} if (sender == pair && buyCooldownEnabled && !isTimelockExempt[recipient]) { require(cooldownTimer[recipient] < block.timestamp,\"Please wait for 1min between two buys\"); cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval; } checkTxLimit(sender, amount); if(shouldSwapBack()){ swapBack(); } _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\"); uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount,(recipient == pair)) : amount; _balances[recipient] = _balances[recipient].add(amountReceived); if(!isDividendExempt[sender]) { try distributor.setShare(sender, _balances[sender]) {} catch {} } if(!isDividendExempt[recipient]) { try distributor.setShare(recipient, _balances[recipient]) {} catch {} } try distributor.process(distributorGas) {} catch {} emit Transfer(sender, recipient, amountReceived); return true; }",
        "vulnerability": "Potential denial of service through blacklisting",
        "reason": "The function blacklists recipients during the first few blocks after launch if they buy tokens. This could be exploited by a malicious actor who could force many addresses to be blacklisted, potentially blocking legitimate users from transacting.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "clearStuckBalance",
        "code": "function clearStuckBalance(uint256 amountPercentage) external authorized { uint256 amountETH = address(this).balance; payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100); }",
        "vulnerability": "Potential misuse by authorized accounts",
        "reason": "The `clearStuckBalance` function allows any authorized address to withdraw a percentage of the contract's balance to the marketing fee receiver. If an unauthorized account gains authorization, they could drain the contract's funds.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    }
]