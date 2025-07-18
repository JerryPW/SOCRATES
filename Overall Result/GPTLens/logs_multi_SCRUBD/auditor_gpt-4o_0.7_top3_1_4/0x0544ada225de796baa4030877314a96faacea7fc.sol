[
    {
        "function_name": "airDrops",
        "code": "function airDrops(address[] calldata newholders, uint256[] calldata amounts) external { uint256 iterator = 0; require(_isExcludedFromFee[_msgSender()], \"Airdrop can only be done by excluded from fee\"); require(newholders.length == amounts.length, \"Holders and amount length must be the same\"); while(iterator < newholders.length){ _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false); iterator += 1; } }",
        "vulnerability": "Unrestricted Airdrop Execution",
        "reason": "The function allows any account excluded from fee to conduct airdrops, enabling potential abuse where a malicious actor could distribute excessive tokens without restriction, potentially causing inflation and devaluation of the token.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "blockUnblockAddress",
        "code": "function blockUnblockAddress(address[] memory addresses, bool doBlock) private { for (uint256 i = 0; i < addresses.length; i++) { address addr = addresses[i]; if(doBlock) { botWallets[addr] = true; } else { delete botWallets[addr]; } } }",
        "vulnerability": "Centralized Control Over Transactions",
        "reason": "This private function allows the contract owner to block or unblock addresses from transactions. While it's a private function, it can be called within other functions accessible to the owner, granting centralized control which can lead to censorship and abuse if the contract owner decides to block legitimate users.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "setExclusiveDividendTracker",
        "code": "function setExclusiveDividendTracker(address dividendContractAddress) external onlyOwner { dividendTracker = ExclusiveDividendTracker(payable(dividendContractAddress)); }",
        "vulnerability": "Potential for Dividend Tracker Manipulation",
        "reason": "The owner can set the address of the dividend tracker contract, which can lead to directing dividends to a malicious contract or changing the dividend distribution logic, thereby misleading token holders about their expected dividends.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    }
]