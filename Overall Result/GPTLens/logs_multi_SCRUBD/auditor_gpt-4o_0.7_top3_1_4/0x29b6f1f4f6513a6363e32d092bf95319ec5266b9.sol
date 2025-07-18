[
    {
        "function_name": "setMarketingWallet",
        "code": "function setMarketingWallet(address _address) public { require(msg.sender == marketingWallet, 'only accept by marketing wallet'); marketingWallet = _address; emit NewMarketingWallet(_address); }",
        "vulnerability": "Improper Authorization",
        "reason": "The setMarketingWallet function is only protected by checking if the msg.sender is the current marketingWallet. If the private key of the marketing wallet is compromised, an attacker can change the marketing wallet address to themselves, allowing them to receive funds intended for the marketing wallet.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 tokens) private { uint256 half = tokens / 2; uint256 otherHalf = tokens - half; uint256 initialBalance = address(this).balance; address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( half, 0, path, address(this), block.timestamp ); uint256 newBalance = address(this).balance - initialBalance; uniswapV2Router.addLiquidityETH{ value: newBalance }(address(this), otherHalf, 0, 0, owner(), block.timestamp); emit SwapAndLiquify(half, newBalance, otherHalf); }",
        "vulnerability": "Potential Reentrancy",
        "reason": "The swapAndLiquify function involves external calls to the uniswapV2Router, which could lead to reentrancy attacks if the Uniswap contract has vulnerabilities. Although Solidity 0.8.x has built-in overflow checks, reentrancy could still be exploited if the external contract is compromised. The function should properly manage state changes before external calls.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), 'Cannot claim native tokens'); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Token Draining",
        "reason": "The claimStuckTokens function allows the owner to transfer any ERC20 token from the contract to themselves. This could be abused by a malicious owner to drain tokens from the contract, which might be held for other purposes. This function should have more restrictions or be removed if not necessary for the contract's intended functionality.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    }
]