[
    {
        "function_name": "owner_rescueERCTokens",
        "code": "function owner_rescueERCTokens() public {\n    uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;\n    require(balanceOf(address(this)) > pendingTaxTokens);\n    uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;\n    _transfer(address(this), marketingAddr, excessTokens);\n}",
        "vulnerability": "Unrestricted token withdrawal",
        "reason": "The function owner_rescueERCTokens allows arbitrary withdrawal of excess tokens from the contract to the marketing address without any restrictions or checks on the caller's address. This could be abused by a malicious owner to drain tokens from the contract.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "owner_setMaxWallets",
        "code": "function owner_setMaxWallets() public onlyOwner {\n    maxTransAmount = _tTotal;\n    maxWalletSize = _tTotal;\n}",
        "vulnerability": "Removal of transaction and wallet limits",
        "reason": "The owner_setMaxWallets function allows the contract owner to set the maximum transaction amount and maximum wallet size to the total supply, effectively removing any limits. This could enable the owner to perform large transactions or hold an unlimited number of tokens, which might lead to unfair practices and manipulation of token distribution.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    },
    {
        "function_name": "owner_disableSwapEnabled",
        "code": "function owner_disableSwapEnabled() external {\n    swapEnabled = false;\n}",
        "vulnerability": "Disabling swap mechanism",
        "reason": "The owner_disableSwapEnabled function allows the owner to disable the swap mechanism. If the swap is disabled, the contract will not be able to convert tokens to ETH, potentially leading to liquidity issues and preventing automated tax processing.",
        "file_name": "0x018194f1e70185eb153bcab2f6d64070c605a318.sol"
    }
]