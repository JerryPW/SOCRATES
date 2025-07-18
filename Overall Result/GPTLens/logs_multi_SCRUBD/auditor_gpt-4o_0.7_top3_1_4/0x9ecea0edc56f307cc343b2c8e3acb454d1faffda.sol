[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther( address to, uint value) public onlyBZx returns (bool) { uint amount = value; if (amount > address(this).balance) { amount = address(this).balance; } return (to.send(amount)); }",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The `withdrawEther` function uses `send` to transfer Ether, which forwards only 2300 gas and prevents reentrancy in some cases. However, it does not protect against reentrancy attacks completely as an attacker can call back into the contract through other means. Additionally, it lacks reentrancy guards, which makes it vulnerable if future changes or interactions with other contracts occur.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20Transfer",
        "code": "function eip20Transfer( address token, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transfer(to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20Transfer failed\"); }",
        "vulnerability": "Non-compliance with EIP20",
        "reason": "The `eip20Transfer` function interacts with tokens that may not comply with the EIP20 standard. It assumes that the `transfer` function either returns a boolean or does not return any data, possibly leading to unexpected behavior with tokens that follow the standard strictly. This can cause false positives in transaction success checks, leading to potential loss of assets.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20TransferFrom",
        "code": "function eip20TransferFrom( address token, address from, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transferFrom(from, to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20TransferFrom failed\"); }",
        "vulnerability": "Non-compliance with EIP20",
        "reason": "Similar to `eip20Transfer`, the `eip20TransferFrom` function does not handle the return values correctly for tokens that strictly comply with the EIP20 standard. This can lead to erroneous success confirmations and potential asset mismanagement.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    }
]