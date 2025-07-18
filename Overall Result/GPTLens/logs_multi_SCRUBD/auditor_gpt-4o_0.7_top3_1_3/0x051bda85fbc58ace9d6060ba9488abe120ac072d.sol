[
    {
        "function_name": "launch",
        "code": "function launch() external onlyOwner returns (bool){ require(!tradingActive, \"Trading is already active, cannot relaunch.\"); enableTrading(); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); excludeFromMaxTransaction(address(_uniswapV2Router), true); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); excludeFromMaxTransaction(address(uniswapV2Pair), true); _setAutomatedMarketMakerPair(address(uniswapV2Pair), true); require(address(this).balance > 0, \"Must have ETH on contract to launch\"); addLiquidity(balanceOf(address(this)), address(this).balance); transferOwnership(_owner); launchTime = block.timestamp; charityFee = 1; return true; }",
        "vulnerability": "Immediate Launch and Liquidity Addition",
        "reason": "The function does not have any mechanism to delay the launch or liquidity addition after contract deployment. This allows a malicious owner to launch the contract and add liquidity immediately without giving users time to react or participate, potentially leading to a rug-pull scenario.",
        "file_name": "0x051bda85fbc58ace9d6060ba9488abe120ac072d.sol"
    },
    {
        "function_name": "removeBoughtEarly",
        "code": "function removeBoughtEarly(address account) external onlyOwner { boughtEarly[account] = false; emit RemovedSniper(account); }",
        "vulnerability": "Owner Can Remove Early Buyer Penalty",
        "reason": "The owner has the ability to remove the early buy penalty from any account. This could be exploited to show favoritism by removing penalties for certain accounts, potentially creating an unfair advantage and undermining the penalty mechanism.",
        "file_name": "0x051bda85fbc58ace9d6060ba9488abe120ac072d.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Potential Pre-Launch Fund Drain",
        "reason": "The owner can withdraw any ETH in the contract before trading starts. If any ETH is sent to the contract before launch, the owner can drain it, which might not be the expected behavior for users who mistakenly send ETH hoping for participation or airdrops.",
        "file_name": "0x051bda85fbc58ace9d6060ba9488abe120ac072d.sol"
    }
]