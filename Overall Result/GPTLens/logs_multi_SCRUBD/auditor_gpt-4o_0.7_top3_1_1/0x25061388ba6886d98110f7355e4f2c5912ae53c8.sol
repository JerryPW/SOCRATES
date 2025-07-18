[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Lack of Ownership Handover Mechanism",
        "reason": "The transferOwnership function allows the current owner to transfer ownership to a new address but does not provide a mechanism for the new owner to accept this transfer. This can lead to scenarios where ownership is transferred to an incorrect address or a contract that cannot interact with the function, potentially locking the contract in an unusable state. Additionally, upon transferring ownership, the new owner is automatically authorized without any verification process, which could be exploited if the new owner address is compromised.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "blockBots",
        "code": "function blockBots(address[] calldata blockees, bool shouldBlock) external onlyOwner { for(uint256 i = 0;i<blockees.length;i++){ address blockee = blockees[i]; if(blockee != address(this) && blockee != address(router) && blockee != address(pair)) isBlacklisted[blockee] = shouldBlock; } }",
        "vulnerability": "Centralized Blacklist Control",
        "reason": "The blockBots function gives the contract owner the capability to blacklist any address, preventing them from interacting with the contract. This centralized control can be exploited by a malicious owner to censor users or manipulate contract interactions. Such a design is contrary to the principles of decentralization and can undermine user trust in the contract.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee); try distributor.deposit{value: amountETHReflection}() {} catch {} (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}(\"\"); (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHDev, gas: 30000}(\"\"); tmpSuccess = false; if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Potential Reentrancy via Liquidity Addition",
        "reason": "The swapBack function contains a call to addLiquidityETH, which involves transferring ETH back to the contract through a router. This operation can be exploited for reentrancy if the external contract (router) is malicious or interacts with another malicious contract. Although the function uses a swapping modifier to prevent reentrancy on this specific function, it does not protect against reentrancy across other functions. If any function that affects the state of the contract is called before the liquidity is added, it may lead to unexpected contract behavior. It is advisable to follow the checks-effects-interactions pattern to mitigate this risk.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    }
]