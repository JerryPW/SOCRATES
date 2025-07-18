[
    {
        "function_name": "recoverTokens",
        "vulnerability": "Token recovery by deployer",
        "criticism": "The reasoning is correct. The deployer can transfer any tokens from the contract to their own address, which could lead to a loss of tokens intended for other purposes. However, this is not a vulnerability but a design decision that could be questionable. The severity is high because it can cause significant losses. The profitability is high because the deployer can profit from it.",
        "correctness": 7,
        "severity": 8,
        "profitability": 9,
        "reason": "The recoverTokens function allows the deployer to transfer any tokens from the contract to their own address, except for the uniswapV2Pair tokens if the current time is less than aggregateLockTime. This can be used by the deployer to transfer out any tokens, potentially leading to a loss of tokens intended for other purposes.",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _deployer); if (block.timestamp < aggregateLockTime) { require(tokenAddress != uniswapV2PairAddress); } IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this))); }",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol",
        "final_score": 7.75
    },
    {
        "function_name": "openTrading",
        "vulnerability": "High initial fees on trading open",
        "criticism": "The reasoning is correct. The owner can set high transaction fees when trading opens, which could lead to significant losses for early traders. However, this is not a vulnerability but a design decision that could be questionable. The severity is high because it can cause significant losses. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 8,
        "profitability": 0,
        "reason": "The openTrading function sets fee1 and fee2 to 200 and 490 respectively, which means a 20% and 49% fee on transactions immediately after trading is opened. This can be exploited by the owner to apply high transaction fees initially, potentially leading to a significant loss for early traders.",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,address(this)); fee1 = 200; fee2 = 490; swapEnabled = true; tradingOpen = true; time = block.timestamp + (3 minutes); }",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol",
        "final_score": 5.5
    },
    {
        "function_name": "removeLimits",
        "vulnerability": "Unlimited transaction and wallet limits",
        "criticism": "The reasoning is correct. The deployer can remove any transaction and wallet limits, which could lead to large, potentially market-manipulating transactions. However, this is not a vulnerability but a design decision that could be questionable. The severity is high because it can cause significant market manipulation. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 8,
        "profitability": 0,
        "reason": "The removeLimits function allows the deployer to set the maximum transaction and wallet amounts to the total supply, effectively removing any transaction and wallet limits. This can be exploited by the deployer to allow for large, potentially market-manipulating transactions, which can negatively impact token holders.",
        "code": "function removeLimits() external { require(_msgSender() == _deployer); _maxTxAmount = _tTotal; _maxWalletAmount = _tTotal; }",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol",
        "final_score": 5.5
    }
]