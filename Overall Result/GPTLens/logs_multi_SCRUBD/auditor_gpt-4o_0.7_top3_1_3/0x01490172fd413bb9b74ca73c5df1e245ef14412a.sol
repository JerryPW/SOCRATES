[
    {
        "function_name": "_sendETHToTreasury",
        "code": "function _sendETHToTreasury(uint256 amount) private { treasuryWallet.call{ value: amount }(''); }",
        "vulnerability": "Unchecked Call Return Value",
        "reason": "The contract uses a low-level call to send Ether to the treasury wallet without checking if the call was successful. This could lead to a loss of Ether if the call fails, as the returned status is not checked.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "claimETHRewards",
        "code": "function claimETHRewards() external { require( balanceOf(_msgSender()) > 0, 'You must have a balance to claim ETH rewards' ); require( canClaimRewards(_msgSender()), 'Must wait claim period before claiming rewards' ); _rewardsLastClaim[_msgSender()] = block.timestamp; uint256 rewardsSent = calculateETHRewards(_msgSender()); ethRewardsBalance -= rewardsSent; _msgSender().call{ value: rewardsSent }(''); emit SendETHRewards(_msgSender(), rewardsSent); }",
        "vulnerability": "Unchecked Call Return Value",
        "reason": "The contract sends Ether to the caller using a low-level call without checking if the call was successful. This could result in Ether being lost if the call fails, as the success status of the call is not checked.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "emergencyWithdraw",
        "code": "function emergencyWithdraw() external onlyOwner { payable(owner()).send(address(this).balance); }",
        "vulnerability": "Use of send instead of call",
        "reason": "The contract uses the send method to transfer Ether, which only forwards 2300 gas and does not provide a return value to check for success. Using call is preferred because it forwards all gas and allows for checking the success status, reducing the risk of Ether being locked in the contract.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    }
]