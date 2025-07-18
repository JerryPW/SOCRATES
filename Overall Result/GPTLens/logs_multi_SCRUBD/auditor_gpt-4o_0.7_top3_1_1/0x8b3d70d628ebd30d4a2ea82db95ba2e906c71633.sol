[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther( address payable to, uint256 value) public onlyBZx returns (bool) { uint256 amount = value; if (amount > address(this).balance) { amount = address(this).balance; } return (to.send(amount)); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The use of to.send(amount) is susceptible to reentrancy attacks. The send function only forwards 2300 gas, but if the receiving contract is able to execute a fallback function, it could potentially call back into the withdrawEther function or other state-changing functions before the state is fully updated.",
        "file_name": "0x8b3d70d628ebd30d4a2ea82db95ba2e906c71633.sol"
    },
    {
        "function_name": "eip20Transfer",
        "code": "function eip20Transfer( address token, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transfer(to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20Transfer failed\"); }",
        "vulnerability": "Handling of non-standard ERC20 tokens",
        "reason": "The function assumes that the transfer operation will either return no data or a boolean value. However, if the token contract does not adhere to these assumptions, it could lead to unexpected behavior. Non-standard tokens might not revert on failure, causing the function to incorrectly assume the transfer was successful.",
        "file_name": "0x8b3d70d628ebd30d4a2ea82db95ba2e906c71633.sol"
    },
    {
        "function_name": "eip20TransferFrom",
        "code": "function eip20TransferFrom( address token, address from, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transferFrom(from, to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20TransferFrom failed\"); }",
        "vulnerability": "Handling of non-standard ERC20 tokens",
        "reason": "Similarly to eip20Transfer, this function assumes that the transferFrom operation will either return no data or a boolean value. Non-standard ERC20 tokens might not adhere to these expectations, potentially causing the function to accept a failed transfer as successful, leading to incorrect contract state.",
        "file_name": "0x8b3d70d628ebd30d4a2ea82db95ba2e906c71633.sol"
    }
]