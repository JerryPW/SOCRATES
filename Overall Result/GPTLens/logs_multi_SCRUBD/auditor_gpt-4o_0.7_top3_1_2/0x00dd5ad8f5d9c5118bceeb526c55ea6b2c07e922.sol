[
    {
        "function_name": "changeMarketingWallet",
        "code": "function changeMarketingWallet(address _marketingWallet) external onlyOwner { require(_marketingWallet != marketingWallet, \"Marketing wallet is already that address\"); require(!isContract(_marketingWallet), \"Marketing wallet cannot be a contract\"); marketingWallet = _marketingWallet; emit MarketingWalletChanged(marketingWallet); }",
        "vulnerability": "Marketing wallet change restriction bypass",
        "reason": "Although the function checks that the new marketing wallet is not a contract, it does not prevent the owner from setting the marketing wallet to a malicious address controlled by the owner or an accomplice, potentially allowing funds to be misappropriated.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "changeBuyBackWallet",
        "code": "function changeBuyBackWallet(address _buyBackWallet) external onlyOwner { require(_buyBackWallet != buyBackWallet, \"Buyback wallet is already that address\"); require(!isContract(_buyBackWallet), \"Buyback wallet cannot be a contract\"); buyBackWallet = _buyBackWallet; emit BuyBackWalletChanged(buyBackWallet); }",
        "vulnerability": "Buyback wallet change restriction bypass",
        "reason": "The function allows the owner to set the buyback wallet to any non-contract address, which could be a malicious address controlled by the owner, enabling potential misappropriation of funds meant for buybacks.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), \"Owner cannot claim native tokens\"); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Token withdrawal by owner",
        "reason": "The function allows the contract owner to withdraw any tokens or Ether from the contract. This could lead to misuse if the owner decides to withdraw tokens or ETH that should be used for specific purposes like liquidity or rewards, undermining trust and potentially affecting the token's value.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    }
]