[
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), \"Owner cannot claim native tokens\"); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Potentially Dangerous Owner Control",
        "reason": "The `claimStuckTokens` function allows the owner to transfer any ERC20 tokens held by the contract to themselves. Although this function is only callable by the owner, it poses a risk if the ownership is compromised or if the owner is malicious. This could lead to a loss of funds for token holders if the owner decides to transfer any mistakenly sent tokens or other tokens held by the contract.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "changeMarketingWallet",
        "code": "function changeMarketingWallet(address _marketingWallet) external onlyOwner { require(_marketingWallet != marketingWallet, \"Marketing wallet is already that address\"); require(!isContract(_marketingWallet), \"Marketing wallet cannot be a contract\"); marketingWallet = _marketingWallet; emit MarketingWalletChanged(marketingWallet); }",
        "vulnerability": "Lack of Restrictions on Wallet Address",
        "reason": "The `changeMarketingWallet` function allows the owner to change the marketing wallet address to any non-contract address. While this is standard practice, it becomes a vulnerability if the ownership is compromised. An attacker with control of the owner account could redirect funds meant for marketing to an address they control.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "changeBuyBackWallet",
        "code": "function changeBuyBackWallet(address _buyBackWallet) external onlyOwner { require(_buyBackWallet != buyBackWallet, \"Buyback wallet is already that address\"); require(!isContract(_buyBackWallet), \"Buyback wallet cannot be a contract\"); buyBackWallet = _buyBackWallet; emit BuyBackWalletChanged(buyBackWallet); }",
        "vulnerability": "Lack of Restrictions on Wallet Address",
        "reason": "Similar to `changeMarketingWallet`, the `changeBuyBackWallet` function allows the owner to change the buyback wallet address to any non-contract address. If the ownership is compromised, an attacker can redirect funds to an address they control, potentially leading to a loss of funds intended for buybacks.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    }
]