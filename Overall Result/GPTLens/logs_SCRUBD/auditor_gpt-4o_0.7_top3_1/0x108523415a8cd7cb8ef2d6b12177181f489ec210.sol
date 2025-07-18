[
    {
        "function_name": "setIsLimitExempt",
        "code": "function setIsLimitExempt(address[] memory holders, bool exempt) external onlyOwner { for (uint256 i; i < holders.length; i++) { isLimitExmpt[holders[i]] = exempt; } }",
        "vulnerability": "Gas Limit and Block Size Attack",
        "reason": "The function allows the owner to set multiple addresses as limit-exempt in a single transaction. If the 'holders' array is too large, it could exceed the block gas limit, causing the transaction to fail. This could be exploited by an attacker who sends a large list of addresses, potentially causing a denial of service.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "removeBots",
        "code": "function removeBots(address[] memory accounts) external onlyOwner { for (uint256 i; i < accounts.length; i++) { isBot[accounts[i]] = false; } }",
        "vulnerability": "Gas Limit and Block Size Attack",
        "reason": "Similar to the setIsLimitExempt function, removeBots allows the owner to process a large list of addresses. If the 'accounts' array is too large, it could exceed the block gas limit, causing the transaction to fail. This could be exploited by an attacker to create a denial of service scenario.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 totalFee = _liquidityFeeCount.add(_reflectionFeeCount); uint256 amountToLiquify = swapThreshold.mul(_liquidityFeeCount).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); _allowances[address(this)][address(router)] = _totalSupply; address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToSwap, 0, path, address(this), block.timestamp); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 totalBNBFee = totalFee.sub(_liquidityFeeCount.div(2)); uint256 amountBNBLiquidity = amountBNB.mul(_liquidityFeeCount).div(totalBNBFee).div(2); if (amountToLiquify > 0) { router.addLiquidityETH{value: amountBNBLiquidity}(address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp); emit AutoLiquify(amountBNBLiquidity, amountToLiquify); } uint256 amountBNBReflection = amountBNB.mul(_reflectionFeeCount).div(totalBNBFee); if (amountBNBReflection > 0) { try distributor.deposit{value: amountBNBReflection}() {} catch {} } _liquidityFeeCount = 0; _reflectionFeeCount = 0; }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The swapBack function involves multiple external calls to the router contract. If the router or any of its dependencies are compromised or malicious, they could potentially re-enter the contract during the swap or liquidity addition process, causing unexpected behavior or loss of funds.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    }
]