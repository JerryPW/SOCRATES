[
    {
        "function_name": "sweep",
        "code": "function sweep() external returns (bool success) { require(this.balance > 0); return owner.send(this.balance); }",
        "vulnerability": "Use of send() instead of transfer()",
        "reason": "The function uses send(), which only forwards 2300 gas, potentially causing the transfer to fail if the fallback function of the recipient requires more gas. This can lead to a denial-of-service (DoS) issue, where funds are stuck in the contract.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    },
    {
        "function_name": "transferToken",
        "code": "function transferToken(address _tokenContractAddress, address _to, uint256 _amount) external onlyOwner returns (bool success) { ERC20 token = ERC20(_tokenContractAddress); return token.transfer(_to, _amount); }",
        "vulnerability": "Lack of return value check for ERC20 transfer",
        "reason": "The function does not check the return value of the transfer function. If the ERC20 token does not follow the standard and returns false instead of reverting on failure, the transfer might fail silently without reverting, potentially leading to loss of funds or unexpected behavior.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    },
    {
        "function_name": "transferNonFungibleTokenMulti",
        "code": "function transferNonFungibleTokenMulti(address _tokenContractAddress, address _to, uint256[] _tokenIds) external onlyOwner { ERC721 token = ERC721(_tokenContractAddress); for (uint i = 0; i < _tokenIds.length; i++) { token.transfer(_to, _tokenIds[i]); } }",
        "vulnerability": "Lack of input validation and potential DoS with block gas limit",
        "reason": "The function does not validate the length of the _tokenIds array. If a very large array is passed, it could exceed the block gas limit during execution, causing the transaction to fail. This can be exploited by an attacker to perform a denial-of-service (DoS) attack on the function.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    }
]