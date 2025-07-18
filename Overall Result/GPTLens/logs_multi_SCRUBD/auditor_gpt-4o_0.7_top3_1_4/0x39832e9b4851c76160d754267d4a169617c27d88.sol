[
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken(address _tokenContract) external onlyOwner { IERC20 tokenContract = IERC20(_tokenContract); tokenContract.transfer(marketingAddress, balanceOf(address(tokenContract))); }",
        "vulnerability": "ERC20 token theft",
        "reason": "The function allows the owner to transfer all tokens of any ERC20 contract balance held by this contract to a marketing address without restriction. This can be exploited if the contract inadvertently holds tokens from other users or projects, leading to unauthorized token withdrawals.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public payable onlyOwner { payable(marketingAddress).transfer(address(this).balance); }",
        "vulnerability": "ETH balance draining",
        "reason": "This function allows the contract owner to transfer the entire balance of ETH held by the contract to the marketing address. This is problematic as it allows the owner to drain all ETH held in the contract, potentially including ETH sent by mistake or for other purposes.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "transferForeignToken",
        "code": "function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) { require(_token != address(0), \"_token address cannot be 0\"); require(_token != address(this), \"Can't withdraw native tokens\"); uint256 _contractBalance = IERC20(_token).balanceOf(address(this)); _sent = IERC20(_token).transfer(_to, _contractBalance); emit TransferForeignToken(_token, _contractBalance); }",
        "vulnerability": "ERC20 token theft",
        "reason": "This function allows the owner to transfer all tokens of any specified ERC20 contract balance held by this contract to a specified address. This can be exploited if the contract inadvertently holds tokens from other users or projects, leading to unauthorized token withdrawals.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    }
]