[
    {
        "function_name": "swapTokensForETHmkt",
        "code": "function swapTokensForETHmkt(uint256 amount)private { address[] memory path = new address[](2); path[0] = address(this); path[1] = _router.WETH(); _approve(address(this), address(_router), amount); _router.swapExactTokensForETHSupportingFeeOnTransferTokens( amount, 0, path, marketingAddress, block.timestamp ); }",
        "vulnerability": "Potential Loss of Funds",
        "reason": "The function uses a hardcoded return address (marketingAddress) without any checks for validity or changes. If the marketingAddress is compromised or set to an incorrect address, funds could be permanently lost during the token swap.",
        "file_name": "0x0d75899cab4eec7b22b5bf3d4dd4d965ada8a8cb.sol"
    },
    {
        "function_name": "tradeStatus",
        "code": "function tradeStatus(bool status) public onlyOwner{ tradeEnabled = status; }",
        "vulnerability": "Centralization Risk",
        "reason": "The tradeEnabled flag can be set by the contract owner at any time, providing centralized control over whether trading is allowed. This could be exploited if the owner decides to halt trading arbitrarily, affecting token holders' ability to trade.",
        "file_name": "0x0d75899cab4eec7b22b5bf3d4dd4d965ada8a8cb.sol"
    },
    {
        "function_name": "addBotWallet",
        "code": "function addBotWallet (address payable detectedBot, bool isBot) public onlyOwner{ botWallets[detectedBot] = isBot; }",
        "vulnerability": "Censorship Risk",
        "reason": "The function allows the contract owner to unilaterally mark an address as a bot, effectively banning it from trading. This presents a risk of arbitrary censorship where legitimate addresses could be labeled as bots and restricted from trading.",
        "file_name": "0x0d75899cab4eec7b22b5bf3d4dd4d965ada8a8cb.sol"
    }
]