[
    {
        "function_name": "withdrawFund",
        "code": "function withdrawFund() public onlyOwner { require(ethFund > 0, 'No Funds to withdraw, Balance is 0'); _withdraw(payable(0xd7DDfE7233D872d3600549b570b3631604aA5ffF), ethFund); ethFund = 0; }",
        "vulnerability": "Potential fund lock due to hardcoded address",
        "reason": "The function withdrawFund has a hardcoded address, which can result in funds being locked if the address is incorrect or inaccessible. If the owner loses access or if the address is not intended to receive funds, the funds can be permanently locked, leading to loss of assets.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "pendingRoyaltyReward",
        "code": "function pendingRoyaltyReward(address account) public view returns (uint256){ uint256 holdAmount = balanceOf(account); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(account, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); } return pendingReward; }",
        "vulnerability": "Integer underflow in royalty calculations",
        "reason": "The pendingRoyaltyReward function uses subtraction without checking for underflow when calculating pendingReward. If the royaltyDebt[id] is greater than accEthPerShare.div(PRECISION_FACTOR), this subtraction could underflow, potentially allowing an attacker to claim a large amount of rewards.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "vulnerability": "Reentrancy in royalty claim mechanism",
        "reason": "Despite the use of a nonReentrant modifier, the claimRoyaltyReward function is vulnerable to reentrancy attacks due to the external call to _withdraw before updating the royaltyDebt state. If a malicious contract is able to re-enter the function, it could potentially withdraw more than the intended pending rewards.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]