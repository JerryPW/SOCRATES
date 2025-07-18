[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther( address to, uint value) public onlyBZx returns (bool) { uint amount = value; if (amount > address(this).balance) { amount = address(this).balance; } return (to.send(amount)); }",
        "vulnerability": "Unsafe send method usage",
        "reason": "The function uses the send method to transfer Ether, which only forwards 2300 gas and may fail if the receiving contract does not have a fallback function or requires more gas. This could lock funds in the contract if the receiver is a contract that needs more gas to process the transaction.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20Transfer",
        "code": "function eip20Transfer( address token, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transfer(to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20Transfer failed\"); }",
        "vulnerability": "Non-standard token handling",
        "reason": "The function assumes that tokens will either return nothing or a boolean value indicating success. However, some tokens might not adhere to these assumptions, potentially causing false positives where the function thinks a transfer was successful even when it was not.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public onlyOwner { require(newOwner != address(0) && newOwner != bZxContractAddress, \"transferOwnership::unauthorized\"); emit OwnershipTransferred(owner, newOwner); owner = newOwner; }",
        "vulnerability": "Potential ownership renounce vulnerability",
        "reason": "The function allows the current owner to transfer ownership to any address except the bZxContractAddress. If an attacker gets access to the owner's private key or the owner accidentally sets the wrong address, control of the contract could be permanently lost, especially if set to an unintended address with no controlling entity.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    }
]