[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther( address to, uint value) public onlyBZx returns (bool) { uint amount = value; if (amount > address(this).balance) { amount = address(this).balance; } return (to.send(amount)); }",
        "vulnerability": "use of send",
        "reason": "The use of 'send' is discouraged because it only forwards 2300 gas, which may not be enough for the receiving contract to execute its logic, leading to potential failures. This can result in stuck funds or denial of service.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken( address token, address to, uint tokenAmount) public onlyBZx returns (bool) { if (tokenAmount == 0) { return false; } eip20Transfer( token, to, tokenAmount); return true; }",
        "vulnerability": "non-compliant token handling",
        "reason": "The function uses an assembly block to handle token transfer success checks, which assumes the token adheres to the standard that returns a boolean success value. However, non-compliant tokens could return 'true' even if the transfer failed, leading to potential inconsistencies in the contract's state.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    },
    {
        "function_name": "eip20Transfer",
        "code": "function eip20Transfer( address token, address to, uint256 value) internal returns (bool result) { NonCompliantEIP20(token).transfer(to, value); assembly { switch returndatasize() case 0 { result := not(0) } case 32 { returndatacopy(0, 0, 32) result := mload(0) } default { revert(0, 0) } } require(result, \"eip20Transfer failed\"); }",
        "vulnerability": "non-standard token handling",
        "reason": "The handling of the transfer result is based on assumptions about the token's compliance with standards. A non-compliant token could cause the function to incorrectly interpret the success or failure of a transfer, leading to possible incorrect fund management or state inconsistencies.",
        "file_name": "0x9ecea0edc56f307cc343b2c8e3acb454d1faffda.sol"
    }
]