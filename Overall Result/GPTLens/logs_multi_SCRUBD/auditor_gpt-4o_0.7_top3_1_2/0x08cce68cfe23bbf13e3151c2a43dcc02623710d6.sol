[
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); approve(address(this), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Approval race condition",
        "reason": "The swapTokensForEth function calls approve with the contract's own address. If this function is called concurrently, it could overwrite the approval set by another instance of the function. This could lead to a situation where less tokens are swapped than intended.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "setShare",
        "code": "function setShare(address shareholder, uint256 amount) external override onlyToken { if(shares[shareholder].amount > 0){ distributeDividend(shareholder); } if(amount > 0 && shares[shareholder].amount == 0){ addShareholder(shareholder); }else if(amount == 0 && shares[shareholder].amount > 0){ removeShareholder(shareholder); } totalShares = totalShares.sub(shares[shareholder].amount).add(amount); shares[shareholder].amount = amount; shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); }",
        "vulnerability": "Reentrancy",
        "reason": "The setShare function calls distributeDividend, which executes an external call to transfer tokens. This could allow a reentrancy attack, where the shareholder can call setShare again before the first call completes, potentially leading to incorrect totalShares and other state variables.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForDigitalGold = totalEthBalance.mul(toReflections).div(100); uint256 ethForMarketing = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(marketingWallet).transfer(ethForMarketing); } try moneyPrinter.deposit{value: ethForDigitalGold}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Untrusted contract call",
        "reason": "The swapBack function calls the deposit function on the moneyPrinter contract with a try-catch block. This call could fail or revert unexpectedly if the moneyPrinter contract has been compromised or behaves maliciously. The try-catch block suppresses any errors, potentially masking significant issues.",
        "file_name": "0x08cce68cfe23bbf13e3151c2a43dcc02623710d6.sol"
    }
]