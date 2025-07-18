[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public onlyCreator { uint amount = address(this).balance; owner.send(amount); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'send' for transferring Ether is unsafe because it does not propagate errors. If the transfer fails, the funds could be lost, and the contract does not handle this case, leading to potential funds being stuck.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable public { amount = msg.value; uint256 tobesent = amount/price; tokenReward.transfer(msg.sender, tobesent*10e7); }",
        "vulnerability": "Token Transfer Overflow",
        "reason": "The calculation 'tobesent*10e7' can cause an overflow if 'tobesent' is large enough. This could lead to incorrect token amounts being sent, potentially allowing attackers to receive more tokens than intended.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable public { amount = msg.value; uint256 tobesent = amount/price; tokenReward.transfer(msg.sender, tobesent*10e7); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function allows for a reentrancy attack because it transfers tokens before any state changes are made. An attacker could exploit this by re-entering the function and manipulating the 'amount' and 'tobesent' calculations to receive more tokens than they paid for.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    }
]