[
    {
        "function_name": "rescueDividends",
        "code": "function rescueDividends(address to) external onlyToken { RewardToken.transfer(to, RewardToken.balanceOf(address(this))); }",
        "vulnerability": "Potential unauthorized token transfer",
        "reason": "The `rescueDividends` function allows transferring all the RewardTokens held by the contract to a specified address. The function is protected by the `onlyToken` modifier, which restricts access to only the `_token` address; however, if the `_token` address is compromised or improperly set, an attacker could potentially call this function to drain all RewardTokens from the contract.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "setRewardToken",
        "code": "function setRewardToken(address _rewardToken) external onlyToken { RewardToken = IBEP20(_rewardToken); }",
        "vulnerability": "Unrestricted reward token change",
        "reason": "This function allows the reward token to be changed to any arbitrary token address. If an attacker gains control over the `_token` address, they could potentially change the reward token to a malicious one, affecting the contract's ability to distribute dividends correctly.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Improper transfer of ownership",
        "reason": "The `transferOwnership` function sets a new owner and automatically authorizes them without any checks or restrictions. An attacker gaining access to the owner's account could transfer ownership to a malicious address, gaining full control over the contract.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    }
]