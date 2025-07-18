[
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool) { _transfer(msg.sender, recipient, amount); return true; }",
        "vulnerability": "Potential Reentrancy",
        "reason": "The `_transfer` function does not have reentrancy guards. If this contract interacts with an external contract, it could be vulnerable to reentrancy attacks if the external contract calls back into this contract. It is best practice to use reentrancy guards in critical functions that modify state variables.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamRescueTokens",
        "code": "function TeamRescueTokens(address tknAddress) public onlyTeam { IBEP20 token = IBEP20(tknAddress); uint256 ourBalance = token.balanceOf(address(this)); require(ourBalance>0, \"No tokens in our balance\"); token.transfer(msg.sender, ourBalance); }",
        "vulnerability": "Potential Token Theft",
        "reason": "The `TeamRescueTokens` function allows the team to transfer any ERC20 token from the contract to the team wallet. This could be exploited if the team decides to act maliciously or if the team wallet is compromised.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    },
    {
        "function_name": "TeamAvoidBurning",
        "code": "function TeamAvoidBurning() public onlyTeam{ (bool sent,) =msg.sender.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Unauthorized Withdrawal",
        "reason": "The `TeamAvoidBurning` function allows the team to withdraw all the Ether from the contract balance to the team wallet. This could be exploited by the team or if the team wallet is compromised, potentially leading to an unauthorized withdrawal of funds.",
        "file_name": "0x01d5609df23dee77fe8db8e03c66be11dca7d21b.sol"
    }
]