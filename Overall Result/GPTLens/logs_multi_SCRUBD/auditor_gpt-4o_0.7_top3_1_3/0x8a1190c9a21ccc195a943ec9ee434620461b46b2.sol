[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external onlyLeader { leaderAddress.transfer(this.balance); }",
        "vulnerability": "Ether withdrawal to leader without checks",
        "reason": "The function allows the leader to withdraw all Ether from the contract without any checks on the state or restrictions. An attacker who gains control over the leader account could drain all Ether from the contract.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "withdrawERC20Balance",
        "code": "function withdrawERC20Balance(uint256 amount) external onlyLeader { uint256 realTotal = erc20.balanceOf(this); require((realTotal - (totalPromo + totalBalance- totalUsed ) ) >=amount); erc20.transfer(leaderAddress, amount); totalBalance -=amount; totalUsed -=amount; }",
        "vulnerability": "Incorrect balance accounting and possible underflow",
        "reason": "The function attempts to withdraw ERC20 tokens by checking balances and directly transferring tokens to the leader. However, it uses unchecked arithmetic, which could lead to underflows, allowing more tokens to be withdrawn than the contract actually holds.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "rescueLostHero",
        "code": "function rescueLostHero(uint256 _heroId, address _recipient) public onlyOPM whenNotPaused { require(_owns(this, _heroId)); _transfer(this, _recipient, _heroId); }",
        "vulnerability": "Transfer of heroes without proper authorization",
        "reason": "This function allows the transfer of any hero owned by the contract to any recipient as long as the caller is the OPM. If an attacker gains control of the OPM account, they could transfer all heroes to themselves or any other address without restrictions.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    }
]