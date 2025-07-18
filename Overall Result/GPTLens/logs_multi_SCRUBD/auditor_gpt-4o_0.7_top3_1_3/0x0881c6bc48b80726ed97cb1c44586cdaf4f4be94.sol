[
    {
        "function_name": "SwapPct",
        "code": "function SwapPct(uint256 pct) public {\n    uint256 balance = (balanceOf(address(this)) * pct) / 100;\n    if(balance > 0) {\n        uint256 tokensForLP = (balance * LPDistributionPct)/100;\n        uint256 tokensForLiquidity = tokensForLP / 2;\n        uint256 tokensToSwap = balance - tokensForLiquidity;\n        swapTokensForETH(tokensToSwap);\n        uint256 contractBalance = address(this).balance;\n        uint256 devShare = (contractBalance * DevDistributionPct)/100;\n        uint256 mktShare = (contractBalance * MarketingDistributionPct)/100;\n        DevAddress.transfer(devShare);\n        MarketingAddress.transfer(mktShare);\n        uint256 eth = address(this).balance;\n        UniswapV2Router.addLiquidityETH{value: address(this).balance}(\n            address(this),\n            tokensForLiquidity,\n            0,\n            0,\n            DevAddress,\n            block.timestamp\n        );\n        AccumulatedFeeForDistribution.LiquidityFee = 0;\n        AccumulatedFeeForDistribution.DevFee = 0;\n        AccumulatedFeeForDistribution.MarketingFee = 0;\n        TotalSwapped += tokensForLiquidity;\n        emit LiquidityAdded(tokensForLiquidity, eth);\n    }\n}",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The `SwapPct` function transfers ETH to `DevAddress` and `MarketingAddress` before interacting with external contracts like Uniswap, which can potentially lead to a reentrancy attack. If `DevAddress` or `MarketingAddress` is a contract with malicious fallback functions, it could exploit this function to reenter the contract before state variables are updated.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "_tokenTransfer",
        "code": "function _tokenTransfer(address sender, address recipient, uint256 cantidadBruta, bool takeFee) private {\n    (uint256 cantidadNeta, uint256 cantidadBrutaRefracionaria, uint256 cantidadNetaRefracionaria, TransactionFees memory feesReales, TransactionFees memory feesRefracionarios) = GenerarFeesYCantidadesATransferir(cantidadBruta, takeFee);\n    require(WalletsExcludedFromHardCap[recipient] || (balanceOf(recipient) + cantidadNeta) <= HardCap, \"Recipient cannot hold more than maxWalletAmount\");\n    BalancesRefraccionarios[sender] -= cantidadBrutaRefracionaria;\n    BalancesRefraccionarios[recipient] += cantidadNetaRefracionaria;\n    if (takeFee) {\n        ReflactionaryTotal -= feesRefracionarios.TransactionFee;\n        TotalFee += feesReales.TransactionFee;\n        AccumulateFee(feesReales, feesRefracionarios);\n        TotalTokenBurn += feesReales.BurnFee;\n        BalancesRefraccionarios[BurnAddress] += feesRefracionarios.BurnFee;\n        emit Transfer(address(this), BurnAddress, feesReales.BurnFee);\n        emit Transfer(sender, address(this), feesReales.TransferrableFee);\n    }\n    emit Transfer(sender, recipient, cantidadNeta);\n}",
        "vulnerability": "Integer Overflow/Underflow",
        "reason": "The function does not utilize safe arithmetic operations for subtraction and addition (e.g., SafeMath library), particularly in the operations involving `BalancesRefraccionarios`. This could lead to integer overflow or underflow, especially in a scenario where unexpected large values are involved.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private {\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = UniswapV2Router.WETH();\n    UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n}",
        "vulnerability": "Slippage Vulnerability",
        "reason": "The function sets the minimum amount of ETH to be received to 0, which means that it does not account for slippage. An attacker could manipulate the token price to receive significantly less ETH than expected, causing loss of value and funds for the contract.",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    }
]