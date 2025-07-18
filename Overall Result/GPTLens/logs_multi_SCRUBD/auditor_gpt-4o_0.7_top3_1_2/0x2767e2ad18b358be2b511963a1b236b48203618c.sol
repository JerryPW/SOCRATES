[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership Renounce Risk",
        "reason": "The function allows the ownership to be transferred to any address, including a contract address. This can lead to loss of control if the new owner is a contract without the necessary functions to manage ownership effectively.",
        "file_name": "0x2767e2ad18b358be2b511963a1b236b48203618c.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHDev = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value: amountETHReflection}() {} catch {} (bool success,) = payable(marketingFeeReceiver).call{value: amountETHDev, gas: 30000}(\"\"); require(success, \"receiver rejected ETH transfer\"); if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The function uses low-level call with ETH transfer without checks-effects-interactions pattern, which can be exploited for reentrancy attacks, allowing attackers to drain contract funds.",
        "file_name": "0x2767e2ad18b358be2b511963a1b236b48203618c.sol"
    },
    {
        "function_name": "deposit",
        "code": "function deposit() external payable override onlyToken { uint256 balanceBefore = POOF.balanceOf(address(this)); address[] memory path = new address[](2); path[0] = WETH; path[1] = address(POOF); router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}( 0, path, address(this), block.timestamp ); uint256 amount = POOF.balanceOf(address(this)).sub(balanceBefore); totalDividends = totalDividends.add(amount); dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)); }",
        "vulnerability": "Denial of Service",
        "reason": "If `totalShares` is zero, the function will revert due to division by zero in `dividendsPerShare`, which can be exploited to halt dividend distribution.",
        "file_name": "0x2767e2ad18b358be2b511963a1b236b48203618c.sol"
    }
]