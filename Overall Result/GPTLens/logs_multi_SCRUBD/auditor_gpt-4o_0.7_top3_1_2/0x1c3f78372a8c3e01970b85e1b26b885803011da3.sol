[
    {
        "function_name": "daiToETH",
        "code": "function daiToETH(uint256 _amount) internal returns(uint256) { IERC20(dai).safeApprove(uniswapRouter, 0); IERC20(dai).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = dai; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Lack of slippage protection",
        "reason": "The function uses the Uniswap `swapExactTokensForETH` function with a `amountOutMin` set to zero, which means there is no slippage protection. An attacker or a sudden market movement could manipulate the token price, resulting in a much lower amount of ETH being returned than expected.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Lack of slippage protection",
        "reason": "Similar to the `daiToETH` function, this function also lacks slippage protection by setting the `amountOutMin` to zero. This allows for significant price manipulation and potential loss of funds during the token swap.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares, '#1 Total supply sub error'); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b, '#2 Withdraw some sub error')); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = daiToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = calcPoolValueInToken(); rebalance(); }",
        "vulnerability": "Reentrancy vulnerability in external call",
        "reason": "The `withdraw` function makes an external call to `devTreasury` using a low-level call without proper reentrancy protection around this transfer. Although it uses the `nonReentrant` modifier, the execution order and lack of checks post-transfer could be exploited if the modifier doesn't fully guard against reentrant calls.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    }
]