[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Immediate Ownership Transfer",
        "reason": "The function allows the current owner to transfer ownership immediately without any delay or multi-signature requirement, making it vulnerable to phishing attacks or mistakes, where the owner might accidentally transfer ownership to a malicious address.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "manage_blacklist",
        "code": "function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner { for (uint256 i; i < addresses.length; ++i) { isBlacklisted[addresses[i]] = status; } }",
        "vulnerability": "Centralized Blacklisting",
        "reason": "This function allows the owner to arbitrarily blacklist addresses, potentially blocking them from trading the token. This centralization introduces a risk where the owner could abuse this privilege or become compromised, leading to unfair blacklisting.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    },
    {
        "function_name": "clearStuckBalance",
        "code": "function clearStuckBalance(uint256 amountPercentage) external authorized { uint256 amountETH = address(this).balance; payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100); }",
        "vulnerability": "Potential Fund Misappropriation",
        "reason": "The function allows an authorized address to transfer a percentage of the contract's ETH balance to the marketingFeeReceiver, which could be misused to drain funds from the contract without the consent of the token holders.",
        "file_name": "0x25061388ba6886d98110f7355e4f2c5912ae53c8.sol"
    }
]