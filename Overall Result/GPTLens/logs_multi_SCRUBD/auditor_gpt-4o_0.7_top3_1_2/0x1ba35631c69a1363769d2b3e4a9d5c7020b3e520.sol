[
    {
        "function_name": "rebalance",
        "code": "function rebalance() public { Lender newProvider = recommend(); if (newProvider != provider) { _withdrawAll(); } if (balance() > 0) { if (newProvider == Lender.DYDX) { supplyDydx(balance()); } else if (newProvider == Lender.FULCRUM) { supplyFulcrum(balance()); } else if (newProvider == Lender.COMPOUND) { supplyCompound(balance()); } else if (newProvider == Lender.AAVE) { supplyAave(balance()); } } provider = newProvider; }",
        "vulnerability": "Potentially high gas cost due to full withdrawal and redeposit",
        "reason": "The 'rebalance' function withdraws all assets from the current provider before depositing them into a new one. This process can incur high gas costs and inefficiencies, especially if rebalancing occurs frequently. An attacker could exploit this inefficiency to increase transaction costs for the contract, potentially draining funds via gas fees.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "usdcToETH",
        "code": "function usdcToETH(uint256 _amount) internal returns(uint256) { IERC20(usdc).safeApprove(uniswapRouter, 0); IERC20(usdc).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = usdc; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Unbounded slippage in Uniswap swaps",
        "reason": "The 'usdcToETH' function performs a swap on Uniswap without specifying a minimum output amount (amountOutMin is set to 0). This can lead to significant slippage, allowing attackers to manipulate prices and drain funds during the token swap by front-running the transaction.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Unbounded slippage in Uniswap ETH to token swaps",
        "reason": "Similar to the 'usdcToETH' function, 'buyNBurn' performs an ETH to token swap on Uniswap without specifying a minimum output amount. This lack of slippage protection allows for front-running attacks and price manipulation, potentially causing the contract to lose significant value during swaps.",
        "file_name": "0x1ba35631c69a1363769d2b3e4a9d5c7020b3e520.sol"
    }
]