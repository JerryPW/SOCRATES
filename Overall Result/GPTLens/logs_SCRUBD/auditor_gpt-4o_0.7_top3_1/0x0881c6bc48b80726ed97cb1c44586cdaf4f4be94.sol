[
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private {\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = UniswapV2Router.WETH();\n    UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n}",
        "vulnerability": "Potential frontrunning",
        "reason": "The function swaps tokens for ETH with a minimum amount output of 0, which could allow an attacker to frontrun the transaction to benefit from the slippage, effectively draining the contract's token balance without getting a fair return in ETH.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "SwapPct",
        "code": "function SwapPct(uint256 pct) public {\n    uint256 balance = (balanceOf(address(this)) * pct) / 100;\n    if(balance > 0) {\n        uint256 tokensForLP = (balance * LPDistributionPct)/100;\n        uint256 tokensForLiquidity = tokensForLP / 2;\n        uint256 tokensToSwap = balance - tokensForLiquidity;\n        swapTokensForETH(tokensToSwap);\n        uint256 contractBalance = address(this).balance;\n        uint256 devShare = (contractBalance * DevDistributionPct)/100;\n        uint256 mktShare = (contractBalance * MarketingDistributionPct)/100;\n        DevAddress.transfer(devShare);\n        MarketingAddress.transfer(mktShare);\n        uint256 eth = address(this).balance;\n        UniswapV2Router.addLiquidityETH{value: address(this).balance}(\n            address(this),\n            tokensForLiquidity,\n            0,\n            0,\n            DevAddress,\n            block.timestamp\n        );\n        AccumulatedFeeForDistribution.LiquidityFee = 0;\n        AccumulatedFeeForDistribution.DevFee = 0;\n        AccumulatedFeeForDistribution.MarketingFee = 0;\n        TotalSwapped += tokensForLiquidity;\n        emit LiquidityAdded(tokensForLiquidity, eth);\n    }\n}",
        "vulnerability": "Unrestricted access to swap function",
        "reason": "The SwapPct function is public and allows any user to initiate token swaps and liquidity provision. This could result in unnecessary or malicious swaps that could deplete the contract's token reserves or manipulate the token price.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify() private swaping {\n    if(balanceOf(address(this)) > 0) {\n        uint256 tokensToSwap = AccumulatedFeeForDistribution.LiquidityFee / 2;\n        uint256 tokensForLiquidity = AccumulatedFeeForDistribution.LiquidityFee - tokensToSwap;\n        swapTokensForETH(AccumulatedFeeForDistribution.DevFee + AccumulatedFeeForDistribution.MarketingFee + tokensToSwap);\n        uint256 contractBalance = address(this).balance;\n        uint256 devShare = (contractBalance* DevDistributionPct)/100;\n        uint256 mktShare = (contractBalance * MarketingDistributionPct)/100;\n        DevAddress.transfer(devShare);\n        MarketingAddress.transfer(mktShare);\n        uint256 eth = address(this).balance;\n        UniswapV2Router.addLiquidityETH{value: address(this).balance}(\n            address(this),\n            tokensForLiquidity,\n            0,\n            0,\n            DevAddress,\n            block.timestamp\n        );\n        AccumulatedFeeForDistribution.LiquidityFee = 0;\n        AccumulatedFeeForDistribution.DevFee = 0;\n        AccumulatedFeeForDistribution.MarketingFee = 0;\n        TotalSwapped += tokensForLiquidity;\n        emit LiquidityAdded(tokensForLiquidity, eth);\n    }\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses call to transfer ETH after swapping tokens. Without proper reentrancy guards, attackers could exploit this by re-entering the contract before state changes are finalized, potentially draining funds.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    }
]