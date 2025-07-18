[
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken(address _tokenContract) external onlyOwner {\n    IERC20 tokenContract = IERC20(_tokenContract);\n    tokenContract.transfer(marketingAddress, balanceOf(address(tokenContract)));\n}",
        "vulnerability": "ERC20 tokens draining vulnerability",
        "reason": "The `withdrawToken` function allows the owner to transfer all tokens of any ERC20 contract that this contract holds to the marketing address. This can result in draining any ERC20 token accidentally or maliciously sent to the contract, as the contract owner can withdraw these tokens without restriction.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public payable onlyOwner {\n    payable(marketingAddress).transfer(address(this).balance);\n}",
        "vulnerability": "Native ETH draining vulnerability",
        "reason": "The `withdraw` function permits the contract owner to transfer all ETH held in the contract to the marketing address. This functionality allows the potential draining of ETH from the contract, which might have been sent mistakenly or intended for other purposes.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "transferForeignToken",
        "code": "function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {\n    require(_token != address(0), \"_token address cannot be 0\");\n    require(_token != address(this), \"Can't withdraw native tokens\");\n    uint256 _contractBalance = IERC20(_token).balanceOf(address(this));\n    _sent = IERC20(_token).transfer(_to, _contractBalance);\n    emit TransferForeignToken(_token, _contractBalance);\n}",
        "vulnerability": "Foreign token draining vulnerability",
        "reason": "The `transferForeignToken` function allows the owner to transfer all balance of any foreign ERC20 tokens held by the contract to a specified address. This function can be exploited by the contract owner to misappropriate any foreign tokens sent to this contract, either accidentally or maliciously.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    }
]