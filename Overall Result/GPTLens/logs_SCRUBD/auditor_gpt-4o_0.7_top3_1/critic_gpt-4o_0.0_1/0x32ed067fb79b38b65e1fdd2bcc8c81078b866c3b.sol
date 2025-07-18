[
    {
        "function_name": "removeShareholder",
        "vulnerability": "Incorrect removal of elements in shareholders array",
        "criticism": "The reasoning is correct in identifying that the function does not properly handle the mapping `shareholderIndexes` and the `shareholders` array. The function attempts to replace the removed element with the last element in the array and update the index, but it does so in a way that can lead to incorrect values if the `shareholders` array is accessed before the operation is complete. This can indeed cause unexpected behavior, such as incorrect shareholder updates and distributions. The severity is moderate because it can disrupt the contract's logic, but it is not directly exploitable for profit. The profitability is low as it does not provide a direct financial gain to an attacker.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The function `removeShareholder` does not properly handle the mapping `shareholderIndexes` and the `shareholders` array. When an element is removed, it replaces the removed element with the last element in the array. However, it updates the index of the last element before removal, which can lead to incorrect values if `shareholders` is accessed before the operation is complete. This can cause unexpected behavior in the contract, such as incorrect shareholder updates and distributions.",
        "code": "function removeShareholder(address shareholder) internal {\n    shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];\n    shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];\n    shareholders.pop();\n}",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "vulnerability": "Lack of proper access control",
        "criticism": "The reasoning correctly identifies a potential vulnerability due to insufficient access control. The function can be called by any address that is the token contract, which could be problematic if the token contract is compromised. This could allow arbitrary values to be set for `minPeriod` and `minDistribution`, potentially leading to denial of service (DoS) attacks by setting these values to impractical numbers. The severity is high because it can disrupt the expected reward distribution, but the profitability is moderate as it could be used to manipulate the system for indirect financial gain.",
        "correctness": 9,
        "severity": 7,
        "profitability": 4,
        "reason": "The `setDistributionCriteria` function can be called by any address that is the token contract, which could allow a compromised token contract to set arbitrary values for `minPeriod` and `minDistribution`. This could lead to denial of service (DoS) attacks by setting these values to impractical numbers, disrupting the expected reward distribution.",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {\n    minPeriod = _minPeriod;\n    minDistribution = _minDistribution;\n}",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "swapBack",
        "vulnerability": "Potential reentrancy attack",
        "criticism": "The reasoning correctly identifies the potential for a reentrancy attack due to multiple external calls without reentrancy checks. The function transfers ETH to `harryLiquiditypool` and `marketingFeeReceiver`, which could be exploited if these addresses are malicious or compromised. This could allow an attacker to reenter the contract during execution, potentially leading to unexpected behavior or draining of the contract's balance. The severity is high because reentrancy attacks can be devastating, and the profitability is also high as it could allow an attacker to drain funds from the contract.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The `swapBack` function performs multiple external calls without checks for reentrancy, such as transferring ETH to `harryLiquiditypool` and `marketingFeeReceiver`. This can be exploited by attackers if these addresses are malicious or compromised, as they could reenter the contract during execution, potentially leading to unexpected behavior or draining of the contract's balance.",
        "code": "function swapBack() internal swapping {\n    uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;\n    uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);\n    uint256 amountToSwap = swapThreshold.sub(amountToLiquify);\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = WETH;\n    uint256 balanceBefore = address(this).balance;\n    router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        amountToSwap,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n    uint256 amountETH = address(this).balance.sub(balanceBefore);\n    uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));\n    uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);\n    uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee);\n    uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\n    uint256 splitmarketfee = amountETHMarketing.mul(333).div(1000);\n    uint256 finialmatketfee = amountETHMarketing.sub(splitmarketfee);\n    try distributor.deposit{value: amountETHReflection}() {} catch {}\n    payable(harryLiquiditypool).transfer(splitmarketfee);\n    payable(marketingFeeReceiver).transfer(finialmatketfee);\n    if(amountToLiquify > 0){\n        router.addLiquidityETH{value: amountETHLiquidity}(\n            address(this),\n            amountToLiquify,\n            0,\n            0,\n            autoLiquidityReceiver,\n            block.timestamp\n        );\n        emit AutoLiquify(amountETHLiquidity, amountToLiquify);\n    }\n}",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    }
]