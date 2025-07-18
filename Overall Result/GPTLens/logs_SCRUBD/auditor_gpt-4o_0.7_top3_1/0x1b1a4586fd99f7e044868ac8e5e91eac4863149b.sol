[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant {\n    require(_shares > 0, \"withdraw must be greater than 0\");\n    uint256 ibalance = balanceOf(msg.sender);\n    require(_shares <= ibalance, \"insufficient balance\");\n    pool = _calcPoolValueInToken();\n    uint256 generatedYelds = getGeneratedYelds();\n    uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply);\n    _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\");\n    _totalSupply = _totalSupply.sub(_shares);\n    emit Transfer(msg.sender, address(0), _shares);\n    uint256 b = IERC20(token).balanceOf(address(this));\n    if (b < stablecoinsToWithdraw) {\n        _withdrawSome(stablecoinsToWithdraw.sub(b));\n    }\n    uint256 onePercent = stablecoinsToWithdraw.div(100);\n    depositBlockStarts[msg.sender] = block.number;\n    yeldToken.transfer(msg.sender, generatedYelds);\n    uint256 stakingProfits = usdtToETH(onePercent);\n    uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0));\n    if (tokensAlreadyBurned < maximumTokensToBurn) {\n        uint256 ethToSwap = stakingProfits.mul(98).div(100);\n        buyNBurn(ethToSwap);\n        uint256 retirementYeld = stakingProfits.mul(2).div(100);\n        retirementYeldTreasury.transfer(retirementYeld);\n    } else {\n        uint256 retirementYeld = stakingProfits;\n        retirementYeldTreasury.transfer(retirementYeld);\n    }\n    IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(onePercent));\n    pool = _calcPoolValueInToken();\n    rebalance();\n}",
        "vulnerability": "Denial of Service (DoS) via Token Transfer",
        "reason": "The function relies on external contract calls when transferring tokens and ETH. If any of these external calls fail, the entire transaction will revert, potentially leading to a Denial of Service (DoS) situation if the token or ETH transfer fails repeatedly.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    },
    {
        "function_name": "usdtToETH",
        "code": "function usdtToETH(uint256 _amount) internal returns(uint256) {\n    IERC20(usdt).safeApprove(uniswapRouter, 0);\n    IERC20(usdt).safeApprove(uniswapRouter, _amount);\n    address[] memory path = new address[](2);\n    path[0] = usdt;\n    path[1] = weth;\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Unsafe External Call to Uniswap",
        "reason": "The function makes an external call to the Uniswap contract without checking the return value or handling potential exceptions, which could lead to unexpected behavior if the Uniswap call fails or behaves maliciously.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) {\n    address[] memory path = new address[](2);\n    path[0] = weth;\n    path[1] = address(yeldToken);\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Potential Loss of Funds via Uniswap Call",
        "reason": "The function involves an external call to Uniswap to swap ETH for tokens without checking for successful execution, which could lead to loss of funds if the call fails or doesn't execute as expected.",
        "file_name": "0x1b1a4586fd99f7e044868ac8e5e91eac4863149b.sol"
    }
]