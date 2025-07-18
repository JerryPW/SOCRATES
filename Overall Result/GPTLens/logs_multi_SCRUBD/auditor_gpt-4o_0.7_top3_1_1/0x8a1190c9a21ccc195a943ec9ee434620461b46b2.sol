[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external onlyLeader { leaderAddress.transfer(this.balance); }",
        "vulnerability": "Unsafe Ether withdrawal",
        "reason": "The function transfers the entire contract balance to the leaderAddress without any checks. If the leaderAddress is compromised or if there is a mistake in setting the leaderAddress, all Ether in the contract can be drained by the attacker.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "withdrawERC20Balance",
        "code": "function withdrawERC20Balance(uint256 amount) external onlyLeader { uint256 realTotal = erc20.balanceOf(this); require((realTotal - (totalPromo + totalBalance - totalUsed ) ) >= amount); erc20.transfer(leaderAddress, amount); totalBalance -= amount; totalUsed -= amount; }",
        "vulnerability": "Incorrect ERC20 balance update",
        "reason": "The function reduces both totalBalance and totalUsed by the amount withdrawn. This is incorrect since totalUsed should only reflect the amount of ERC20 used, not withdrawn. An attacker with control over the leaderAddress can exploit this to manipulate the contract's accounting and potentially withdraw more tokens than they are entitled to.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "rescueLostHero",
        "code": "function rescueLostHero(uint256 _heroId, address _recipient) public onlyOPM whenNotPaused { require(_owns(this, _heroId)); _transfer(this, _recipient, _heroId); }",
        "vulnerability": "Transfer of ownership without proper checks",
        "reason": "The function allows the OPM to transfer any hero owned by the contract itself to any recipient without adequate justification or checks. This could be exploited if the OPM account is compromised, allowing an attacker to steal any hero owned by the contract.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    }
]