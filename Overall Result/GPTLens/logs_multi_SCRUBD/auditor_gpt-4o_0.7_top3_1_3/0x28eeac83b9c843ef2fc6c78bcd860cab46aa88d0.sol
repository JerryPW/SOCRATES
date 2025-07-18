[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Improper authorization reset",
        "reason": "The function `transferOwnership` does not revoke the authorization of the previous owner, which means that the previous owner could still have elevated permissions if the contract does not explicitly handle this in other parts of the code. This could lead to security risks where the previous owner might perform unauthorized actions.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized { distributor.setDistributionCriteria(_minPeriod, _minDistribution); }",
        "vulnerability": "Lack of input validation",
        "reason": "The function `setDistributionCriteria` allows any authorized user to set the `_minPeriod` and `_minDistribution` without any checks on the values. This could potentially be exploited by an attacker to set these values to very high numbers, which could prevent dividends from being distributed in a timely manner or at all, impacting the intended functionality of the contract.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value: amountETHReflection}() {} catch {} payable(marketingFeeReceiver).transfer(amountETHMarketing); if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Potential reentrancy",
        "reason": "The `swapBack` function could be vulnerable to reentrancy attacks depending on the behavior of external contracts like the router and the distributor. It involves multiple external calls and transfers without proper reentrancy guard mechanisms. An attacker could potentially reenter the contract through one of the external calls and alter its state in unexpected ways.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    }
]