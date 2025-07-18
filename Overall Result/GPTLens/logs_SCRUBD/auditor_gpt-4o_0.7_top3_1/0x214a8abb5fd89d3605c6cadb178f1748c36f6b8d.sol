[
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() public onlyOwner {\n    bool success;\n    (success, ) = address(msg.sender).call{value: address(this).balance}( \"\" );\n}",
        "vulnerability": "Lack of event emission after ETH withdrawal",
        "reason": "The `withdrawStuckETH` function allows the owner to withdraw any ETH held by the contract, but it does not emit an event after a withdrawal is executed. This lack of transparency can make it difficult to track fund movements and might be exploited by a dishonest owner to withdraw funds without creating an on-chain record of the action, which can be a red flag for investors.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    },
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens(address tkn) public onlyOwner {\n    require(IERC20(tkn).balanceOf(address(this)) > 0);\n    uint256 amount = IERC20(tkn).balanceOf(address(this));\n    IERC20(tkn).transfer(msg.sender, amount);\n}",
        "vulnerability": "Lack of event emission after token withdrawal",
        "reason": "The `withdrawStuckTokens` function allows the owner to withdraw any tokens held by the contract, but it does not emit an event after a withdrawal is executed. Similar to the ETH withdrawal function, this can be exploited by a dishonest owner to withdraw tokens without creating an on-chain record, leading to potential misuse and lack of accountability.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    },
    {
        "function_name": "excludeFromFees",
        "code": "function excludeFromFees(address account, bool excluded) public onlyOwner {\n    _isExcludedFromFees[account] = excluded;\n}",
        "vulnerability": "Potential for fee manipulation",
        "reason": "The `excludeFromFees` function allows the owner to exclude any account from transaction fees. This could be exploited by the owner to exclude themselves or others maliciously, allowing certain users to trade without incurring fees, which could disrupt the tokenomics and fairness of the contract. Without any restrictions or events to track these changes, it opens up potential for abuse.",
        "file_name": "0x214a8abb5fd89d3605c6cadb178f1748c36f6b8d.sol"
    }
]