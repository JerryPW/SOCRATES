[
    {
        "function_name": "function () payable public",
        "code": "function () payable public { amount = msg.value; uint256 tobesent = amount/price; tokenReward.transfer(msg.sender, tobesent*10e7); }",
        "vulnerability": "Integer Overflow",
        "reason": "The calculation of 'tobesent*10e7' can lead to an integer overflow if 'tobesent' is sufficiently large. This would allow an attacker to receive more tokens than intended.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public onlyCreator { uint amount = address(this).balance; owner.send(amount); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'send' to transfer ether is unsafe as it does not properly handle the failure of the transfer. If the transfer fails, the funds will be locked in the contract.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "function () payable public",
        "code": "function () payable public { amount = msg.value; uint256 tobesent = amount/price; tokenReward.transfer(msg.sender, tobesent*10e7); }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function makes an external call to 'tokenReward.transfer' before updating any state, which could allow a reentrancy attack if the token contract is malicious.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    }
]