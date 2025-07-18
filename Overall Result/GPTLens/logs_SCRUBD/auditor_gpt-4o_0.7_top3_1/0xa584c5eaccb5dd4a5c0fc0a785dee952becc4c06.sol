[
    {
        "function_name": "function()",
        "code": "function () payable public { amount = msg.value; uint256 tobesent = amount/price; tokenReward.transfer(msg.sender, tobesent*10e7); }",
        "vulnerability": "Arithmetic Precision Error",
        "reason": "The calculation of 'tobesent' uses integer division which can lead to rounding down of the amount of tokens to be sent. Additionally, the multiplication by 10e7 is meant to adjust token decimals but is incorrectly formatted and will result in a substantially larger amount being transferred than intended. This can lead to an attacker receiving more tokens than they should.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() public onlyCreator { uint amount = address(this).balance; owner.send(amount); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'send' for transferring Ether can lead to failure of the transaction due to its gas limits, which can leave the contract in an inconsistent state. If the 'send' fails, it returns false but does not revert the transaction. This can be exploited by an attacker to lock Ether in the contract, making it impossible for the owner to withdraw funds.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    },
    {
        "function_name": "updateOwner",
        "code": "function updateOwner(address newOwner) public onlyCreator{ owner = newOwner; }",
        "vulnerability": "Ownership Takeover",
        "reason": "The function allows the owner to update the contract ownership without any restrictions or checks on the new owner address. If the owner account is compromised, the attacker can easily transfer ownership to themselves, gaining full control over the contract and its funds.",
        "file_name": "0xa584c5eaccb5dd4a5c0fc0a785dee952becc4c06.sol"
    }
]