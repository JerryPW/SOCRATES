[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public virtual onlyOwner { emit OwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Lack of new owner validation",
        "reason": "The transferOwnership function does not validate the _newOwner address. This could result in transferring ownership to an unintended address, such as the zero address, which could lock critical functionalities of the contract.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,address(this)); fee1 = 200; fee2 = 490; swapEnabled = true; tradingOpen = true; time = block.timestamp + (3 minutes); }",
        "vulnerability": "High initial fees set during trading open",
        "reason": "The openTrading function sets very high initial fees of fee1 = 200 (20%) and fee2 = 490 (49%). This could be used maliciously by the owner to excessively tax transactions right after opening trading, which may not be expected by users.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _deployer); if (block.timestamp < aggregateLockTime) { require(tokenAddress != uniswapV2PairAddress); } IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token recovery without time restriction",
        "reason": "The recoverTokens function allows the deployer to recover any tokens held by the contract at any time, except the pair token before the lock time. This can lead to loss of user funds if tokens were accidentally sent to the contract or if the deployer maliciously drains tokens held by the contract.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    }
]