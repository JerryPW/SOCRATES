[
    {
        "function_name": "withdrawForeignTokens",
        "code": "function withdrawForeignTokens(address _tokenContract, address _to) onlySigner public returns (bool) { require(_tokenContract != address(this), \"cannot withdraw Fog\"); require(_tokenContract != address(uniswapV2Pair), \"cannot withdraw FOG LP\"); ERC20 token = ERC20(_tokenContract); uint256 amount = token.balanceOf(address(this)); return token.transfer(_to, amount); }",
        "vulnerability": "Potential misuse by signer",
        "reason": "The `withdrawForeignTokens` function allows any signer to withdraw all tokens of any ERC20 contract (except for the FOG token and its LP tokens) held by this contract to an arbitrary address. This could potentially be misused by a malicious signer to drain tokens from the contract, causing loss of assets intended for other purposes.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "burnLiquidity",
        "code": "function burnLiquidity() external { uint256 balance = ERC20(uniswapV2Pair).balanceOf(address(this)); require(balance != 0, \"ERC20TransferLiquidityLock::burnLiquidity: burn amount cannot be 0\"); ERC20(uniswapV2Pair).transfer(address(0), balance); emit BurnLiquidity(balance); }",
        "vulnerability": "Irreversible loss of LP tokens",
        "reason": "The `burnLiquidity` function transfers all LP tokens held by the contract to the zero address, effectively burning them. This operation is irreversible and can result in a permanent loss of liquidity that the contract might need in the future. If called without proper checks or accidentally, it could significantly harm the liquidity pool and the value of the token.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Router",
        "code": "function setUniswapV2Router(address _uniswapV2Router) public onlySigner { require(uniswapV2Router == address(0), \"FogToken::setUniswapV2Router: already set\"); uniswapV2Router = _uniswapV2Router; }",
        "vulnerability": "Permanent inability to update router",
        "reason": "The `setUniswapV2Router` function can only be called once due to the `require` condition that checks if the router is already set. This means that if the wrong address is set initially, or if the current router becomes obsolete or compromised, the contract will be unable to update to a new router, potentially leading to a loss of functionality or security.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    }
]