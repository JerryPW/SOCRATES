[
    {
        "function_name": "GoLive",
        "code": "function GoLive() external onlyOwner returns (bool){ require(!live, \"ERC20: Trades already Live!\"); activeTradingBlock = block.number; sniperPenaltyEnd = block.timestamp.add(2 days); IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniV2Router = _uniV2Router; uniV3Router = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45; isContractsExcluded[address(uniV2Router)] = true; isContractsExcluded[address(uniV3Router)] = true; isMaxWalletExcluded[address(uniV2Router)] = true; internalApprove(address(this), address(uniV2Router), tokenSupply); uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH()); isContractsExcluded[address(uniV2Pair)] = true; isMaxWalletExcluded[address(uniV2Pair)] = true; require(address(this).balance > 0, \"ERC20: Must have ETH on contract to Go Live!\"); addLiquidity(balanceOf(address(this)), address(this).balance); launchSetLiquidityAddress(dead); maxWalletOn = true; swapAndLiquifyStatus = true; limitsOn = true; live = true; return true; }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The `GoLive` function requires the contract to have ETH balance to execute successfully. If an attacker drains the ETH balance before the owner calls this function, it would prevent the contract from going live, effectively creating a denial of service.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { bool success; (success,) = address(owner()).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Full balance withdrawal by owner",
        "reason": "The `withdrawStuckETH` function allows the owner to withdraw the entire ETH balance of the contract at any point. This functionality could be abused by a malicious owner to drain the contract's ETH.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Potential impact on liquidity",
        "reason": "The `manualBurnTokensFromLP` function allows the owner to burn a significant portion of tokens from the liquidity pool. Although restricted to 10% per call, repeated calls can severely impact the token's liquidity and market stability.",
        "file_name": "0x0030f75e27f6df16383f47ae11ae34abc21f5f2c.sol"
    }
]