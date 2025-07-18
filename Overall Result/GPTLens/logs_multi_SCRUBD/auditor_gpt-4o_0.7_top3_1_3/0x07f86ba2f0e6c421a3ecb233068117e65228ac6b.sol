[
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() internal onlyOwner { tradingActive = true; swapAndLiquifyEnabled = true; tradingActiveBlock = block.number; }",
        "vulnerability": "Trading can be enabled by the owner.",
        "reason": "The `enableTrading` function is marked as `internal` and can be called by the `onlyOwner`. This allows the owner to enable trading at any time, but does not provide a mechanism to ensure that trading is enabled in a fair manner. This could be exploited by enabling trading at a time advantageous to the owner or a small group of individuals, leading to unfair trading practices.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "forceSwapBack",
        "code": "function forceSwapBack() external onlyOwner { uint256 contractBalance = balanceOf(address(this)); require( contractBalance >= _tTotal / 100, \"Can only swap back if more than 1% of tokens stuck on contract\" ); swapBack(); emit OwnerForcedSwapBack(block.timestamp); }",
        "vulnerability": "Owner can force swap back operations.",
        "reason": "The `forceSwapBack` function allows the owner to trigger the `swapBack` operation, which swaps tokens for ETH. This could be exploited by the owner to manipulate the liquidity pool or market conditions, especially if the contract holds a significant amount of tokens. Such operations could affect the token price or liquidity, potentially benefiting the owner at the expense of other token holders.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success, ) = address(msg.sender).call{ value: address(this).balance }( \"\" ); }",
        "vulnerability": "Owner can withdraw ETH before trading starts.",
        "reason": "The `withdrawStuckETH` function allows the owner to withdraw all ETH from the contract's balance before trading is active. This could be exploited to remove initial liquidity or any ETH sent to the contract in error, potentially undermining the contract's ability to execute other functions that require ETH. This could affect the contract's operation or cause loss of funds that might have been intended for initial liquidity.",
        "file_name": "0x07f86ba2f0e6c421a3ecb233068117e65228ac6b.sol"
    }
]