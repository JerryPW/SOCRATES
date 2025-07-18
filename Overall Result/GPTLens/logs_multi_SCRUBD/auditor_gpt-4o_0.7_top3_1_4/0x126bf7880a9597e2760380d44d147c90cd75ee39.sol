[
    {
        "function_name": "setNewRouter",
        "code": "function setNewRouter(address newRouter) public onlyOwner { IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter); address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH()); if (get_pair == address(0)) { lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH()); } else { lpPair = get_pair; } dexRouter = _newRouter; }",
        "vulnerability": "No validation of new router address",
        "reason": "The function allows the contract owner to set a new router address without any validation or checks. This could lead to the contract being pointed to a malicious or incorrect router, affecting the token's liquidity operations and potentially allowing an attacker to steal funds.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "sweepTokens",
        "code": "function sweepTokens(address token) external onlyOwner { IERC20 toTransfer = IERC20(token); toTransfer.transfer(msg.sender, toTransfer.balanceOf(address(this))); }",
        "vulnerability": "Token draining by owner",
        "reason": "This function allows the contract owner to transfer any ERC20 tokens held by the contract to their own address. It provides no restrictions or checks, enabling the owner to drain all tokens from the contract, which could be abused in a malicious manner or if the owner account is compromised.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "sweepETH",
        "code": "function sweepETH() external onlyOwner{ uint256 bal = address(this).balance; bool success; (success,) = address(msg.sender).call{value: bal}(\"\"); }",
        "vulnerability": "ETH draining by owner",
        "reason": "Similar to the sweepTokens function, this function allows the contract owner to transfer all ETH held by the contract to their own address. This could be exploited if the owner decides to act maliciously or if their private key is compromised, allowing an attacker to drain all ETH from the contract.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    }
]