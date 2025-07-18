[
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokensToLiquify = _balances[address(this)]; uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2); uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify); address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); router.swapExactTokensForETHSupportingFeeOnTransferTokens( amountToSwap, 0, path, address(this), block.timestamp ); uint256 amountETH = address(this).balance; uint256 devBalance = amountETH.mul(devFee).div(totalFee); uint256 hldBalance = amountETH.mul(hldFee).div(totalFee); uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2); uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity); if(amountETH > 0){ IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}(); devWallet.transfer(devBalance); } try dividendDistributor.deposit{value: amountEthReflection}() {} catch {} if(amountToLiquify > 0){ router.addLiquidityETH{value: amountEthLiquidity}( address(this), amountToLiquify, 0, 0, 0x000000000000000000000000000000000000dEaD, block.timestamp ); } }",
        "vulnerability": "Reentrancy vulnerability via external calls",
        "reason": "The `swapBack` function makes multiple external calls such as `router.swapExactTokensForETHSupportingFeeOnTransferTokens`, `IBURNER(hldBurnerAddress).burnEmUp`, `devWallet.transfer`, and `router.addLiquidityETH`. These calls can lead to reentrancy issues where an attacker could exploit the external calls to manipulate the contract state before the function execution completes. Although a reentrancy guard is applied, the use of multiple external calls in a single transaction increases the risk of unexpected behavior or potential exploits.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) external onlyHldAdmin { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralization risk due to admin privileges",
        "reason": "The `setBots` function allows the `hldAdmin` to arbitrarily mark addresses as bots, effectively blacklisting them. This centralization of control can be exploited by a malicious or compromised admin to unfairly restrict or manipulate certain addresses, leading to potential denial of service for legitimate users. It is important to implement mechanisms to ensure checks and balances or community governance to prevent misuse.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    },
    {
        "function_name": "removeHldAdmin",
        "code": "function removeHldAdmin() public virtual onlyOwner { hldAdmin = address(0); }",
        "vulnerability": "Loss of administrative control",
        "reason": "The `removeHldAdmin` function allows the contract owner to set the `hldAdmin` to the zero address, permanently removing the ability to perform actions restricted to the `hldAdmin`. This can lead to loss of control over critical functions and may prevent necessary administrative actions in the future. A mechanism to reassign or regain admin privileges should be considered to avoid permanent loss of control.",
        "file_name": "0x300af88747b3f913012753071f209b48b30ea1ac.sol"
    }
]