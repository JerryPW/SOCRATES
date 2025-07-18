[
    {
        "function_name": "removeHldAdmin",
        "code": "function removeHldAdmin() public virtual onlyOwner { hldAdmin = address(0); }",
        "vulnerability": "Irreversible Admin Removal",
        "reason": "The removeHldAdmin function allows the contract owner to set the hldAdmin address to the zero address, effectively removing the functionality that requires the hldAdmin role. This action is irreversible and could lead to a loss of control over specific administrative functions that require the hldAdmin role.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokensToLiquify = _balances[address(this)]; uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2); uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance; uint256 devBalance = amountETH.mul(devFee).div(totalFee); uint256 hldBalance = amountETH.mul(hldFee).div(totalFee); uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2); uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity); if(amountETH > 0){ IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}(); devWallet.transfer(devBalance); } try dividendDistributor.deposit{value: amountEthReflection}() {} catch {} if(amountToLiquify > 0){ router.addLiquidityETH{value: amountEthLiquidity}( address(this), amountToLiquify, 0, 0, 0x000000000000000000000000000000000000dEaD, block.timestamp ); } }",
        "vulnerability": "Potential Reentrancy in swapBack",
        "reason": "The swapBack function transfers ETH to external addresses (hldBurnerAddress and devWallet) and interacts with external contracts (IBURNER and dividendDistributor). This interaction, combined with the potential for reentrancy in the external calls, could allow an attacker to exploit reentrancy vulnerabilities if the external contracts are not trusted or secure.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) { require(!bots[sender] && !bots[recipient]); if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); } require(amount <= _maxTxAmount || isTxLimitExempt[sender], \"tx\"); if(!isTxLimitExempt[recipient] && restrictWhales) { require(_balances[recipient].add(amount) <= _walletMax, \"wallet\"); } if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); } _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\"); uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount; _balances[recipient] = _balances[recipient].add(finalAmount); if(!isDividendExempt[sender]) { try dividendDistributor.setShare(sender, _balances[sender]) {} catch {} } if(!isDividendExempt[recipient]) { try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} } try dividendDistributor.process(distributorGas) {} catch {} emit Transfer(sender, recipient, finalAmount); return true; }",
        "vulnerability": "Unchecked External Calls",
        "reason": "The _transfer function makes unchecked external calls to the dividendDistributor contract using try-catch blocks. While this prevents the transaction from reverting, it can also mask errors and lead to unexpected behavior if the calls fail, potentially leaving the state of dividends and shares inconsistent.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    }
]