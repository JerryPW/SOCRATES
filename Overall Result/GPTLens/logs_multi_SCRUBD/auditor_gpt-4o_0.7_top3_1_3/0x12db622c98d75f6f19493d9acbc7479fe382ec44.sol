[
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _to, uint256 _value) isCreator public { tokenReward.transfer(_to, _value); }",
        "vulnerability": "Unrestricted token transfer",
        "reason": "The sendToken function allows the creator to transfer any amount of tokens to any address without any limit checks or conditions. This can lead to unauthorized token transfers, draining the contract's token supply, and harming legitimate investors.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "kill",
        "code": "function kill() isCreator public { selfdestruct(owner); }",
        "vulnerability": "Destruction of contract",
        "reason": "The kill function allows the creator to self-destruct the contract at any time, sending all remaining Ether to the owner. This could be exploited to terminate the contract prematurely, potentially resulting in a loss of funds for investors if performed maliciously.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "function",
        "code": "function () payable public { require(msg.value > 0); require(now > startDate); require(now < endDate); require(whitelist[msg.sender]); if (categorie1[msg.sender] == false) { require((whitelistedMax[msg.sender] + msg.value) <= 5000000000000000000); } uint256 amount = msg.value * price; if (now > startDate && now <= bonusDate) { uint256 _amount = amount / 10; amount += _amount * 3; } balanceOfEther[msg.sender] += msg.value / 1 ether; tokenReward.transfer(msg.sender, amount); whitelistedMax[msg.sender] = whitelistedMax[msg.sender] + msg.value; FundTransfer(msg.sender, amount, true); owner.transfer(msg.value); }",
        "vulnerability": "Arithmetic overflow/underflow",
        "reason": "The calculation of the amount using msg.value * price can result in an overflow, especially since Solidity 0.4.21 does not have built-in overflow checks. This could lead to incorrect token distribution amounts, potentially resulting in large token allocations to attackers.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    }
]