[
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _teamAddress); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Potential misuse by team address",
        "reason": "The `manualsend` function allows the team address to withdraw all ETH balance from the contract. If the team address is compromised or malicious, it could drain the entire contract's ETH balance, leading to a loss of funds for the contract.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    },
    {
        "function_name": "blockBots",
        "code": "function blockBots(address[] memory bots_) public onlyOwner { for (uint256 i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralized control over blocking addresses",
        "reason": "The `blockBots` function allows the owner to block any address from interacting with the contract. This centralization can be abused, as the owner can potentially block any user or competitor from interacting with the contract, impacting the fairness and decentralization of the system.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    },
    {
        "function_name": "setMaxTxPercent",
        "code": "function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() { require(maxTxPercent > 0, \"Amount must be greater than 0\"); _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2); emit MaxTxAmountUpdated(_maxTxAmount); }",
        "vulnerability": "Owner can set an unreasonably low max transaction limit",
        "reason": "The `setMaxTxPercent` function allows the owner to set the maximum transaction limit. An owner can set this limit to an unreasonably low value, effectively freezing trading by making it impractical or impossible for users to transfer tokens. This can disrupt normal market operations and affect user experience.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    }
]