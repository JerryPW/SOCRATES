[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Potentially Dangerous Ownership Transfer",
        "reason": "The `transferOwnership` function does not remove the previous owner's authorization, allowing the previous owner to retain control over the contract. This can lead to unauthorized actions by the previous owner, as they are still considered authorized after ownership transfer.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value : amountETHReflection}() {} catch {} payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}(\"\"); if (amountToLiquify > 0) { router.addLiquidityETH{value : amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function `swapBack` makes an external call to `marketingFeeReceiver` using `.call` without proper checks, which can be exploited by a reentrant attack if the `marketingFeeReceiver` is a contract with a fallback function. This can lead to multiple withdrawals or alterations in the contract state.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "setShare",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if (shares[shareholder].amount > 0) { distributeDividend(shareholder); } if (amount > 0 && shares[shareholder].amount == 0) { addShareholder(shareholder); } else if (amount == 0 && shares[shareholder].amount > 0) { removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "vulnerability": "Integer Underflow/Overflow",
        "reason": "The function `setShare` does not adequately use SafeMath for operations involving `totalShares`, which can result in an integer underflow or overflow if an attacker controls the addition or subtraction of shares. This can lead to incorrect distribution of dividends and potentially disrupt the dividend distribution logic.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    }
]