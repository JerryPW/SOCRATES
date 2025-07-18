[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Authorization flaw",
        "reason": "The transferOwnership function does not remove the old owner's authorization. This allows the previous owner to retain control over the contract, which can lead to unauthorized actions after ownership transfer.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "removeShareholder",
        "code": "function removeShareholder(address shareholder) internal { shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1]; shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder]; shareholders.pop(); }",
        "vulnerability": "Incorrect index update",
        "reason": "The removeShareholder function updates the index of the last shareholder to the index of the shareholder being removed, but does not update the index of the swapped shareholder in the shareholderIndexes mapping. This results in incorrect mapping of shareholder indexes, leading to potential errors in future operations involving shareholders.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(uint256 amount, address to) internal swapping { address[] memory path = new address[](2); path[0] = WETH; path[1] = address(this); router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : amount}( 0, path, to, block.timestamp ); }",
        "vulnerability": "No slippage protection",
        "reason": "The buyTokens function uses swapExactETHForTokensSupportingFeeOnTransferTokens without specifying a minimum amount of tokens to buy, allowing for potential slippage exploitation. This can lead to a situation where an attacker manipulates the price on the decentralized exchange, causing the contract to receive fewer tokens than expected.",
        "file_name": "0x05a4909d737d0a6433335504d25536e12f65a4e5.sol"
    }
]