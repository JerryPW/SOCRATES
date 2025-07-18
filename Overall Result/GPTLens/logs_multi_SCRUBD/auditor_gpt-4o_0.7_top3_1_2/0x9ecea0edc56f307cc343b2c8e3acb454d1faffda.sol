[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther( address to, uint value) public onlyBZx returns (bool) { uint amount = value; if (amount > address(this).balance) { amount = address(this).balance; } return (to.send(amount)); }",
        "vulnerability": "Potential loss of ether due to send call",
        "reason": "The use of the send method to transfer ether is not recommended because it only forwards 2,300 gas, which may not be enough to complete the transaction if the receiving contract has a fallback function that consumes more gas. This could result in ether being stuck in the contract.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20Transfer",
        "code": "function eip20Transfer( address token, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transfer(to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20Transfer failed\"); }",
        "vulnerability": "Non-standard ERC20 token handling",
        "reason": "This function assumes that a non-compliant token will either not return data or will return a 32-byte boolean success value. If a token returns data in a different format or fails to return any data (in cases of revert), the function could incorrectly assume success or failure, leading to incorrect behavior.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20TransferFrom",
        "code": "function eip20TransferFrom( address token, address from, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transferFrom(from, to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20TransferFrom failed\"); }",
        "vulnerability": "Non-standard ERC20 token handling",
        "reason": "Similar to eip20Transfer, this function assumes a specific way a token should respond, which may not hold true for all non-compliant tokens, potentially leading to incorrect handling of token transfers if the token's response does not match expected patterns.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    }
]