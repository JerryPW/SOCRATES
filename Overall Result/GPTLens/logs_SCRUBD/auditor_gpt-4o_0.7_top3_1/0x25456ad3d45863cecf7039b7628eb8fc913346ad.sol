[
    {
        "function_name": "setBlackList",
        "code": "function setBlackList(address addr, bool value) external onlyOwner { _isBlackListed[addr] = value; }",
        "vulnerability": "Centralized control over blacklisting",
        "reason": "The function allows the contract owner to arbitrarily blacklist any address, potentially freezing user funds. This centralized control can be abused, posing a risk to token holders who may be blacklisted without recourse.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "enableTrading",
        "code": "function enableTrading() external onlyOwner { isTradingEnabled = true; tradingStartBlock = block.number; }",
        "vulnerability": "Centralized control over trading",
        "reason": "The owner has the sole ability to enable trading, which means trading can be arbitrarily restricted or delayed, potentially affecting market fairness and liquidity. Investors are reliant on the owner to enable trading, which may not align with their interests.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address _token) external onlyOwner { require(_token != address(this), \"No rugs\"); if (_token == address(0x0)) { payable(owner()).transfer(address(this).balance); return; } IERC20 erc20token = IERC20(_token); uint256 balance = erc20token.balanceOf(address(this)); erc20token.transfer(owner(), balance); }",
        "vulnerability": "Potential misuse of claimStuckTokens",
        "reason": "The function allows the owner to transfer any ERC20 tokens held by the contract to the owner's address. Although it prevents the contract's own tokens from being transferred, other tokens can still be moved without restriction, which could be exploited if the contract inadvertently accumulates tokens belonging to users or other projects.",
        "file_name": "0x25456ad3d45863cecf7039b7628eb8fc913346ad.sol"
    }
]