[
    {
        "function_name": "claimETHOverflow",
        "code": "function claimETHOverflow() external onlyOwner { require(address(this).balance > 0, \"RedKnightToken: Cannot send more than contract balance\"); uint256 amount = address(this).balance; (bool success,) = address(owner()).call{value : amount}(\"\"); if (success){ emit ClaimETHOverflow(amount); } }",
        "vulnerability": "Owner can drain contract ETH",
        "reason": "The `claimETHOverflow` function allows the contract owner to withdraw all ETH stored in the contract. This centralizes control and can be exploited by a malicious or compromised owner to drain funds, posing a risk to users who have interacted with the contract.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "blockAccount",
        "code": "function blockAccount(address account) external onlyOwner { uint256 currentTimestamp = _getNow(); require(!_isBlocked[account], \"RedKnightToken: Account is already blocked\"); if (_isLaunched) { require((currentTimestamp - _launchStartTimestamp) < _blockedTimeLimit, \"RedKnightToken: Time to block accounts has expired\"); } _isBlocked[account] = true; emit BlockedAccountChange(account, true); }",
        "vulnerability": "Centralized control over blocking accounts",
        "reason": "The `blockAccount` function allows the owner to block any account from trading. This centralized power can be abused by the owner to arbitrarily restrict users from transferring tokens, which could be used maliciously or unfairly, impacting the token's usability for certain holders.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "deactivateTrading",
        "code": "function deactivateTrading() external onlyOwner { isTradingEnabled = false; _tradingPausedTimestamp = _getNow(); }",
        "vulnerability": "Centralized control over trading",
        "reason": "The `deactivateTrading` function allows the owner to pause all trading activities by setting `isTradingEnabled` to false. This centralized control can be exploited to halt all trading, which could be used to manipulate the market or restrict liquidity if the owner or a compromised owner acts maliciously.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    }
]