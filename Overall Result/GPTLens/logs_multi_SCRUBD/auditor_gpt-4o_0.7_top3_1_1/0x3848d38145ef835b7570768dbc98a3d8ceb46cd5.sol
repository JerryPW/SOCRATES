[
    {
        "function_name": "rescueDividends",
        "code": "function rescueDividends(address to) external onlyToken { RewardToken.transfer(to, RewardToken.balanceOf(address(this))); }",
        "vulnerability": "Unauthorized Dividend Drain",
        "reason": "The function 'rescueDividends' allows the contract's owner (or any authorized token contract address) to transfer all reward tokens held by the DividendDistributor to any given address. This ability can be misused to drain all dividends, leaving none for the shareholders. The lack of restrictions or conditions for its execution makes this a severe vulnerability.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "setRewardToken",
        "code": "function setRewardToken(address _rewardToken) external onlyToken { RewardToken = IBEP20(_rewardToken); }",
        "vulnerability": "Unauthorized Reward Token Change",
        "reason": "The function 'setRewardToken' allows the contract's owner (or any authorized token contract address) to set a new reward token. This can be exploited to switch the reward token to a valueless or malicious token, rendering dividends worthless for shareholders. The function lacks checks to prevent arbitrary changes.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership Transfer to Zero Address",
        "reason": "The function 'transferOwnership' allows transferring ownership to any address, including the zero address. Transferring ownership to the zero address would render the contract ownerless, making it impossible to execute owner-only functions and potentially locking functionality that requires owner intervention.",
        "file_name": "0x3848d38145ef835b7570768dbc98a3d8ceb46cd5.sol"
    }
]