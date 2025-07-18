[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "vulnerability": "Hardcoded address for fee transfer",
        "reason": "The function transfers a calculated fee to a hardcoded address (0x1111111111111111111111111111111111111111). This address is not configurable and may not be a valid or intended recipient, leading to potential loss of funds without benefit to the system or stakeholders. Moreover, this could be exploited by malicious actors if they control the destination address.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "batchTransfer",
        "code": "function batchTransfer(address[] memory destinations, uint256[] memory values) public onlyOwner whenPaused { require(destinations.length == values.length); uint256 length = destinations.length; uint i; for (i=0; i < length; i++) { rewards[destinations[i]] = values[i]; } }",
        "vulnerability": "Lack of input validation",
        "reason": "This function allows the owner to set rewards for multiple addresses at once. However, it does not validate the values assigned, allowing the owner to set arbitrary reward values, which could lead to setting extremely high rewards for certain addresses. If a vulnerability exists elsewhere that allows an attacker to gain control over the contract ownership, they could exploit this function to gain excessive rewards.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "recoverERC20",
        "code": "function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner { require( tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken), \"Cannot withdraw the staking or rewards tokens\" ); IERC20(tokenAddress).transfer(this.owner(), tokenAmount); emit Recovered(tokenAddress, tokenAmount); }",
        "vulnerability": "Potential to lock tokens",
        "reason": "This function allows the owner to recover ERC20 tokens sent to the contract. While it prevents recovery of the staking and rewards tokens, it does not consider other tokens that might be critical for operations or mistakenly sent by users. If a necessary token for operation is accidentally sent, it cannot be retrieved if not explicitly allowed, potentially locking critical tokens into the contract.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]