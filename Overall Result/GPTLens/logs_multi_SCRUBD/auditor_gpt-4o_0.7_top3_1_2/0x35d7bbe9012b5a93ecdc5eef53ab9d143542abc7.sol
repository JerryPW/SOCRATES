[
    {
        "function_name": "withdrawForeignTokens",
        "code": "function withdrawForeignTokens(address _tokenContract, address _to) onlySigner public returns (bool) { require(_tokenContract != address(this), \"cannot withdraw Fog\"); require(_tokenContract != address(uniswapV2Pair), \"cannot withdraw FOG LP\"); ERC20 token = ERC20(_tokenContract); uint256 amount = token.balanceOf(address(this)); return token.transfer(_to, amount); }",
        "vulnerability": "Unauthorized token withdrawal",
        "reason": "The function allows any signer to withdraw tokens other than FOG and FOG LP from the contract. If an attacker gains signer privileges, they could drain all other tokens from the contract. This is a critical vulnerability as it weakens the security model and trust in the contract by allowing potentially unauthorized withdrawals of valuable assets.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Router",
        "code": "function setUniswapV2Router(address _uniswapV2Router) public onlySigner { require(uniswapV2Router == address(0), \"FogToken::setUniswapV2Router: already set\"); uniswapV2Router = _uniswapV2Router; }",
        "vulnerability": "Router address can be set only once",
        "reason": "The function allows the UniswapV2Router address to be set once by any signer. However, this address cannot be modified or updated later. If an incorrect address is set, or if the contract at the current router address becomes obsolete or compromised, the contract could become non-functional for token swaps, affecting usability and liquidity operations.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Pair",
        "code": "function setUniswapV2Pair(address _uniswapV2Pair) public onlySigner { require(uniswapV2Pair == address(0), \"FogToken::setUniswapV2Pair: already set\"); uniswapV2Pair = _uniswapV2Pair; }",
        "vulnerability": "Pair address can be set only once",
        "reason": "Similar to the router, this function allows the UniswapV2Pair address to be set once by any signer. If the address is set incorrectly or if the pair needs to be updated due to changes in the market or a need for a new liquidity pool, it cannot be changed, which could hinder the contract's flexibility and adaptability in liquidity provision.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    }
]