[
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "ETH sent to zero address",
        "reason": "The function specifies 'address(0)' as the recipient for the swap. This means that the received tokens from the swap will be sent to the zero address, effectively burning them. This results in a loss of tokens that were intended to be utilized elsewhere in the contract.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "usdcToETH",
        "code": "function usdcToETH(uint256 _amount) internal returns(uint256) { IERC20(usdc).safeApprove(uniswapRouter, 0); IERC20(usdc).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = usdc; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Improper approval reset",
        "reason": "The function resets allowance to zero before setting the desired amount, which can potentially open up a race condition. An attacker can use a front-running attack to call the transfer function between these two calls, leading to a double transfer of funds.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = _calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b)); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = usdcToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).transfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = _calcPoolValueInToken(); rebalance(); }",
        "vulnerability": "Reentrancy in external calls",
        "reason": "The function calls external functions like 'usdcToETH' and 'buyNBurn', and then transfers funds using 'transfer'. This allows for a potential reentrancy attack if combined with another vulnerability where a malicious contract can call back into the contract before the state is fully updated.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    }
]