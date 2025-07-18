[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _newOwner) public virtual onlyOwner { emit OwnershipTransferred(_owner, _newOwner); _owner = _newOwner; }",
        "vulnerability": "Potential for new owner to be set to zero address",
        "reason": "The function lacks a check to ensure that the new owner address is not the zero address. This could result in the contract being locked without an owner if the current owner mistakenly sets the new owner to the zero address. This would prevent the execution of any `onlyOwner` functions, effectively rendering the contract non-upgradable and potentially locking funds.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,address(this)); fee1 = 200; fee2 = 490; swapEnabled = true; tradingOpen = true; time = block.timestamp + (3 minutes); }",
        "vulnerability": "Manipulation of Fees",
        "reason": "The `openTrading` function sets very high fees (20% for buying and 49% for selling) when opening trading. This could be exploited by the owner to impose excessive transaction fees on early traders, potentially scaring away investors and harming the token's market reputation. The fees can also be changed at any time by the owner using the `changeFees` function, adding further risk of manipulation.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _deployer); if (block.timestamp < aggregateLockTime) { require(tokenAddress != uniswapV2PairAddress); } IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token Recovery Exploit",
        "reason": "The `recoverTokens` function allows the deployer to recover tokens from the contract except the token paired with Uniswap if before the `aggregateLockTime`. After this time, it could allow the deployer to recover any tokens, including liquidity pool tokens, which could include users' liquidity, effectively pulling liquidity from the market and causing significant financial harm to users.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    }
]