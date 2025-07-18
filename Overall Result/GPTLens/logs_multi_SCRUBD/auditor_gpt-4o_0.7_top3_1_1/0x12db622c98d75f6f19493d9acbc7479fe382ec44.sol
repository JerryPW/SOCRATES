[
    {
        "function_name": "kill",
        "code": "function kill() isCreator public { selfdestruct(owner); }",
        "vulnerability": "Unauthorized Self-Destruct",
        "reason": "The kill function allows the contract to be destroyed by the creator, transferring all remaining Ether to the owner. If the creator's private key is compromised, an attacker could destroy the contract and steal all funds.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _to, uint256 _value) isCreator public { tokenReward.transfer(_to, _value); }",
        "vulnerability": "Arbitrary Token Transfer",
        "reason": "The sendToken function allows the creator to transfer any amount of tokens to any address. If the creator's account is compromised, an attacker can drain the tokens from the contract.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable public { require(msg.value > 0); require(now > startDate); require(now < endDate); require(whitelist[msg.sender]); if (categorie1[msg.sender] == false) { require((whitelistedMax[msg.sender] + msg.value) <= 5000000000000000000); } uint256 amount = msg.value * price; if (now > startDate && now <= bonusDate) { uint256 _amount = amount / 10; amount += _amount * 3; } balanceOfEther[msg.sender] += msg.value / 1 ether; tokenReward.transfer(msg.sender, amount); whitelistedMax[msg.sender] = whitelistedMax[msg.sender] + msg.value; FundTransfer(msg.sender, amount, true); owner.transfer(msg.value); }",
        "vulnerability": "Potential Reentrancy",
        "reason": "The fallback function transfers tokens and Ether without proper reentrancy protection. An attacker could exploit this by re-entering the contract before state changes are finalized, potentially extracting more funds than allowed.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    }
]