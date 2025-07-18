[
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken { minPeriod = _minPeriod; minDistribution = _minDistribution; }",
        "vulnerability": "Lack of Access Control",
        "reason": "The setDistributionCriteria function is intended to be called only by the token contract. However, if the initial deployment of the token contract isn't controlled securely or the token contract has vulnerabilities, an attacker could exploit this to set undesirable distribution criteria, affecting the dividend distribution logic.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); uint256 splitmarketfee = amountETHMarketing.mul(333).div(1000); uint256 finialmatketfee = amountETHMarketing.sub(splitmarketfee); try distributor.deposit{value: amountETHReflection}() {} catch {} payable(harryLiquiditypool).transfer(splitmarketfee); payable(marketingFeeReceiver).transfer(finialmatketfee); if(amountToLiquify > 0){ router.addLiquidityETH{value: amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The swapBack function performs external calls to the router and distributor contracts. If these contracts are malicious or if they have reentrancy vulnerabilities, it could lead to reentrancy attacks. The contract should use the checks-effects-interactions pattern to mitigate such risks.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership Takeover",
        "reason": "The transferOwnership function allows the current owner to transfer ownership to any address without any checks. If the owner's private key is compromised, an attacker could transfer ownership to themselves and take over the contract completely. Implementing a two-step ownership transfer mechanism could mitigate this risk.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    }
]