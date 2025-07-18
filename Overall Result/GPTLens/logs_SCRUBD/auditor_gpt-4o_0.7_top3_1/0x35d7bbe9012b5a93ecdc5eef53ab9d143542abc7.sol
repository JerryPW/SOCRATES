[
    {
        "function_name": "withdrawForeignTokens",
        "code": "function withdrawForeignTokens(address _tokenContract, address _to) onlySigner public returns (bool) { require(_tokenContract != address(this), \"cannot withdraw Fog\"); require(_tokenContract != address(uniswapV2Pair), \"cannot withdraw FOG LP\"); ERC20 token = ERC20(_tokenContract); uint256 amount = token.balanceOf(address(this)); return token.transfer(_to, amount); }",
        "vulnerability": "Token theft by privileged role",
        "reason": "The withdrawForeignTokens function allows any signer to withdraw any ERC20 tokens held by the contract. This includes tokens that may have been sent to the contract mistakenly or for safekeeping. The function only prohibits the withdrawal of the contract's own tokens and its Uniswap liquidity tokens, allowing any other tokens to be transferred out to any address specified by the signer. This poses a risk of token theft by a malicious or compromised signer role.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Router",
        "code": "function setUniswapV2Router(address _uniswapV2Router) public onlySigner { require(uniswapV2Router == address(0), \"FogToken::setUniswapV2Router: already set\"); uniswapV2Router = _uniswapV2Router; }",
        "vulnerability": "Irreversible critical address setting",
        "reason": "The setUniswapV2Router function allows a signer to set the Uniswap V2 Router address only once, after which it cannot be changed. This can be problematic if the initially set address is incorrect or if the Uniswap contract address changes (for example, due to an upgrade or a bug in the current contract). The inability to update this address could lead to the contract becoming unusable for its intended purpose of interacting with Uniswap.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Pair",
        "code": "function setUniswapV2Pair(address _uniswapV2Pair) public onlySigner { require(uniswapV2Pair == address(0), \"FogToken::setUniswapV2Pair: already set\"); uniswapV2Pair = _uniswapV2Pair; }",
        "vulnerability": "Irreversible critical address setting",
        "reason": "Similar to setUniswapV2Router, the setUniswapV2Pair function allows a signer to set the Uniswap V2 Pair address only once. If the address is set incorrectly or if there are changes required in the future (such as a new pair due to migration or updates), the inability to update this address could render functions that depend on this pair address non-functional.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    }
]