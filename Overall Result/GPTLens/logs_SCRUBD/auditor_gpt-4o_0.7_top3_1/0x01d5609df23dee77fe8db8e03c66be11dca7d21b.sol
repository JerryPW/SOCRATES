[
    {
        "function_name": "TeamRescueTokens",
        "code": "function TeamRescueTokens(address tknAddress) public onlyTeam { IBEP20 token = IBEP20(tknAddress); uint256 ourBalance = token.balanceOf(address(this)); require(ourBalance>0, \"No tokens in our balance\"); token.transfer(msg.sender, ourBalance); }",
        "vulnerability": "Potential misuse by the team",
        "reason": "The `TeamRescueTokens` function allows the team to transfer any ERC20 tokens held by the contract to their own address. This can be misused by the team to transfer tokens that should otherwise be locked or belong to the users, leading to a loss of trust and potential financial loss for token holders.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamAvoidBurning",
        "code": "function TeamAvoidBurning() public onlyTeam{ (bool sent,) =msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Potential misuse of contract balance",
        "reason": "The `TeamAvoidBurning` function allows the team to withdraw the entire balance of BNB held by the contract. This can be exploited by the team to drain the contract's funds, potentially leading to a situation where funds intended for liquidity, marketing, or other purposes are misappropriated.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamSetWhitelistedAddress",
        "code": "function TeamSetWhitelistedAddress(address addy, bool booly) public onlyTeam { wListed[addy] = booly; _excluded.add(addy); }",
        "vulnerability": "Potential manipulation of whitelist",
        "reason": "The `TeamSetWhitelistedAddress` function allows the team to arbitrarily add or remove addresses from the whitelist. This could be exploited to give preferential treatment to certain addresses, allowing them to bypass trading restrictions or fees, which could adversely impact the fairness of the token distribution and trading.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    }
]