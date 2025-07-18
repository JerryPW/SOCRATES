[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Missing authorization removal for previous owner",
        "reason": "The function `transferOwnership` transfers the ownership to a new address but fails to remove the authorization from the previous owner, which can result in unintended access to functions restricted to the owner, potentially leading to unauthorized access or control.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified( targetLiquidity, targetLiquidityDenominator ) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold .mul(dynamicLiquidityFee) .div(totalFee) .div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountBNBLiquidity = amountBNB .mul(dynamicLiquidityFee) .div(totalBNBFee) .div(2); uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div( totalBNBFee ); uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div( totalBNBFee ); try distributor.deposit{ value: amountBNBReflection }() {} catch {} payable(marketingFeeReceiver).transfer(amountBNBMarketing); if (amountToLiquify > 0) { router.addLiquidityETH{ value: amountBNBLiquidity }( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountBNBLiquidity, amountToLiquify); } }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The `swapBack` function involves transferring BNB to the `marketingFeeReceiver` and interacting with the Uniswap router. This sequence can be susceptible to reentrancy attacks if the receiver is a contract that manipulates the token's state during the external call. The lack of a checks-effects-interactions pattern increases the risk.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(uint256 amount, address to) internal swapping { address[] memory path = new address[](2); path[0] = router.WETH(); path[1] = address(this); router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(0, path, to, block.timestamp); }",
        "vulnerability": "Unprotected internal function",
        "reason": "The `buyTokens` function is marked as `internal` and can be called by other functions in the contract. If any external-facing function inadvertently exposes an entry point to this function without proper validation or authorization checks, it can be exploited by an attacker to manipulate token purchases, potentially affecting token price or liquidity.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    }
]