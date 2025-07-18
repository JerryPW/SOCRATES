[
    {
        "function_name": "usdtToETH",
        "code": "function usdtToETH(uint256 _amount) internal returns(uint256) {\n    IERC20(usdt).safeApprove(uniswapRouter, 0);\n    IERC20(usdt).safeApprove(uniswapRouter, _amount);\n    address[] memory path = new address[](2);\n    path[0] = usdt;\n    path[1] = weth;\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Improper Handling of Minimum Output Amount",
        "reason": "The function sets the minimum amount of ETH expected from the swap to zero. This makes the contract vulnerable to slippage or front-running attacks where an attacker can profit by manipulating the pool balance to cause the swap to occur at an unfavorable rate.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) {\n    address[] memory path = new address[](2);\n    path[0] = weth;\n    path[1] = address(yeldToken);\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Improper Handling of Minimum Output Amount",
        "reason": "Like the usdtToETH function, this function also sets the minimum amount of tokens expected from the swap to zero. This exposes the contract to significant slippage risks where the actual amount of tokens received can be far less than expected, potentially benefiting attackers who manipulate the Uniswap pool.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant {\n    require(_shares > 0, \"withdraw must be greater than 0\");\n    uint256 ibalance = balanceOf(msg.sender);\n    require(_shares <= ibalance, \"insufficient balance\");\n    pool = _calcPoolValueInToken();\n    uint256 generatedYelds = getGeneratedYelds();\n    uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply);\n    _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\");\n    _totalSupply = _totalSupply.sub(_shares);\n    emit Transfer(msg.sender, address(0), _shares);\n    uint256 b = IERC20(token).balanceOf(address(this));\n    if (b < stablecoinsToWithdraw) {\n        _withdrawSome(stablecoinsToWithdraw.sub(b));\n    }\n    uint256 onePercent = stablecoinsToWithdraw.div(100);\n    depositBlockStarts[msg.sender] = block.number;\n    yeldToken.transfer(msg.sender, generatedYelds);\n    uint256 stakingProfits = usdtToETH(onePercent);\n    uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0));\n    if (tokensAlreadyBurned < maximumTokensToBurn) {\n        uint256 ethToSwap = stakingProfits.mul(98).div(100);\n        buyNBurn(ethToSwap);\n        uint256 retirementYeld = stakingProfits.mul(2).div(100);\n        retirementYeldTreasury.transfer(retirementYeld);\n    } else {\n        uint256 retirementYeld = stakingProfits;\n        retirementYeldTreasury.transfer(retirementYeld);\n    }\n    IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(onePercent));\n    pool = _calcPoolValueInToken();\n    rebalance();\n}",
        "vulnerability": "Insufficient Balance Check for External Transfers",
        "reason": "The withdraw function transfers generated Yeld tokens to the caller without checking the contract's balance of Yeld tokens. If the contract doesn't have enough Yeld tokens, this will revert, potentially blocking withdrawals. An attacker could exploit this by ensuring the contract doesn't hold sufficient Yeld tokens, thus preventing other users from withdrawing.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    }
]