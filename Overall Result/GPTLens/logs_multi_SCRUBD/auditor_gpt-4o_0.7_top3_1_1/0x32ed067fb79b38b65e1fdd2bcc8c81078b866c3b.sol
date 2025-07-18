[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership transfer without authorization reset",
        "reason": "The function 'transferOwnership' directly sets the new owner and authorizes them without resetting the authorizations of the previous owner. This means if the previous owner was authorized, they remain authorized even after the ownership transfer, potentially allowing them to execute functions that require authorization.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "setRetrive",
        "code": "function setRetrive(uint256 amount) external authorized { payable(marketingFeeReceiver).transfer(amount); }",
        "vulnerability": "Unauthorized fund retrieval",
        "reason": "The 'setRetrive' function allows any authorized account to transfer an arbitrary amount of Ether from the contract to the marketing fee receiver. If an account other than the intended one is authorized, they could drain funds from the contract, posing a significant financial risk.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal { shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1]; shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder]; shareholders.pop(); }",
        "vulnerability": "Incorrect shareholder state update",
        "reason": "The 'removeShareholder' function incorrectly updates the shareholderIndexes by not properly handling the edge case where the shareholder to be removed is the last in the array. This could lead to incorrect index assignments or potential out-of-bound errors, resulting in incorrect shareholder management.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    }
]