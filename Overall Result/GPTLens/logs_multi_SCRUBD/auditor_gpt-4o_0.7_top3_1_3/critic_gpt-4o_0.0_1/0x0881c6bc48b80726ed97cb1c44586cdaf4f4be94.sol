[
    {
        "function_name": "SwapPct",
        "vulnerability": "Reentrancy Vulnerability",
        "criticism": "The reasoning correctly identifies a potential reentrancy vulnerability due to the transfer of ETH to `DevAddress` and `MarketingAddress` before interacting with the Uniswap contract. If these addresses are contracts with malicious fallback functions, they could exploit this to reenter the contract. However, the severity is moderate because the vulnerability depends on the nature of the `DevAddress` and `MarketingAddress`. The profitability is also moderate, as an attacker could potentially drain funds if the conditions are met.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The `SwapPct` function transfers ETH to `DevAddress` and `MarketingAddress` before interacting with external contracts like Uniswap, which can potentially lead to a reentrancy attack. If `DevAddress` or `MarketingAddress` is a contract with malicious fallback functions, it could exploit this function to reenter the contract before state variables are updated.",
        "code": "function SwapPct(uint256 pct) public {\n    uint256 balance = (balanceOf(address(this)) * pct) / 100;\n    if(balance > 0) {\n        uint256 tokensForLP = (balance * LPDistributionPct)/100;\n        uint256 tokensForLiquidity = tokensForLP / 2;\n        uint256 tokensToSwap = balance - tokensForLiquidity;\n        swapTokensForETH(tokensToSwap);\n        uint256 contractBalance = address(this).balance;\n        uint256 devShare = (contractBalance * DevDistributionPct)/100;\n        uint256 mktShare = (contractBalance * MarketingDistributionPct)/100;\n        DevAddress.transfer(devShare);\n        MarketingAddress.transfer(mktShare);\n        uint256 eth = address(this).balance;\n        UniswapV2Router.addLiquidityETH{value: address(this).balance}(\n            address(this),\n            tokensForLiquidity,\n            0,\n            0,\n            DevAddress,\n            block.timestamp\n        );\n        AccumulatedFeeForDistribution.LiquidityFee = 0;\n        AccumulatedFeeForDistribution.DevFee = 0;\n        AccumulatedFeeForDistribution.MarketingFee = 0;\n        TotalSwapped += tokensForLiquidity;\n        emit LiquidityAdded(tokensForLiquidity, eth);\n    }\n}",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "_tokenTransfer",
        "vulnerability": "Integer Overflow/Underflow",
        "criticism": "The reasoning is correct in identifying the lack of safe arithmetic operations, which could lead to integer overflow or underflow. However, with Solidity versions 0.8.0 and above, integer overflow and underflow are automatically checked, making this vulnerability less severe. The severity is low because modern Solidity versions mitigate this risk. The profitability is also low, as exploiting this would require specific conditions that are unlikely to occur in practice.",
        "correctness": 7,
        "severity": 2,
        "profitability": 1,
        "reason": "The function does not utilize safe arithmetic operations for subtraction and addition (e.g., SafeMath library), particularly in the operations involving `BalancesRefraccionarios`. This could lead to integer overflow or underflow, especially in a scenario where unexpected large values are involved.",
        "code": "function _tokenTransfer(address sender, address recipient, uint256 cantidadBruta, bool takeFee) private {\n    (uint256 cantidadNeta, uint256 cantidadBrutaRefracionaria, uint256 cantidadNetaRefracionaria, TransactionFees memory feesReales, TransactionFees memory feesRefracionarios) = GenerarFeesYCantidadesATransferir(cantidadBruta, takeFee);\n    require(WalletsExcludedFromHardCap[recipient] || (balanceOf(recipient) + cantidadNeta) <= HardCap, \"Recipient cannot hold more than maxWalletAmount\");\n    BalancesRefraccionarios[sender] -= cantidadBrutaRefracionaria;\n    BalancesRefraccionarios[recipient] += cantidadNetaRefracionaria;\n    if (takeFee) {\n        ReflactionaryTotal -= feesRefracionarios.TransactionFee;\n        TotalFee += feesReales.TransactionFee;\n        AccumulateFee(feesReales, feesRefracionarios);\n        TotalTokenBurn += feesReales.BurnFee;\n        BalancesRefraccionarios[BurnAddress] += feesRefracionarios.BurnFee;\n        emit Transfer(address(this), BurnAddress, feesReales.BurnFee);\n        emit Transfer(sender, address(this), feesReales.TransferrableFee);\n    }\n    emit Transfer(sender, recipient, cantidadNeta);\n}",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    },
    {
        "function_name": "swapTokensForETH",
        "vulnerability": "Slippage Vulnerability",
        "criticism": "The reasoning is correct in identifying that setting the minimum amount of ETH to be received to 0 does not account for slippage, which could lead to receiving significantly less ETH than expected. This is a valid concern, as it exposes the contract to potential manipulation of token prices. The severity is moderate because it can lead to a loss of value, and the profitability is moderate as well, as an attacker could exploit this to cause financial loss to the contract.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The function sets the minimum amount of ETH to be received to 0, which means that it does not account for slippage. An attacker could manipulate the token price to receive significantly less ETH than expected, causing loss of value and funds for the contract.",
        "code": "function swapTokensForETH(uint256 tokenAmount) private {\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = UniswapV2Router.WETH();\n    UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n}",
        "file_name": "0x0881c6bc48b80726ed97cb1c44586cdaf4f4be94.sol"
    }
]