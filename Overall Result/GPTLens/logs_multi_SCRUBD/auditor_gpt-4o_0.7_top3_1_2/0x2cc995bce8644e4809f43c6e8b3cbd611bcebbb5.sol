[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public virtual onlyOwner { emit OwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Insecure Ownership Transfer",
        "reason": "The transferOwnership function lacks any checks to prevent the owner from transferring ownership to an invalid or undesired address, such as a zero address or a contract address. This could potentially lock the contract if ownership is transferred to an unintended address.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buy, uint256 _sell) external { require(_msgSender() == _deployer); require(_buy <= 100 && _sell <= 100,\"cannot set fees above 10%\"); fee1 = _buy; fee2 = _sell; }",
        "vulnerability": "Incorrect Fee Limit Enforcement",
        "reason": "The changeFees function attempts to limit the fees to a maximum of 10%, but the require statement checks that the fees are less than or equal to 100, which represents 100% due to the scaling by 1000 in _getTValues. This allows the deployer to set the fees to any percentage up to 100%, which is likely unintended and potentially malicious.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock() external { require(_msgSender() == _deployer); require(block.timestamp >= aggregateLockTime); uniswapV2Pair.transfer(_deployer,uniswapV2Pair.balanceOf(address(this))); }",
        "vulnerability": "Potential Loss of Liquidity",
        "reason": "The unlock function allows the deployer to transfer all liquidity from the contract to themselves once the lock time expires. This could be exploited by the deployer to drain the liquidity pool, negatively impacting token holders by reducing the token's market liquidity.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    }
]