[
    {
        "function_name": "blockAccount",
        "code": "function blockAccount(address account) external onlyOwner { uint256 currentTimestamp = _getNow(); require(!_isBlocked[account], \"RedKnightToken: Account is already blocked\"); if (_isLaunched) { require((currentTimestamp - _launchStartTimestamp) < _blockedTimeLimit, \"RedKnightToken: Time to block accounts has expired\"); } _isBlocked[account] = true; emit BlockedAccountChange(account, true); }",
        "vulnerability": "Owner can block accounts post-launch",
        "reason": "The function allows the contract owner to block any account within the _blockedTimeLimit after launch. This power can be misused to prevent users from trading their tokens and could potentially be exploited by a malicious owner.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "claimETHOverflow",
        "code": "function claimETHOverflow() external onlyOwner { require(address(this).balance > 0, \"RedKnightToken: Cannot send more than contract balance\"); uint256 amount = address(this).balance; (bool success,) = address(owner()).call{value : amount}(\"\"); if (success){ emit ClaimETHOverflow(amount); } }",
        "vulnerability": "Owner can drain contract's ETH balance",
        "reason": "The claimETHOverflow function allows the owner to transfer the entire ETH balance of the contract to themselves. This poses a risk as a malicious owner can drain the contract's ETH balance, which might have been intended for other purposes such as liquidity provisioning or buybacks.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "deactivateTrading",
        "code": "function deactivateTrading() external onlyOwner { isTradingEnabled = false; _tradingPausedTimestamp = _getNow(); }",
        "vulnerability": "Owner can halt trading",
        "reason": "This function allows the contract owner to stop all trading by setting isTradingEnabled to false. This power can be used maliciously to freeze all token transfers, potentially manipulating the market or preventing users from accessing their funds.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    }
]