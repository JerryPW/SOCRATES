[
    {
        "function_name": "pendingRoyaltyReward",
        "code": "function pendingRoyaltyReward(address account) public view returns (uint256){ uint256 holdAmount = balanceOf(account); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(account, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); } return pendingReward; }",
        "vulnerability": "Reentrancy risk due to external calls in loop",
        "reason": "The function loops through each token owned by the account and performs operations that involve external calls. If the attacker controls one of the contracts involved, they can modify the state between iterations, potentially leading to inconsistent or incorrect calculations.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "vulnerability": "Reentrancy risk in reward claiming",
        "reason": "While the function is protected with a nonReentrant modifier, the calculation of rewards in a loop before calling external functions could be exploited by an attacker to manipulate the reward mechanism, especially if they find a way to bypass or circumvent the reentrancy guard.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "withdrawFund",
        "code": "function withdrawFund() public onlyOwner { require(ethFund > 0, 'No Funds to withdraw, Balance is 0'); _withdraw(payable(0xd7DDfE7233D872d3600549b570b3631604aA5ffF), ethFund); ethFund = 0; }",
        "vulnerability": "Single point of withdrawal for all funds",
        "reason": "The function allows the contract owner to withdraw all accumulated funds. If the owner's private key is compromised, an attacker can drain all funds from the contract. This centralizes the contract's financial control and poses a significant risk.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]