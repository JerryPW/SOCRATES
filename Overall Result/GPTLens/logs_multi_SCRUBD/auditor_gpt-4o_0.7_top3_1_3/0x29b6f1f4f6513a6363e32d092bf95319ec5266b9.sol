[
    {
        "function_name": "setMarketingWallet",
        "code": "function setMarketingWallet(address _address) public { require(msg.sender == marketingWallet, 'only accept by marketing wallet'); marketingWallet = _address; emit NewMarketingWallet(_address); }",
        "vulnerability": "Unauthorized wallet change",
        "reason": "The function `setMarketingWallet` allows the current marketing wallet to set a new marketing wallet address without any additional security checks or multi-signature requirement. This can be exploited if the private key of the marketing wallet is compromised, allowing an attacker to redirect funds to an address of their choice.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "swap",
        "code": "function swap() public { address[] memory path = new address[](2); path[0] = address(token); path[1] = dexRouter.WETH(); uint256 balance = token.balanceOf(address(this)); if (balance > 0) { token.approve(address(dexRouter), balance); dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens( balance, 0, path, marketingWallet, block.timestamp ); } }",
        "vulnerability": "Unrestricted public access",
        "reason": "The function `swap` is publicly accessible, allowing anyone to trigger the swap of all tokens held by the contract for ETH. This can potentially be exploited by an attacker to drain the tokens from the contract if the swap conditions are met, without any authorization or rate limiting.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), 'Cannot claim native tokens'); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Potential misuse in claiming tokens",
        "reason": "The `claimStuckTokens` function allows the owner to transfer any ERC20 tokens except the native token from the contract to their own address. This can be exploited if a malicious owner deploys this function to drain any tokens sent mistakenly to the contract, including those from users who might have interacted with the wrong address.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    }
]