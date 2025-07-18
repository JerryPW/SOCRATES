[
    {
        "function_name": "_sendETHToTreasury",
        "code": "function _sendETHToTreasury(uint256 amount) private { treasuryWallet.call{ value: amount }(''); }",
        "vulnerability": "Unsafe use of call for ETH transfer",
        "reason": "The `_sendETHToTreasury` function uses a low-level call to transfer ETH to the `treasuryWallet`. This approach is unsafe because it does not check if the call was successful, which could result in a loss of funds if the recipient reverts. It is better to use `transfer` or `send` with proper checks for failure.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "claimETHRewards",
        "code": "function claimETHRewards() external { require( balanceOf(_msgSender()) > 0, 'You must have a balance to claim ETH rewards' ); require( canClaimRewards(_msgSender()), 'Must wait claim period before claiming rewards' ); _rewardsLastClaim[_msgSender()] = block.timestamp; uint256 rewardsSent = calculateETHRewards(_msgSender()); ethRewardsBalance -= rewardsSent; _msgSender().call{ value: rewardsSent }(''); emit SendETHRewards(_msgSender(), rewardsSent); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `claimETHRewards` function updates the `_rewardsLastClaim` mapping and decreases the `ethRewardsBalance` before transferring ETH to the caller. This pattern is vulnerable to reentrancy attacks where the caller can re-enter the contract and claim more rewards before the state is fully updated. It is recommended to use a checks-effects-interactions pattern by moving the ETH transfer to the end of the function.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    },
    {
        "function_name": "emergencyWithdraw",
        "code": "function emergencyWithdraw() external onlyOwner { payable(owner()).send(address(this).balance); }",
        "vulnerability": "Unsafe use of send for ETH transfer",
        "reason": "The `emergencyWithdraw` function uses `send` for transferring the contract's balance to the owner's address. The `send` function only forwards 2300 gas, which might not be enough to complete the transaction if any logic is invoked in the fallback function of the recipient. Additionally, it does not handle possible failure. Using `transfer` or `call` with proper checks and handling for failures is recommended.",
        "file_name": "0x01490172fd413bb9b74ca73c5df1e245ef14412a.sol"
    }
]