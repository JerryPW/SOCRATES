[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) { _transfer(sender, recipient, amount); _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount); return true; }",
        "vulnerability": "Arithmetic Underflow in Allowance",
        "reason": "The function uses unchecked arithmetic which can lead to underflows. If `msg.sender` has an allowance equal to `amount`, subtracting `amount` from `_allowances[sender][msg.sender]` will underflow, potentially resetting the allowance to a very large number due to how unsigned integers work in Solidity.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "setNewRouter",
        "code": "function setNewRouter(address newRouter) public onlyOwner { IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter); address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH()); if (get_pair == address(0)) { lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH()); } else { lpPair = get_pair; } dexRouter = _newRouter; }",
        "vulnerability": "Potential Router Manipulation",
        "reason": "The function allows the owner to change the Uniswap router without any restriction. This could enable the owner to redirect swaps and liquidity additions to a malicious router, potentially stealing funds or disrupting the expected behavior of the contract.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "sweepTokens",
        "code": "function sweepTokens(address token) external onlyOwner { IERC20 toTransfer = IERC20(token); toTransfer.transfer(msg.sender, toTransfer.balanceOf(address(this))); }",
        "vulnerability": "Token Sweep by Owner",
        "reason": "This function allows the contract owner to transfer any ERC20 tokens held by the contract to their own address. While this might be intended for recovering tokens accidentally sent to the contract address, it can be abused to sweep tokens that should otherwise be used for other purposes, such as liquidity or staking rewards.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    }
]