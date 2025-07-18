[
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal { shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1]; shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder]; shareholders.pop(); }",
        "vulnerability": "Potential Reentrancy Vulnerability",
        "reason": "The removeShareholder function modifies the shareholders array by replacing the shareholder to be removed with the last shareholder in the list and then popping the last element. If another contract can call this function in an unexpected way, it might be able to modify the index values, leading to an incorrect state of the array. This could potentially be exploited in conjunction with other vulnerabilities to drain funds or manipulate the dividend distribution.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokensToLiquify = _balances[address(this)]; uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2); uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance; uint256 devBalance = amountETH.mul(devFee).div(totalFee); uint256 hldBalance = amountETH.mul(hldFee).div(totalFee); uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2); uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity); if(amountETH > 0){ IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}(); devWallet.transfer(devBalance); } try dividendDistributor.deposit{value: amountEthReflection}() {} catch {} if(amountToLiquify > 0){ router.addLiquidityETH{value: amountEthLiquidity}( address(this), amountToLiquify, 0, 0, 0x000000000000000000000000000000000000dEaD, block.timestamp ); } }",
        "vulnerability": "Lack of Slippage Control",
        "reason": "The swapBack function performs token swaps and liquidity operations without specifying minimum amounts for tokens received or slippage tolerance. This could result in significant losses during token swaps if the market conditions change unfavorably. An attacker could manipulate the price or flood the liquidity pool, causing the contract to receive less ETH or tokens than expected, thus depleting the contract's balance.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "claimDividend",
        "code": "function claimDividend() external { require(shouldDistribute(msg.sender), \"Too soon. Need to wait!\"); distributeDividend(msg.sender); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The claimDividend function can be called by any shareholder, but it requires that shouldDistribute returns true. If an attacker can manipulate the shareholder's state to always fail the shouldDistribute check (for example, by continuously transferring tokens to themselves or another address), they could block dividend claims for other shareholders, thus denying them their dividends.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    }
]