[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public virtual onlyOwner { emit OwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Lack of input validation",
        "reason": "The function does not check if the new owner address is a zero address. Transferring ownership to the zero address would result in the contract becoming ownerless and hence, non-upgradable, leading to a potential loss of control over the contract.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buy, uint256 _sell) external { require(_msgSender() == _deployer); require(_buy <= 100 && _sell <= 100,\"cannot set fees above 10%\"); fee1 = _buy; fee2 = _sell; }",
        "vulnerability": "Misleading fee limit validation",
        "reason": "The function checks that the `_buy` and `_sell` fees are less than or equal to 100, but the comment suggests it cannot be set above 10%. This discrepancy could allow for higher than intended fees, potentially up to 10%, not 1% as might be assumed from the comment.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "editPercentages",
        "code": "function editPercentages(uint256 _pc1, uint256 _pc2, uint256 _pc3) external { require(_msgSender() == _deployer); require(_pc1 + _pc2 + _pc3 == 100,\"math faggot\"); pc1 = _pc1; pc2 = _pc2; pc3 = _pc3; }",
        "vulnerability": "Inappropriate error message",
        "reason": "The error message used in the require statement is offensive and unprofessional. This could lead to reputational damage and is not suitable for a public smart contract.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    }
]