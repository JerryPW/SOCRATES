[
    {
        "function_name": "buyNBurn",
        "vulnerability": "ETH sent to zero address",
        "criticism": "The reasoning is correct in identifying that the tokens received from the swap are sent to the zero address, effectively burning them. This is likely an intentional design choice for token burning, rather than a vulnerability. The severity is low because it does not pose a risk to the contract's security or functionality. The profitability is also low as this does not provide any financial gain to an attacker.",
        "correctness": 8,
        "severity": 2,
        "profitability": 0,
        "reason": "The function specifies 'address(0)' as the recipient for the swap. This means that the received tokens from the swap will be sent to the zero address, effectively burning them. This results in a loss of tokens that were intended to be utilized elsewhere in the contract.",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "usdcToETH",
        "vulnerability": "Improper approval reset",
        "criticism": "The reasoning is incorrect. The function correctly resets the allowance to zero before setting a new one, which is a common practice to prevent race conditions. The concern about a front-running attack is not valid in this context because the approval reset is a standard security measure. Therefore, the severity and profitability are both low.",
        "correctness": 2,
        "severity": 1,
        "profitability": 0,
        "reason": "The function resets allowance to zero before setting the desired amount, which can potentially open up a race condition. An attacker can use a front-running attack to call the transfer function between these two calls, leading to a double transfer of funds.",
        "code": "function usdcToETH(uint256 _amount) internal returns(uint256) { IERC20(usdc).safeApprove(uniswapRouter, 0); IERC20(usdc).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = usdc; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy in external calls",
        "criticism": "The reasoning is partially correct. While the function does make external calls, it is protected by the 'nonReentrant' modifier, which prevents reentrancy attacks. However, the presence of multiple external calls could still pose a risk if the modifier is not correctly implemented. The severity is moderate due to the potential for reentrancy if the modifier fails, but the profitability is low as exploiting this would require additional vulnerabilities.",
        "correctness": 5,
        "severity": 4,
        "profitability": 2,
        "reason": "The function calls external functions like 'usdcToETH' and 'buyNBurn', and then transfers funds using 'transfer'. This allows for a potential reentrancy attack if combined with another vulnerability where a malicious contract can call back into the contract before the state is fully updated.",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = _calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b)); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = usdcToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).transfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = _calcPoolValueInToken(); rebalance(); }",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    }
]