[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { if (_allowances[sender][msg.sender] != _totalSupply) { _allowances[sender][msg.sender] = _allowances[sender][msg.sender] .sub(amount, \"Insufficient Allowance\"); } return _transferFrom(sender, recipient, amount); }",
        "vulnerability": "Unchecked allowance decrement",
        "reason": "In the transferFrom function, the allowance is decremented using SafeMath's sub function. However, the function doesn't check if the allowance is sufficient before attempting the subtraction, which can cause a revert with the message \"Insufficient Allowance\". Moreover, the function should ensure that allowance is not set to a magic value like _totalSupply to avoid bypassing allowance checks.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal { shareholders[shareholderIndexes[shareholder]] = shareholders[ shareholders.length - 1 ]; shareholderIndexes[ shareholders[shareholders.length - 1] ] = shareholderIndexes[shareholder]; shareholders.pop(); }",
        "vulnerability": "Insecure shareholder removal",
        "reason": "The removeShareholder function replaces the shareholder to be removed with the last shareholder in the list without updating the index of the moved shareholder. This can cause incorrect mapping of shareholderIndexes, potentially leading to an invalid state of the shareholders list.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal swapping { uint256 totalFee = _liquidityFeeCount.add(_reflectionFeeCount); uint256 amountToLiquify = swapThreshold .mul(_liquidityFeeCount) .div(totalFee) .div(2); uint256 amountToSwap = swapThreshold.sub(amountToLiquify); _allowances[address(this)][address(router)] = _totalSupply; address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); uint256 balanceBefore = address(this).balance; router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 totalBNBFee = totalFee.sub(_liquidityFeeCount.div(2)); uint256 amountBNBLiquidity = amountBNB .mul(_liquidityFeeCount) .div(totalBNBFee) .div(2); if (amountToLiquify > 0) { router.addLiquidityETH{value: amountBNBLiquidity}( address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp ); emit AutoLiquify(amountBNBLiquidity, amountToLiquify); } uint256 amountBNBReflection = amountBNB.mul(_reflectionFeeCount).div( totalBNBFee ); if (amountBNBReflection > 0) { try distributor.deposit{value: amountBNBReflection}() {} catch {} } _liquidityFeeCount = 0; _reflectionFeeCount = 0; }",
        "vulnerability": "Unlimited token allowance",
        "reason": "The swapBack function sets the allowance of the router to the total supply of tokens without any checks. This can potentially allow the router to spend an unlimited amount of tokens on behalf of the contract, which can be exploited if the router's contract is compromised or behaves maliciously.",
        "file_name": "0x108523415a8cd7cb8ef2d6b12177181f489ec210.sol"
    }
]