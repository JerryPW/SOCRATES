[
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() public onlyOwner { bool success; (success, ) = address(msg.sender).call{value: address(this).balance}( \"\" ); }",
        "vulnerability": "Owner can withdraw all ETH from the contract",
        "reason": "The `withdrawStuckETH` function allows the owner to withdraw all the ETH balance of the contract. This means that if ETH is sent to the contract either accidentally or as part of some operation, the owner can extract all of it, potentially leaving the contract without any ETH for operational costs like gas refunds during token transfers.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    },
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens(address tkn) public onlyOwner { require(IERC20(tkn).balanceOf(address(this)) > 0); uint256 amount = IERC20(tkn).balanceOf(address(this)); IERC20(tkn).transfer(msg.sender, amount); }",
        "vulnerability": "Owner can withdraw any ERC20 tokens from the contract",
        "reason": "The `withdrawStuckTokens` function allows the owner to withdraw all tokens of any ERC20 token held within the contract. This can be exploited if tokens are mistakenly sent to the contract, or if the contract handles other tokens as part of its operations, the owner can drain these tokens arbitrarily, which may not be expected behavior by users.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner { require(!tradingActive); uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair( address(this), uniswapV2Router.WETH() ); _approve(address(this), address(uniswapV2Pair), type(uint256).max); IERC20(uniswapV2Pair).approve( address(uniswapV2Router), type(uint256).max ); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); excludeFromMaxTransaction(address(uniswapV2Pair), true); uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp ); tradingActive = true; swapEnabled = true; }",
        "vulnerability": "Owner has control over trading activation",
        "reason": "The `openTrading` function allows the owner to activate trading and add liquidity to the pool. While this is necessary for initially setting up the contract, the owner can potentially delay the activation of trading for arbitrary amounts of time, which could be used to manipulate market conditions or to prevent users from trading the token until the owner deems it profitable.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    }
]