[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public onlyOwner { require(_newOwner != address(0)); emit onOwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Lack of event emission",
        "reason": "The function `transferOwnership` lacks a descriptive error message in the require statement when the new owner address is zero. While this is not directly exploitable, it is a security best practice to provide detailed revert reasons.",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol"
    },
    {
        "function_name": "setMaxPerWalletPercent",
        "code": "function setMaxPerWalletPercent(uint256 _percentTime10) public onlyOwner { require(_percentTime10 >= 10, \"Minimum is 1%\"); numMaxPerWalletPercent = _percentTime10; }",
        "vulnerability": "Misleading error message",
        "reason": "The require statement in `setMaxPerWalletPercent` has a misleading error message. It states 'Minimum is 1%' while the condition checks for 10, which could lead to confusion and errors in setting parameters.",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol"
    },
    {
        "function_name": "swapAndSend",
        "code": "function swapAndSend() private lockTheSwap { uint256 contractTokenBalance = balanceOf(address(this)); uint256 maxroutersell = _totalSupply.div(1000).mul(maxrouterpercent); if(contractTokenBalance > maxroutersell && maxrouterlimitenabled) { contractTokenBalance = contractTokenBalance.div(10); } uint256 _totalFee = _liquidityFee.add(_ethReflectionFee).add(_stakingFee).add(_marketingFee); uint256 amountForLiquidity = contractTokenBalance.mul(_liquidityFee).div(_totalFee); uint256 amountForEthReflection = contractTokenBalance.mul(_ethReflectionFee).div(_totalFee); uint256 amountForStaking = contractTokenBalance.mul(_stakingFee).div(_totalFee); uint256 amountForMarketingAndDev = contractTokenBalance.sub(amountForLiquidity).sub(amountForEthReflection).sub(amountForStaking); uint256 half = amountForLiquidity.div(2); uint256 otherHalf = amountForLiquidity.sub(half); uint256 swapAmount = half.add(amountForEthReflection).add(amountForStaking).add(amountForMarketingAndDev); swapTokensForEth(swapAmount); uint256 ethBalance = address(this).balance; uint256 ethLiquid = ethBalance.mul(half).div(swapAmount); uint256 ethReflection = ethBalance.mul(amountForEthReflection).div(swapAmount); uint256 ethStaking = ethBalance.mul(amountForStaking).div(swapAmount); uint256 ethMarketingAndDev = ethBalance.sub(ethLiquid).sub(ethReflection).sub(ethStaking); if(ethMarketingAndDev > 0){ payable(marketingWallet).transfer(ethMarketingAndDev.mul(70).div(100)); payable(developmentWallet).transfer(ethMarketingAndDev.mul(30).div(100)); } if(ethReflection > 0) try distributor.deposit{value: ethReflection}() {} catch {} if(ethStaking > 0){ try staking.distributeUsdtToStaking{value: ethStaking}() {} catch {} } if(ethLiquid > 0) addLiquidity(otherHalf, ethLiquid); }",
        "vulnerability": "Potential division by zero",
        "reason": "In the `swapAndSend` function, there is a potential division by zero error in the calculation of `ethLiquid`, `ethReflection`, and `ethStaking` if `swapAmount` is zero. This can occur if the total fees are set to zero. Although this might be a rare scenario, it is crucial to handle such edge cases to prevent runtime errors.",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol"
    }
]