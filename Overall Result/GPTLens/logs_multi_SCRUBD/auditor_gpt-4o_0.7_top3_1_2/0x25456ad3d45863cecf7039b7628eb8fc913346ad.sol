[
    {
        "function_name": "setBlackList",
        "code": "function setBlackList(address addr, bool value) external onlyOwner { _isBlackListed[addr] = value; }",
        "vulnerability": "Misuse of Blacklist",
        "reason": "The `setBlackList` function allows the owner to arbitrarily blacklist addresses. This is a centralization risk and can be exploited by the contract owner to block legitimate users from participating in transactions. It can also be used maliciously to freeze funds of users, which is against the decentralized ethos of blockchain.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address _token) external onlyOwner { require(_token != address(this), \"No rugs\"); if (_token == address(0x0)) { payable(owner()).transfer(address(this).balance); return; } IERC20 erc20token = IERC20(_token); uint256 balance = erc20token.balanceOf(address(this)); erc20token.transfer(owner(), balance); }",
        "vulnerability": "Owner Token Drain",
        "reason": "The `claimStuckTokens` function allows the owner to transfer any ERC20 tokens from the contract to themselves. This includes all tokens except the contract's native token. This function poses a risk as it allows the owner to drain tokens from the contract, which could be detrimental to the interests of token holders if used maliciously.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "updateRouter",
        "code": "function updateRouter(address newAddress) external onlyOwner { require(newAddress != address(uniswapV2Router), \"LUNRR: The router already has that address\"); uniswapV2Router = IUniswapV2Router02(newAddress); address get_pair = IUniswapV2Factory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH()); if (get_pair == address(0)) { uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH()); } else { uniswapV2Pair = get_pair; } }",
        "vulnerability": "Router Manipulation",
        "reason": "The `updateRouter` function allows the owner to change the Uniswap router address. This could be exploited by setting the router to a malicious contract, thus redirecting swaps and potentially resulting in loss of funds for the users. This introduces a centralization risk and undermines the trust in the contract.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    }
]