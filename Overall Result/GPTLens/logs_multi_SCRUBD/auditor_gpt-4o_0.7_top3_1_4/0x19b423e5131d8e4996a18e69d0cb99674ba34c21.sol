[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership takeover",
        "reason": "The function allows the current owner to transfer ownership to any address without any secondary checks or approvals, potentially leading to an unauthorized transfer if the owner's key is compromised.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "setBuybackMultiplierSettings",
        "code": "function setBuybackMultiplierSettings( uint256 numerator, uint256 denominator, uint256 length ) external authorized { require(numerator / denominator <= 2 && numerator > denominator); buybackMultiplierNumerator = numerator; buybackMultiplierDenominator = denominator; buybackMultiplierLength = length; }",
        "vulnerability": "Incorrect fee multiplier setting",
        "reason": "The function checks for a condition (numerator / denominator <= 2) that can be bypassed with integer division, potentially allowing for excessive fee multipliers if the denominator is large enough and the condition is incorrectly satisfied.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 dynamicLiquidityFee = isOverLiquified( targetLiquidity, targetLiquidityDenominator ) ? 0 : liquidityFee; uint256 amountToLiquify = swapThreshold .mul(dynamicLiquidityFee) .div(totalFee) .div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2)); uint256 amountBNBLiquidity = amountBNB .mul(dynamicLiquidityFee) .div(totalBNBFee) .div(2); uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div( totalBNBFee ); uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div( totalBNBFee ); try distributor.deposit{ value: amountBNBReflection }() {} catch {} payable(marketingFeeReceiver).transfer(amountBNBMarketing); if (amountToLiquify > 0) { router.addLiquidityETH{ value: amountBNBLiquidity }( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountBNBLiquidity, amountToLiquify); } }",
        "vulnerability": "Potential loss of funds",
        "reason": "The function could lead to a loss of funds if the transaction fails after some tokens have been swapped but before liquidity has been added or marketing fees have been transferred, as it does not handle potential failures adequately and may proceed without reverting.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    }
]