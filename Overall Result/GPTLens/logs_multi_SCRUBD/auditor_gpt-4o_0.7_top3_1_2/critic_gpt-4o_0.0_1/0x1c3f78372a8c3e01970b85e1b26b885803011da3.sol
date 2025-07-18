[
    {
        "function_name": "daiToETH",
        "vulnerability": "Lack of slippage protection",
        "criticism": "The reasoning is correct. The function indeed sets the `amountOutMin` to zero, which means there is no slippage protection. This can lead to significant losses if the market price changes unfavorably between the time the transaction is submitted and when it is executed. The severity is moderate to high because it can result in substantial financial loss. The profitability for an attacker is moderate, as they could potentially manipulate the market to exploit this lack of protection.",
        "correctness": 9,
        "severity": 7,
        "profitability": 5,
        "reason": "The function uses the Uniswap `swapExactTokensForETH` function with a `amountOutMin` set to zero, which means there is no slippage protection. An attacker or a sudden market movement could manipulate the token price, resulting in a much lower amount of ETH being returned than expected.",
        "code": "function daiToETH(uint256 _amount) internal returns(uint256) { IERC20(dai).safeApprove(uniswapRouter, 0); IERC20(dai).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = dai; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "buyNBurn",
        "vulnerability": "Lack of slippage protection",
        "criticism": "The reasoning is correct. Similar to the `daiToETH` function, this function also sets `amountOutMin` to zero, lacking slippage protection. This exposes the function to the same risks of price manipulation and potential financial loss. The severity is similar to the `daiToETH` function, as it can lead to significant losses. The profitability for an attacker is also moderate, as they could manipulate the market to exploit this vulnerability.",
        "correctness": 9,
        "severity": 7,
        "profitability": 5,
        "reason": "Similar to the `daiToETH` function, this function also lacks slippage protection by setting the `amountOutMin` to zero. This allows for significant price manipulation and potential loss of funds during the token swap.",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability in external call",
        "criticism": "The reasoning is partially correct. While the function uses a `nonReentrant` modifier, which is a common protection against reentrancy attacks, the concern about the low-level call to `devTreasury` is valid. However, the `nonReentrant` modifier should provide sufficient protection if implemented correctly. The severity is low to moderate because the modifier is expected to prevent reentrancy, but the use of low-level calls without further checks can still be risky. The profitability is low because exploiting this would require bypassing the `nonReentrant` protection, which is not trivial.",
        "correctness": 6,
        "severity": 3,
        "profitability": 2,
        "reason": "The `withdraw` function makes an external call to `devTreasury` using a low-level call without proper reentrancy protection around this transfer. Although it uses the `nonReentrant` modifier, the execution order and lack of checks post-transfer could be exploited if the modifier doesn't fully guard against reentrant calls.",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares, '#1 Total supply sub error'); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b, '#2 Withdraw some sub error')); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = daiToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = calcPoolValueInToken(); rebalance(); }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    }
]