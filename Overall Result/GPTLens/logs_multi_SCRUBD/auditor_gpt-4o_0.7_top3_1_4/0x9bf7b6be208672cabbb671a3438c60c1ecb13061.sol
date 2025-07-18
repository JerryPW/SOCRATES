[
    {
        "function_name": "sweep",
        "code": "function sweep() external returns (bool success) { require(this.balance > 0); return owner.send(this.balance); }",
        "vulnerability": "Unsafe Ether transfer using send",
        "reason": "The function uses the send method to transfer Ether to the owner, which only forwards 2300 gas units. This may fail if the owner address is a contract that requires more gas to execute its fallback function. Additionally, the function doesn't handle the failure case of send appropriately, potentially leading to stuck Ether.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    },
    {
        "function_name": "transferNonFungibleTokenMulti",
        "code": "function transferNonFungibleTokenMulti(address _tokenContractAddress, address _to, uint256[] _tokenIds) external onlyOwner { ERC721 token = ERC721(_tokenContractAddress); for (uint i = 0; i < _tokenIds.length; i++) { token.transfer(_to, _tokenIds[i]); } }",
        "vulnerability": "Lack of input validation and gas limit issues",
        "reason": "The function does not validate the length of the _tokenIds array, which could lead to gas limit issues if a very large array is passed. This could cause the transaction to fail and consume all provided gas. Additionally, there is no check to ensure that the same token ID isn't repeated, which might lead to unintended behavior or potential loss of tokens.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    },
    {
        "function_name": "sweepToken",
        "code": "function sweepToken(address _tokenContractAddress) external returns (bool success) { ERC20 token = ERC20(_tokenContractAddress); uint bal = token.balanceOf(this); require(bal > 0); return token.transfer(owner, bal); }",
        "vulnerability": "Unauthorized token sweeping",
        "reason": "The function allows anyone to call sweepToken and transfer all tokens of a given ERC20 contract address held by the contract to the owner. This should be restricted to the owner to prevent unauthorized token sweeping, which could lead to a loss of all tokens held by the contract.",
        "file_name": "0x9bf7b6be208672cabbb671a3438c60c1ecb13061.sol"
    }
]