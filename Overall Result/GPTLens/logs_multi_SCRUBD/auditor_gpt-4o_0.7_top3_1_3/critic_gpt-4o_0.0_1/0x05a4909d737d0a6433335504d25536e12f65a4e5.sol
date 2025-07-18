[
    {
        "function_name": "transferOwnership",
        "vulnerability": "Authorization persistence",
        "criticism": "The reasoning is correct in identifying that the previous owner retains authorization privileges after ownership transfer. This could indeed lead to unintended control retention by the previous owner. The severity is moderate because it depends on the contract's reliance on the authorization mapping for critical functions. The profitability is low for an external attacker but could be high for a malicious previous owner. However, the reasoning does not consider that the new owner can manually revoke the previous owner's authorization, which slightly reduces the severity.",
        "correctness": 8,
        "severity": 5,
        "profitability": 3,
        "reason": "When ownership is transferred to a new address, the previous owner retains authorization privileges unless explicitly removed. This could allow a previous owner to retain control over certain aspects of the contract due to the inherent authorization mapping, which might be overlooked. To mitigate, ensure that the previous owner is explicitly unauthorized when ownership is transferred.",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "swapAndDistributeSpecial",
        "vulnerability": "ERC20 token assumption",
        "criticism": "The reasoning correctly identifies the assumption that claimToken is ERC20-compliant without verification. This could lead to unexpected behavior if a non-standard token is used. The severity is moderate because it could disrupt the swapping process, but it does not directly lead to a loss of funds. The profitability is low because an external attacker cannot directly exploit this for financial gain, but it could cause operational issues.",
        "correctness": 8,
        "severity": 4,
        "profitability": 1,
        "reason": "The function assumes that the claimToken is an ERC20-compliant token without explicitly verifying it. If a malicious or non-standard token is set as claimToken, it could disrupt the swapping process or cause unexpected behavior. It is important to add checks to ensure that claimToken adheres to the ERC20 standard before attempting a swap.",
        "code": "function swapAndDistributeSpecial(address shareholder, uint256 amount) internal{ address claimToken = shareholderClaimAs[shareholder]; if (claimToken == address(0)) { USDC.transfer(shareholder, amount); } else { address[] memory path = new address[](2); path[0] = address(USDC); path[1] = claimToken; try router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount, 0, path, shareholder, block.timestamp) {} catch{ USDC.transfer(shareholder, amount); } } }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "swapBack",
        "vulnerability": "Unchecked external call",
        "criticism": "The reasoning is correct in identifying the unchecked external call to marketingFeeReceiver with a low gas limit. This could result in funds being sent to contracts that do not handle the call correctly, potentially causing the transaction to fail silently. The severity is moderate because it could lead to loss of funds if the call fails. The profitability is low for an external attacker but could result in operational issues for the contract.",
        "correctness": 9,
        "severity": 5,
        "profitability": 2,
        "reason": "The call to `marketingFeeReceiver` is performed with a low gas limit and without checking the return value. This can result in funds being sent to contracts that do not handle the call correctly, potentially causing the transaction to fail silently. It's crucial to handle errors from external calls properly and ensure that the destination address can process the funds as expected.",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = WETH; uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance.sub(balanceBefore); uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2); uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee); uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee); try distributor.deposit{value : amountETHReflection}() {} catch {} payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}(\"\"); if (amountToLiquify > 0) { router.addLiquidityETH{value : amountETHLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountETHLiquidity, amountToLiquify); } }",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    }
]