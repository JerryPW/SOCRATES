[
    {
        "function_name": "TeamSetTaxes",
        "code": "function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{ uint8 totalTax=burnTaxes+liquidityTaxes+marketingTaxes; require(totalTax==100, \"burn+liq+marketing needs to equal 100%\"); require(buyTax<=MaxTax&&sellTax<=MaxTax&&transferTax<=MaxTax,\"taxes higher than max tax\"); _burnTax=burnTaxes; _liquidityTax=liquidityTaxes; _marketingTax=marketingTaxes; _buyTax=buyTax; _sellTax=sellTax; _transferTax=transferTax; }",
        "vulnerability": "Tax configuration vulnerability",
        "reason": "The function allows the team to set taxes up to a maximum of 95% for buy, sell, and transfer actions. This is extremely high and can be exploited by the team to manipulate or drain funds from users via excessive taxation.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamRescueTokens",
        "code": "function TeamRescueTokens(address tknAddress) public onlyTeam { IBEP20 token = IBEP20(tknAddress); uint256 ourBalance = token.balanceOf(address(this)); require(ourBalance>0, \"No tokens in our balance\"); token.transfer(msg.sender, ourBalance); }",
        "vulnerability": "Token rescue function",
        "reason": "This function allows the team to transfer any tokens held by the contract to the team's address. Although it requires team permissions, it can be abused if the team decides to withdraw user-deposited tokens arbitrarily.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamAvoidBurning",
        "code": "function TeamAvoidBurning() public onlyTeam{ (bool sent,) =msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Withdrawal of contract balance",
        "reason": "This function permits the team to withdraw the entire balance of the contract to their address. It presents a risk where the team can potentially drain all funds, including those that might belong to users, without any restriction.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    }
]