[
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), \"Owner cannot claim native tokens\"); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Unrestricted token withdrawal",
        "reason": "The 'claimStuckTokens' function allows the contract owner to withdraw any ERC20 tokens or Ether from the contract without restriction. This can be exploited by a malicious owner to drain the contract of all its assets, harming users who expect their tokens to be securely held by the contract. There is no mechanism to verify whether tokens are indeed 'stuck' or if the transfer is legitimate, leading to potential misuse.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "changeMarketingWallet",
        "code": "function changeMarketingWallet(address _marketingWallet) external onlyOwner { require(_marketingWallet != marketingWallet, \"Marketing wallet is already that address\"); require(!isContract(_marketingWallet), \"Marketing wallet cannot be a contract\"); marketingWallet = _marketingWallet; emit MarketingWalletChanged(marketingWallet); }",
        "vulnerability": "Owner can redirect funds",
        "reason": "The 'changeMarketingWallet' function allows the contract owner to change the marketing wallet address at any time. This introduces a risk where the owner can redirect fees intended for marketing to an address they control, potentially misusing funds meant for marketing purposes. The lack of transparency and restrictions can lead to misuse by a malicious or compromised owner.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    },
    {
        "function_name": "changeBuyBackWallet",
        "code": "function changeBuyBackWallet(address _buyBackWallet) external onlyOwner { require(_buyBackWallet != buyBackWallet, \"Buyback wallet is already that address\"); require(!isContract(_buyBackWallet), \"Buyback wallet cannot be a contract\"); buyBackWallet = _buyBackWallet; emit BuyBackWalletChanged(buyBackWallet); }",
        "vulnerability": "Owner can redirect funds",
        "reason": "Similar to the 'changeMarketingWallet' function, the 'changeBuyBackWallet' function permits the contract owner to update the buyback wallet address at any time. This flexibility can be exploited by a malicious or compromised owner to redirect buyback fees to an address under their control, potentially diverting funds away from intended buyback activities and harming token economics.",
        "file_name": "0x00dd5ad8f5d9c5118bceeb526c55ea6b2c07e922.sol"
    }
]