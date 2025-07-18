[
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The buyNBurn function calls swapExactETHForTokens on the Uniswap interface using call.value, which can allow reentrancy if the target contract is malicious. Since the function lacks a reentrancy guard, an attacker could reenter the contract during the ETH transfer process and manipulate state or balances.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = _calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); yeldHoldingRequirement(stablecoinsToWithdraw); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b)); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; if (stablecoinsToWithdraw > depositAmount[msg.sender]) { depositAmount[msg.sender] = 0; } else { depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); } yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = usdcToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).transfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = _calcPoolValueInToken(); rebalance(); }",
        "vulnerability": "Inaccurate token withdrawal calculation",
        "reason": "The withdraw function calculates the stablecoinsToWithdraw based on the current pool value, which can be manipulated by an attacker to withdraw more tokens than they are entitled to. This could be achieved by influencing the pool value between the calculation and the actual token transfer.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    },
    {
        "function_name": "usdcToETH",
        "code": "function usdcToETH(uint256 _amount) internal returns(uint256) { IERC20(usdc).safeApprove(uniswapRouter, 0); IERC20(usdc).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = usdc; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Approval race condition",
        "reason": "The function usdcToETH calls safeApprove with a zero amount before setting the actual amount, which creates a race condition. This can be exploited by an attacker to front-run the transaction and potentially manipulate token approvals, leading to unauthorized transfers.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    }
]