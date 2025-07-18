[
    {
        "function_name": "setAntibot",
        "code": "function setAntibot(address account, bool _bot) external onlyOwner{ require(_isBot[account] != _bot, 'Value already set'); _isBot[account] = _bot; }",
        "vulnerability": "Potential misuse by owner",
        "reason": "The setAntibot function allows the contract owner to arbitrarily mark any address as a bot, which could potentially be misused to prevent legitimate users from participating in transfers. This kind of control could lead to centralization risks where the owner can block specific users or disrupt the market by labeling accounts as bots.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "rescueBEP20Tokens",
        "code": "function rescueBEP20Tokens(address tokenAddress) external onlyOwner{ IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this))); }",
        "vulnerability": "Token theft by owner",
        "reason": "The rescueBEP20Tokens function allows the owner to transfer any BEP20 tokens from the contract to their own address. This opens up the possibility for the owner to steal or misuse tokens that may have been transferred to the contract, either intentionally or unintentionally, by other users.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "rescueBNB",
        "code": "function rescueBNB(uint256 weiAmount) external onlyOwner{ require(address(this).balance >= weiAmount, \"insufficient BNB balance\"); payable(msg.sender).transfer(weiAmount); }",
        "vulnerability": "BNB theft by owner",
        "reason": "The rescueBNB function enables the owner to withdraw any amount of BNB from the contract's balance. This function could be exploited by the contract owner to drain BNB from the contract, potentially including user-contributed funds, which poses a significant risk to users who interact with the contract.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    }
]