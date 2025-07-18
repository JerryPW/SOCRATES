[
    {
        "function_name": "swapBack",
        "vulnerability": "Reentrancy Vulnerability",
        "criticism": "The reasoning is correct. The swapBack function makes an external call to marketingFeeReceiver using .call without proper checks, which can be exploited by a reentrant attack if the marketingFeeReceiver is a contract with a fallback function. This can lead to multiple withdrawals or alterations in the contract state. The severity and profitability of this vulnerability are high if the marketingFeeReceiver is a malicious contract.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function `swapBack` makes an external call to `marketingFeeReceiver` using `.call` without proper checks, which can be exploited by a reentrant attack if the `marketingFeeReceiver` is a contract with a fallback function. This can lead to multiple withdrawals or alterations in the contract state.",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value : amountETHReflection}() {} catch {} payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}(\"\"); if (amountToLiquify > 0) { router.addLiquidityETH{value : amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol",
        "final_score": 8.5
    },
    {
        "function_name": "transferOwnership",
        "vulnerability": "Potentially Dangerous Ownership Transfer",
        "criticism": "The reasoning is correct. The transferOwnership function does not remove the previous owner's authorization, which could potentially allow the previous owner to retain control over the contract. This could lead to unauthorized actions by the previous owner. However, the severity and profitability of this vulnerability are high only if the previous owner has malicious intentions.",
        "correctness": 9,
        "severity": 7,
        "profitability": 7,
        "reason": "The `transferOwnership` function does not remove the previous owner's authorization, allowing the previous owner to retain control over the contract. This can lead to unauthorized actions by the previous owner, as they are still considered authorized after ownership transfer.",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol",
        "final_score": 8.0
    },
    {
        "function_name": "setShare",
        "vulnerability": "Integer Underflow/Overflow",
        "criticism": "The reasoning is partially correct. The setShare function does not use SafeMath for operations involving totalShares, which could potentially lead to an integer underflow or overflow. However, the severity and profitability of this vulnerability are low because an attacker cannot directly control the addition or subtraction of shares. The attacker would need to be a shareholder with a large amount of shares to exploit this vulnerability.",
        "correctness": 6,
        "severity": 3,
        "profitability": 2,
        "reason": "The function `setShare` does not adequately use SafeMath for operations involving `totalShares`, which can result in an integer underflow or overflow if an attacker controls the addition or subtraction of shares. This can lead to incorrect distribution of dividends and potentially disrupt the dividend distribution logic.",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if (shares[shareholder].amount > 0) { distributeDividend(shareholder); } if (amount > 0 && shares[shareholder].amount == 0) { addShareholder(shareholder); } else if (amount == 0 && shares[shareholder].amount > 0) { removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol",
        "final_score": 4.25
    }
]