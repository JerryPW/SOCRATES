[
    {
        "function_name": "buyNBurn",
        "vulnerability": "Potential reentrancy",
        "criticism": "The reasoning correctly identifies the lack of a `nonReentrant` modifier, which is a best practice to prevent reentrancy attacks. However, the function interacts with Uniswap, a well-audited and trusted contract, reducing the likelihood of reentrancy. Additionally, the function is marked as `internal`, limiting external access. The severity is low due to the trusted nature of Uniswap, and profitability is low as an attacker would need to exploit Uniswap itself.",
        "correctness": 6,
        "severity": 2,
        "profitability": 1,
        "reason": "The function `buyNBurn` makes an external call to the Uniswap contract without using the `nonReentrant` modifier. This could open up the possibility of a reentrancy attack if the Uniswap contract or any token it handles calls back into this contract. Although Uniswap is generally trusted, it is best practice to guard against reentrancy.",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "withdraw",
        "vulnerability": "State inconsistency",
        "criticism": "The reasoning is correct in identifying that updating state variables after a transfer can lead to inconsistencies if the transfer fails. However, the function uses `safeTransfer`, which reverts on failure, mitigating this risk. The severity is moderate as it could lead to state inconsistencies if not handled properly, but the use of `safeTransfer` reduces the likelihood. Profitability is low as exploiting this would require a failed transfer, which reverts the transaction.",
        "correctness": 7,
        "severity": 3,
        "profitability": 1,
        "reason": "The `withdraw` function updates `depositBlockStarts[msg.sender]` and `depositAmount[msg.sender]` after transferring tokens, which could lead to inconsistencies if the transfer fails. This could potentially leave the contract in an inconsistent state where the balances do not reflect the actual state of the contract.",
        "code": "function withdraw(uint256 _shares) external nonReentrant noContract { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares, '#1 Total supply sub error'); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b, '#2 Withdraw some sub error')); } uint256 totalPercentage = percentageRetirementYield.add(percentageDevTreasury).add(percentageBuyBurn); uint256 combined = stablecoinsToWithdraw.mul(totalPercentage).div(1e20); depositBlockStarts[msg.sender] = block.number; depositAmount[msg.sender] = depositAmount[msg.sender].sub(stablecoinsToWithdraw); yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = daiToETH(combined); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); uint256 devTreasuryAmount = stakingProfits.mul(uint256(100e18).mul(percentageDevTreasury).div(totalPercentage)).div(100e18); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(uint256(100e18).mul(percentageBuyBurn).div(totalPercentage)).div(100e18); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(uint256(100e18).mul(percentageRetirementYield).div(totalPercentage)).div(100e18); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits.sub(devTreasuryAmount); retirementYeldTreasury.transfer(retirementYeld); } (bool success, ) = devTreasury.call.value(devTreasuryAmount)(\"\"); require(success, \"Dev treasury transfer failed\"); IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(combined)); pool = calcPoolValueInToken(); rebalance(); }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "daiToETH",
        "vulnerability": "Price slippage risk",
        "criticism": "The reasoning is correct in identifying the risk of price slippage due to the use of a minimum output amount of 0. This exposes the contract to receiving significantly less ETH than expected if market conditions change. The severity is high as it can lead to substantial financial loss, and profitability is high for an attacker who can manipulate market conditions to their advantage.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The `daiToETH` function calls `swapExactTokensForETH` with a minimum output amount of 0. This exposes the transaction to significant price slippage, potentially resulting in the contract receiving far less ETH than expected. An attacker could exploit this by manipulating market conditions at the time of the swap.",
        "code": "function daiToETH(uint256 _amount) internal returns(uint256) { IERC20(dai).safeApprove(uniswapRouter, 0); IERC20(dai).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = dai; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    }
]