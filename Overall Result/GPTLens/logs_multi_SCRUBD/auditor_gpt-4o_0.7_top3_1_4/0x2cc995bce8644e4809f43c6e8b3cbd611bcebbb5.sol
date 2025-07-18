[
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _deployer); minBalance = newMin; }",
        "vulnerability": "Centralized Control",
        "reason": "The `changeMinBalance` function allows the deployer to set the `minBalance` variable to any value, which can impact the swap and liquidity functions. This centralization poses a risk as the deployer can manipulate the contract for personal gain or to harm users.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,address(this)); fee1 = 200; fee2 = 490; swapEnabled = true; tradingOpen = true; time = block.timestamp + (3 minutes); }",
        "vulnerability": "High Fees Post-Launch",
        "reason": "The `openTrading` function sets `fee1` and `fee2` to extremely high values (20% and 49% respectively) right after trading is opened. This could be used to exploit early traders who might not be aware of the fee change, and it can be detrimental to users who attempt to trade immediately after the contract is deployed.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock() external { require(_msgSender() == _deployer); require(block.timestamp >= aggregateLockTime); uniswapV2Pair.transfer(_deployer,uniswapV2Pair.balanceOf(address(this))); }",
        "vulnerability": "Liquidity Unlocking",
        "reason": "The `unlock` function allows the deployer to transfer the entire balance of the Uniswap V2 Pair from the contract to their own address once the lock time has expired. This could be used to drain liquidity from the DEX, effectively rug-pulling liquidity providers and traders.",
        "file_name": "0x2cc995bce8644e4809f43c6e8b3cbd611bcebbb5.sol"
    }
]