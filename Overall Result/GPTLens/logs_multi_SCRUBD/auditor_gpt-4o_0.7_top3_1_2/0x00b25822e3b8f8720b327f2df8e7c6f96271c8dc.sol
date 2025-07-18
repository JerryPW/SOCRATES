[
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { bool success; (success,) = address(owner()).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The 'withdrawStuckETH' function directly sends all ETH balance to the owner without any reentrancy guard. An attacker could potentially exploit this by re-entering the contract before the ETH transfer completes, especially if another function in the contract allows ETH deposits, leading to potential loss of funds.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    },
    {
        "function_name": "taxTokenSwap",
        "code": "function taxTokenSwap() internal lockTheSwap { uint256 contractBalance = balanceOf(address(this)); uint256 totalTokensToSwap = marketingTokens.add(treasuryTokens).add(liquidityTokens); uint256 swapLiquidityTokens = liquidityTokens.div(2); uint256 amountToSwapForETH = contractBalance.sub(swapLiquidityTokens); uint256 initialETHBalance = address(this).balance; swapTokensForETH(amountToSwapForETH); uint256 ethBalance = address(this).balance.sub(initialETHBalance); uint256 ethForMarketing = ethBalance.mul(marketingTokens).div(totalTokensToSwap); uint256 ethForTreasury = ethBalance.mul(treasuryTokens).div(totalTokensToSwap); uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForTreasury); marketingTokens = 0; treasuryTokens = 0; liquidityTokens = 0; (bool success,) = address(marketingAddress).call{value: ethForMarketing}(\"\"); (success,) = address(treasuryAddress).call{value: ethForTreasury}(\"\"); if(ethForLiquidity != 0 && swapLiquidityTokens != 0) { addLiquidity(swapLiquidityTokens, ethForLiquidity); } if(address(this).balance > 5 * 1e17){ (success,) = address(devAddress).call{value: address(this).balance}(\"\"); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "This function transfers ETH to multiple addresses without using a reentrancy guard for each transfer. If any of these addresses are contracts with a fallback function, they could re-enter and exploit the contract, potentially draining funds or causing unintended behavior.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    },
    {
        "function_name": "OpenMarket",
        "code": "function OpenMarket() external onlyOwner returns (bool){ require(!active, \"ERC20: Trades already active!\"); LiveBlock = block.number; EndSniperPen = block.timestamp.add(7 days); IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniV2Router = _uniV2Router; _MaxExclude[address(uniV2Router)] = true; ContractApprove(address(this), address(uniV2Router), _Supply); uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH()); _MaxExclude[address(uniV2Pair)] = true; require(address(this).balance > 0, \"ERC20: Must have ETH on contract to Go active!\"); addLiquidity(balanceOf(address(this)), address(this).balance); setLiquidityAddress(DEAD); maxWalletOn = true; sals = true; actions = true; active = true; return true; }",
        "vulnerability": "Liquidity Locking Issue",
        "reason": "The function 'OpenMarket' initializes the liquidity pool and sets the liquidity address to a dead address immediately after adding liquidity. This action locks the liquidity forever without any possibility for recovery or migration, which can be problematic for future upgrades or maintenance of the liquidity pool.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    }
]