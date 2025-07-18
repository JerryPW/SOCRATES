[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Potential Ownership Renouncement",
        "reason": "The 'transferOwnership' function allows the current owner to transfer ownership to any address without restrictions. There is no check to prevent transferring ownership to a zero address, which could lead to a renouncement of ownership and loss of control over the contract. This could be exploited by the owner to renounce ownership unintentionally or maliciously, resulting in the inability to perform critical functions that are restricted to the owner.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee); try distributor.deposit{value: amountETHReflection}() {} catch {} (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}(\"\"); (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHDev, gas: 30000}(\"\"); tmpSuccess = false; if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The 'swapBack' function performs multiple external calls to the router and other addresses to swap tokens and send Ether. Although the function is protected by the 'swapping' modifier, which sets a boolean flag to prevent reentrancy, the external calls within the try-catch blocks could still introduce reentrancy vulnerabilities if not carefully handled. The calls to 'payable' addresses could trigger fallback functions, potentially leading to unexpected behaviors or reentrancy attacks. Additionally, the use of 'gas: 30000' limits the gas for these calls, which may not be sufficient if the fallback function has complex logic.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "blockBots",
        "code": "function blockBots(address[] calldata blockees, bool shouldBlock) external onlyOwner { for(uint256 i = 0;i<blockees.length;i++){ address blockee = blockees[i]; if(blockee != address(this) && blockee != address(router) && blockee != address(pair)) isBlacklisted[blockee] = shouldBlock; } }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The 'blockBots' function allows the owner to block or unblock multiple addresses by adding them to or removing them from a blacklist. However, there is no limit to the number of addresses that can be processed in a single transaction, which could result in exceeding the block gas limit if a large list of addresses is provided. This could be exploited by an attacker to create a denial-of-service condition by submitting a large number of addresses, causing the transaction to fail due to gas constraints.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    }
]