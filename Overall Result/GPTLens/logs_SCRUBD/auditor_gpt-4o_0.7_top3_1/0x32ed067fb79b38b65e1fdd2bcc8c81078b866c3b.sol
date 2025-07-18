[
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal {\n    shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];\n    shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];\n    shareholders.pop();\n}",
        "vulnerability": "Incorrect removal of elements in shareholders array",
        "reason": "The function `removeShareholder` does not properly handle the mapping `shareholderIndexes` and the `shareholders` array. When an element is removed, it replaces the removed element with the last element in the array. However, it updates the index of the last element before removal, which can lead to incorrect values if `shareholders` is accessed before the operation is complete. This can cause unexpected behavior in the contract, such as incorrect shareholder updates and distributions.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {\n    minPeriod = _minPeriod;\n    minDistribution = _minDistribution;\n}",
        "vulnerability": "Lack of proper access control",
        "reason": "The `setDistributionCriteria` function can be called by any address that is the token contract, which could allow a compromised token contract to set arbitrary values for `minPeriod` and `minDistribution`. This could lead to denial of service (DoS) attacks by setting these values to impractical numbers, disrupting the expected reward distribution.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping {\n    uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;\n    uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);\n    uint256 amountToSwap = swapThreshold.sub(amountToLiquify);\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = WETH;\n    uint256 balanceBefore = address(this).balance;\n    router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        amountToSwap,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n    uint256 amountETH = address(this).balance.sub(balanceBefore);\n    uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));\n    uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);\n    uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee);\n    uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\n    uint256 splitmarketfee = amountETHMarketing.mul(333).div(1000);\n    uint256 finialmatketfee = amountETHMarketing.sub(splitmarketfee);\n    try distributor.deposit{value: amountETHReflection}() {} catch {}\n    payable(harryLiquiditypool).transfer(splitmarketfee);\n    payable(marketingFeeReceiver).transfer(finialmatketfee);\n    if(amountToLiquify > 0){\n        router.addLiquidityETH{value: amountETHLiquidity}(\n            address(this),\n            amountToLiquify,\n            0,\n            0,\n            autoLiquidityReceiver,\n            block.timestamp\n        );\n        emit AutoLiquify(amountETHLiquidity, amountToLiquify);\n    }\n}",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The `swapBack` function performs multiple external calls without checks for reentrancy, such as transferring ETH to `harryLiquiditypool` and `marketingFeeReceiver`. This can be exploited by attackers if these addresses are malicious or compromised, as they could reenter the contract during execution, potentially leading to unexpected behavior or draining of the contract's balance.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    }
]