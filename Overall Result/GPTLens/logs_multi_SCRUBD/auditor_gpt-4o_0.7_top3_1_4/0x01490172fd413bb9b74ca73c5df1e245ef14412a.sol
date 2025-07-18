[
    {
        "function_name": "claimETHRewards",
        "code": "function claimETHRewards() external { require( balanceOf(_msgSender()) > 0, 'You must have a balance to claim ETH rewards' ); require( canClaimRewards(_msgSender()), 'Must wait claim period before claiming rewards' ); _rewardsLastClaim[_msgSender()] = block.timestamp; uint256 rewardsSent = calculateETHRewards(_msgSender()); ethRewardsBalance -= rewardsSent; _msgSender().call{ value: rewardsSent }(''); emit SendETHRewards(_msgSender(), rewardsSent); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function sends ETH to the caller using `.call` without a proper reentrancy guard. This could be exploited by attackers to repeatedly call this function and drain the contract's ETH balance before the state changes are finalized.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "_sendETHToTreasury",
        "code": "function _sendETHToTreasury(uint256 amount) private { treasuryWallet.call{ value: amount }(''); }",
        "vulnerability": "Unchecked Call Return Value",
        "reason": "The function uses `.call` to send ETH to the `treasuryWallet` without checking the return value. If the call fails, the function does not revert, potentially causing loss of funds or logic errors in the contract.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "emergencyWithdraw",
        "code": "function emergencyWithdraw() external onlyOwner { payable(owner()).send(address(this).balance); }",
        "vulnerability": "Unchecked Send Return Value",
        "reason": "The function uses `.send` to transfer the entire contract balance to the owner without checking the return value. If the send fails, the function will not revert, which could lead to unexpected behavior or loss of funds.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    }
]