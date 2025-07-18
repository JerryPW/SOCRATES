[
    {
        "function_name": "GoLive",
        "code": "function GoLive() external onlyOwner returns (bool){ require(!live, \"ERC20: Trades already Live!\"); activeTradingBlock = block.number; sniperPenaltyEnd = block.timestamp.add(5 days); IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniV2Router = _uniV2Router; uniV3Router = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45; isContractsExcluded[address(uniV2Router)] = true; isContractsExcluded[address(uniV3Router)] = true; isMaxWalletExcluded[address(uniV2Router)] = true; internalApprove(address(this), address(uniV2Router), tokenSupply); uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH()); isContractsExcluded[address(uniV2Pair)] = true; isMaxWalletExcluded[address(uniV2Pair)] = true; require(address(this).balance > 0, \"ERC20: Must have ETH on contract to Go Live!\"); addLiquidity(balanceOf(address(this)), address(this).balance); launchSetLiquidityAddress(dead); maxWalletOn = true; swapAndLiquifyStatus = true; limitsOn = true; live = true; return true; }",
        "vulnerability": "Potential Misuse of GoLive",
        "reason": "The GoLive function can only be called once, but if there is an issue during its execution, it cannot be retried. Additionally, if an attacker gains control over the owner account before GoLive is called, they could manipulate the contract's initial settings and liquidity pool.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "AirDrop",
        "code": "function AirDrop(address[] memory wallets, uint256[] memory percent) external onlyOwner{ require(wallets.length < 100, \"Can only airdrop 100 wallets per txn due to gas limits\"); for(uint256 i = 0; i < wallets.length; i++){ address wallet = wallets[i]; uint256 amount = tokenSupply.mul(percent[i]).div(100); internalTransfer(_msgSender(), wallet, amount); } }",
        "vulnerability": "Massive Airdrop Overflow",
        "reason": "The AirDrop function allows sending a large percentage of the total supply to multiple addresses in one transaction. This can be misused to quickly drain the contract's balance or to distribute tokens unfairly, especially if the percentage values are high.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    },
    {
        "function_name": "manualBurnTokensFromLP",
        "code": "function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){ require(percent <= 10, \"ERC20: May not nuke more than 10% of tokens in LP\"); uint256 liquidityPairBalance = this.balanceOf(uniV2Pair); uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2); if (amountToBurn > 0){ internalTransfer(uniV2Pair, dead, amountToBurn); } totalBurnedTokens = balanceOf(dead); require(totalBurnedTokens <= tokenSupply * 50 / 10**2, \"ERC20: Can not burn more then 50% of supply\"); IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair); pair.sync(); return true; }",
        "vulnerability": "Liquidity Pool Manipulation",
        "reason": "The manualBurnTokensFromLP function allows the owner to burn tokens from the liquidity pool, which could be used to artificially inflate the token price or manipulate the market. Despite a limit on burning more than 10% of tokens at once, repeated calls can deplete the liquidity pool significantly.",
        "file_name": "0x049658b3cc6ec345aaf2be7233a33da24ee82150.sol"
    }
]