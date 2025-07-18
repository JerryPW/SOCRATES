[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership takeover",
        "reason": "The transferOwnership function allows the current owner to transfer ownership to any arbitrary address without any additional checks or confirmations. This could potentially allow an attacker with owner privileges to transfer ownership to a malicious address, leading to loss of control over the contract. It's recommended to implement a two-step or time-delayed ownership transfer process to mitigate this risk.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized { distributor.setDistributionCriteria(_minPeriod, _minDistribution); }",
        "vulnerability": "Dividend distribution manipulation",
        "reason": "The setDistributionCriteria function allows an authorized address to set the minimum period and minimum distribution for dividends. If an attacker gains authorized status, they can set these values to extremely high numbers, effectively halting dividend distributions to shareholders. Implementing stricter access control or a more robust authorization mechanism can prevent unauthorized manipulation.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value: amountETHReflection}() {} catch {} payable(marketingFeeReceiver).transfer(amountETHMarketing); if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Reentrancy risk",
        "reason": "The swapBack function involves transferring ETH to the marketingFeeReceiver and adding liquidity, both of which are external calls and can be exploited through reentrancy attacks. This risk is heightened by the fact that the contract does not use reentrancy guards. Implementing a reentrancy guard or pattern can mitigate the risk of reentrant calls during token swaps and liquidity additions.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    }
]