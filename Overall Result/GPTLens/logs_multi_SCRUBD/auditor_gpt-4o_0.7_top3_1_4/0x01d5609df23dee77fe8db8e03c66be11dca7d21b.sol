[
    {
        "function_name": "TeamRescueTokens",
        "code": "function TeamRescueTokens(address tknAddress) public onlyTeam {\n    IBEP20 token = IBEP20(tknAddress);\n    uint256 ourBalance = token.balanceOf(address(this));\n    require(ourBalance>0, \"No tokens in our balance\");\n    token.transfer(msg.sender, ourBalance);\n}",
        "vulnerability": "Token Drain by Team",
        "reason": "The TeamRescueTokens function allows any tokens sent to the contract to be transferred to the team address. This can be used maliciously to drain tokens sent by mistake or as a part of token swaps. There are no restrictions on what token address can be passed, meaning any token balance held by the contract can be transferred out by the team.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamAvoidBurning",
        "code": "function TeamAvoidBurning() public onlyTeam{\n    (bool sent,) =msg.sender.call{value: (address(this).balance)}(\"\");\n    require(sent);\n}",
        "vulnerability": "Contract Balance Drain by Team",
        "reason": "The TeamAvoidBurning function allows the team to withdraw the entire balance of BNB held by the contract. This can be exploited to drain funds from the contract, especially if the contract is accumulating BNB for liquidity or other purposes. The lack of restrictions or checks on the usage of this function by the team makes it a significant vulnerability.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamWithdrawMarketingBNB",
        "code": "function TeamWithdrawMarketingBNB() public onlyTeam{\n    uint256 amount=marketingBalance;\n    marketingBalance=0;\n    (bool sent,) =TeamWallet.call{value: (amount)}(\"\");\n    require(sent,\"withdraw failed\");\n}",
        "vulnerability": "Unrestricted Marketing BNB Withdrawal",
        "reason": "The TeamWithdrawMarketingBNB function allows the team to withdraw the entire marketing balance. While the function is intended for marketing purposes, there are no checks or accountability measures in place to ensure that the withdrawn funds are used correctly. This can lead to misuse of the funds, especially since the function can be called repeatedly as marketingBalance is reset to zero without any further restrictions.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    }
]