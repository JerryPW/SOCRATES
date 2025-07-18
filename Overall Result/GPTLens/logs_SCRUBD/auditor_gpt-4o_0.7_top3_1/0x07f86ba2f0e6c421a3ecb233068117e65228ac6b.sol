[
    {
        "function_name": "swapBack",
        "code": "function swapBack() private lockTheSwap { uint256 contractBalance = balanceOf(address(this)); uint256 totalTokensToSwap = _liquidityTokensToSwap + _teamTokensToSwap; uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2); uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity); uint256 initialETHBalance = address(this).balance; swapTokensForETH(amountToSwapForETH); uint256 ethBalance = address(this).balance.sub(initialETHBalance); uint256 ethForMarketing = ethBalance.mul(_teamTokensToSwap).div(totalTokensToSwap); uint256 ethForLiquidity = ethBalance.sub(ethForMarketing); uint256 ethForDev = ethForMarketing.mul(_percentTeamFundsToDev).div(1000); uint256 ethForTreasury = ethForMarketing .mul(_percentTeamFundsToTreasury).div(1000); ethForMarketing -= ethForDev; ethForMarketing -= ethForTreasury; _liquidityTokensToSwap = 0; _teamTokensToSwap = 0; (bool success, ) = address(marketingAddress).call{ value: ethForMarketing }(\"\"); (success, ) = address(devAddress).call{ value: ethForDev }(\"\"); (success, ) = address(treasuryAddress).call{ value: ethForTreasury }( \"\" ); addLiquidity(tokensForLiquidity, ethForLiquidity); emit SwapAndLiquify( amountToSwapForETH, ethForLiquidity, tokensForLiquidity ); if (address(this).balance > 1e17) { (success, ) = address(marketingAddress).call{ value: address(this).balance }(\"\"); } }",
        "vulnerability": "Improper ETH distribution",
        "reason": "The swapBack function attempts to distribute ETH to multiple addresses using .call without checking the success of the calls. This can lead to loss of funds if any address reverts the transaction, and the function does not handle such failures gracefully.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() internal onlyOwner { tradingActive = true; swapAndLiquifyEnabled = true; tradingActiveBlock = block.number; }",
        "vulnerability": "Trading activation without limit",
        "reason": "The enableTrading function can be called by the owner to activate trading without any restrictions. This can potentially allow the owner to manipulate trading states for personal gain, such as enabling trading when conditions are favorable to them.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "forceSwapBack",
        "code": "function forceSwapBack() external onlyOwner { uint256 contractBalance = balanceOf(address(this)); require( contractBalance >= _tTotal / 100, \"Can only swap back if more than 1% of tokens stuck on contract\" ); swapBack(); emit OwnerForcedSwapBack(block.timestamp); }",
        "vulnerability": "Owner can force swapBack",
        "reason": "The forceSwapBack function allows the owner to trigger the swapBack at any time as long as the condition is met. This gives the owner undue control over the contract's ETH and token balances, enabling them to potentially manipulate market conditions or drain funds.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    }
]