[
    {
        "function_name": "_sendETHToTreasury",
        "code": "function _sendETHToTreasury(uint256 amount) private { treasuryWallet.call{ value: amount }(''); }",
        "vulnerability": "Unchecked call to treasuryWallet",
        "reason": "The function uses a low-level call to send ETH to the treasuryWallet without checking if the call was successful. This could potentially lead to loss of funds if the call fails or if treasuryWallet is a contract that reverts. It is advisable to use the 'require' statement to check the success of the call.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "claimETHRewards",
        "code": "function claimETHRewards() external { require( balanceOf(_msgSender()) > 0, 'You must have a balance to claim ETH rewards' ); require( canClaimRewards(_msgSender()), 'Must wait claim period before claiming rewards' ); _rewardsLastClaim[_msgSender()] = block.timestamp; uint256 rewardsSent = calculateETHRewards(_msgSender()); ethRewardsBalance -= rewardsSent; _msgSender().call{ value: rewardsSent }(''); emit SendETHRewards(_msgSender(), rewardsSent); }",
        "vulnerability": "Unchecked call to _msgSender",
        "reason": "The function sends ETH to the caller using a low-level call without checking if the call was successful. If the call fails, the ETH could be lost. To prevent this, the success of the call should be verified using a 'require' statement. Additionally, this function is vulnerable to reentrancy attacks because state changes (updating _rewardsLastClaim) occur before the external call.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "emergencyWithdraw",
        "code": "function emergencyWithdraw() external onlyOwner { payable(owner()).send(address(this).balance); }",
        "vulnerability": "Use of 'send' without checking return value",
        "reason": "The function uses 'send' to transfer the contract's entire balance to the owner without checking if the transfer was successful. 'send' only forwards 2300 gas which might not be enough if the owner is a contract. It is better to use 'transfer' or 'call' with a 'require' statement to ensure successful execution.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    }
]