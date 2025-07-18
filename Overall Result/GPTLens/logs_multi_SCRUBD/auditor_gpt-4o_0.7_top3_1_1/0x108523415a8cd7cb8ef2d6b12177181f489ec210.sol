[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = payable(address(0)); }",
        "vulnerability": "Ownership renouncement to zero address",
        "reason": "Renouncing ownership by setting the owner to the zero address effectively disables the onlyOwner functionality, making it impossible to perform any functions that require the owner role. This could lead to a situation where vital functions that need the owner's permissions cannot be executed, potentially locking the contract or leaving it in an undesired state.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "shouldSwapBack",
        "code": "function shouldSwapBack() internal view returns (bool) { return msg.sender != pair && !inSwap && swapEnabled && _balances[address(this)] >= swapThreshold; }",
        "vulnerability": "Potential front-running attack",
        "reason": "The function checks if the contract's balance is greater than or equal to the swapThreshold before performing a swap back. An attacker could monitor the mempool and front-run transactions to manipulate the token price or profit from fee discrepancies, especially if they can predict when swaps are likely to occur.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 totalFee = _liquidityFeeCount.add(_reflectionFeeCount); uint256 amountToLiquify = swapThreshold .mul(_liquidityFeeCount) .div(totalFee) .div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); _allowances[address(this)][address(router)] = _totalSupply; address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 totalBNBFee = totalFee.sub(_liquidityFeeCount.div(2)); uint256 amountBNBLiquidity = amountBNB .mul(_liquidityFeeCount) .div(totalBNBFee) .div(2); if (amountToLiquify > 0) { router.addLiquidityETH{value: amountBNBLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountBNBLiquidity, amountToLiquify); } uint256 amountBNBReflection = amountBNB.mul(_reflectionFeeCount).div( totalBNBFee ); if (amountBNBReflection > 0) { try distributor.deposit{value: amountBNBReflection}() {} catch {} } _liquidityFeeCount = 0; _reflectionFeeCount = 0; }",
        "vulnerability": "No slippage protection during swaps",
        "reason": "The swapBack function does not account for potential slippage when swapping tokens for ETH. This lack of slippage protection can be exploited by attackers who can front-run the swap and cause significant losses or disruptions in the token's liquidity and price.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    }
]