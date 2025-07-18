[
    {
        "function_name": "launch",
        "code": "function launch() external onlyOwner returns (bool) { require(!tradingActive, \"Trading is already active, cannot relaunch.\"); enableTrading(); IUniswapV2Router _uniswapV2Router = IUniswapV2Router( 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ); excludeFromMaxTransaction(address(_uniswapV2Router), true); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()) .createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); require( address(this).balance > 0, \"Must have ETH on contract to launch\" ); addLiquidity(balanceOf(address(this)), address(this).balance); transferOwnership(_owner); return true; }",
        "vulnerability": "Potential loss of ownership",
        "reason": "The function `launch` transfers ownership back to the `_owner` at the end of the function. This could lead to a potential loss of ownership control if the owner has transferred ownership to another address for security purposes before calling this function. Additionally, if the function is called again, it will revert because of the initial `require` check, but if bypassed, it could lead to unexpected ownership changes.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() private lockTheSwap { uint256 contractBalance = balanceOf(address(this)); uint256 totalTokensToSwap = _liquidityTokensToSwap + _teamTokensToSwap; uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2); uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity); uint256 initialETHBalance = address(this).balance; swapTokensForETH(amountToSwapForETH); uint256 ethBalance = address(this).balance.sub(initialETHBalance); uint256 ethForMarketing = ethBalance.mul(_teamTokensToSwap).div( totalTokensToSwap ); uint256 ethForLiquidity = ethBalance.sub(ethForMarketing); uint256 ethForDev = ethForMarketing.mul(_percentTeamFundsToDev).div( 1000 ); uint256 ethForTreasury = ethForMarketing .mul(_percentTeamFundsToTreasury) .div(1000); ethForMarketing -= ethForDev; ethForMarketing -= ethForTreasury; _liquidityTokensToSwap = 0; _teamTokensToSwap = 0; (bool success, ) = address(marketingAddress).call{ value: ethForMarketing }(\"\"); (success, ) = address(devAddress).call{ value: ethForDev }(\"\"); (success, ) = address(treasuryAddress).call{ value: ethForTreasury }( \"\" ); addLiquidity(tokensForLiquidity, ethForLiquidity); emit SwapAndLiquify( amountToSwapForETH, ethForLiquidity, tokensForLiquidity ); if (address(this).balance > 1e17) { (success, ) = address(marketingAddress).call{ value: address(this).balance }(\"\"); } }",
        "vulnerability": "Incorrect ETH distribution logic",
        "reason": "The function `swapBack` calculates `ethForMarketing`, `ethForDev`, and `ethForTreasury` based on the `ethForMarketing` amount derived from `ethBalance`. However, the calculation for `ethForLiquidity` directly subtracts `ethForMarketing`, which includes both dev and treasury amounts. This can lead to incorrect distribution of ETH, potentially allocating more ETH than intended to marketing, dev, or treasury addresses, especially if the value of `_percentTeamFundsToDev` and `_percentTeamFundsToTreasury` are not set correctly.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "addToBlacklist",
        "code": "function addToBlacklist(address account) external onlyOwner { require(account != address(0), \"Cannot blacklist 0 address\"); blacklist[account] = true; }",
        "vulnerability": "Centralized control over blacklist",
        "reason": "The function `addToBlacklist` allows the owner to unilaterally blacklist any account, which can prevent that account from participating in token transfers. This centralized control can be abused or misused, leading to potential censorship of legitimate users. It poses a risk if the owner account is compromised or if the owner acts maliciously.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    }
]