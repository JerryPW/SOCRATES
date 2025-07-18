[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) { require(!bots[sender] && !bots[recipient]); if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); } require(amount <= _maxTxAmount || isTxLimitExempt[sender], \"tx\"); if(!isTxLimitExempt[recipient] && restrictWhales) { require(_balances[recipient].add(amount) <= _walletMax, \"wallet\"); } if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); } _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\"); uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount; _balances[recipient] = _balances[recipient].add(finalAmount); if(!isDividendExempt[sender]) { try dividendDistributor.setShare(sender, _balances[sender]) {} catch {} } if(!isDividendExempt[recipient]) { try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} } try dividendDistributor.process(distributorGas) {} catch {} emit Transfer(sender, recipient, finalAmount); return true; }",
        "vulnerability": "Reentrancy during swapBack",
        "reason": "The _transfer function calls swapBack if certain conditions are met, which allows the contract to swap tokens for ETH and add liquidity. This process can involve external calls to the Uniswap router, which could allow reentrant calls if the external call is made before updating balances and state variables. Although there is a lockTheSwap modifier, the check happens after the external call, which might not effectively prevent reentrancy.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokensToLiquify = _balances[address(this)]; uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2); uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance; uint256 devBalance = amountETH.mul(devFee).div(totalFee); uint256 hldBalance = amountETH.mul(hldFee).div(totalFee); uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2); uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity); if(amountETH > 0){ IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}(); devWallet.transfer(devBalance); } try dividendDistributor.deposit{value: amountEthReflection}() {} catch {} if(amountToLiquify > 0){ router.addLiquidityETH{value: amountEthLiquidity}( address(this), amountToLiquify, 0, 0, 0x000000000000000000000000000000000000dEaD, block.timestamp ); } }",
        "vulnerability": "Improper ETH balance handling",
        "reason": "The function calculates and transfers ETH to several addresses based on the current balance of the contract, which might be manipulated or altered by external interactions. The function doesn't account for the possibility of ETH being sent to the contract directly, which could lead to incorrect distribution of ETH amounts.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal { shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1]; shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder]; shareholders.pop(); }",
        "vulnerability": "Improper index update",
        "reason": "The function removes a shareholder by replacing it with the last entry in the shareholders array. However, it doesn't handle cases where the shareholder being removed is the last one in the array, potentially leading to incorrect state updates and out-of-bounds errors. Additionally, it doesn't set the index of the removed shareholder to an invalid value, which might lead to stale index data.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    }
]