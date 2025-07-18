[
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buy, uint256 _sell) external { require(_msgSender() == _deployer); require(_buy <= 100 && _sell <= 100,\"cannot set fees above 10%\"); fee1 = _buy; fee2 = _sell; }",
        "vulnerability": "Potentially high fee setting",
        "reason": "The function allows the deployer to set buy and sell fees up to 100% (incorrect error message suggesting 10%), which could allow the deployer to effectively confiscate all tokens transferred in transactions, leading to a potential rug pull scenario.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public virtual onlyOwner { emit OwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Immediate ownership transfer without checks",
        "reason": "The function allows the current owner to transfer ownership to any address without any checks or confirmation, which could be exploited if the owner's private key is compromised, leading to a complete takeover by an attacker.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _deployer); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Unauthorized token recovery",
        "reason": "The function allows the deployer to recover any ERC20 tokens accidentally sent to the contract. While this is useful, it could also be misused to drain all tokens from the contract, including those that should not be transferable, without any community or multi-signature approval.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    }
]