[
    {
        "function_name": "setNewRouter",
        "code": "function setNewRouter(address newRouter) public onlyOwner { IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter); address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH()); if (get_pair == address(0)) { lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH()); } else { lpPair = get_pair; } dexRouter = _newRouter; }",
        "vulnerability": "Unrestricted Router Update",
        "reason": "The `setNewRouter` function allows the contract owner to update the router address without any restrictions or checks. This could enable the owner to set a malicious router that could potentially manipulate token swaps or liquidity operations, leading to a loss of funds for users.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "enableTrading",
        "code": "function enableTrading(uint8 _block) external onlyOwner { require(!tradingEnabled, \"Trading already enabled!\"); require (snipeBlockAmt == 0 && !_hasLiqBeenAdded); snipeBlockAmt = _block; setExcludedFromReward(address(this), true); setExcludedFromReward(owner(), true); setExcludedFromReward(burnAddress, true); setExcludedFromReward(lpPair, true); setExcludedFromReward(_devWallet, true); setExcludedFromReward(_marketingWallet, true); _liqAddBlock = block.number; tradingEnabled = true; }",
        "vulnerability": "Potential Sniping Exploit",
        "reason": "The `enableTrading` function sets the `snipeBlockAmt` and enables trading. If the owner sets a low value for `_block`, it could allow bots to snipe tokens when liquidity is added. This vulnerability can result in an unfair advantage for bots or malicious actors at the expense of regular users.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    },
    {
        "function_name": "sweepTokens",
        "code": "function sweepTokens(address token) external onlyOwner { IERC20 toTransfer = IERC20(token); toTransfer.transfer(msg.sender, toTransfer.balanceOf(address(this))); }",
        "vulnerability": "Token Sweeping by Owner",
        "reason": "The `sweepTokens` function allows the contract owner to transfer any ERC20 tokens held by the contract to the owner's address. This can be exploited by the owner to drain tokens that are accidentally sent to the contract, potentially resulting in significant losses for users who mistakenly send tokens to the contract address.",
        "file_name": "0x126bf7880a9597e2760380d44d147c90cd75ee39.sol"
    }
]