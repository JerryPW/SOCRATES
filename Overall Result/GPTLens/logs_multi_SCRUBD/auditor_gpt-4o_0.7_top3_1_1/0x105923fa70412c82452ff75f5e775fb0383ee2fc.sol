[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(_isBlacklistWallet[from] == false, \"You're in blacklist\"); if(limitsEnabled){ if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){ require(amount <= maxBuyLimit,\"Over the Max buy\"); require(amount.add(balanceOf(to)) <= maxWallet); } if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !inSwapAndLiquify ){ if(!trading){ require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isinwl[to], \"Trading is not active.\"); } if (transferDelayEnabled){ if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){ require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"); _holderLastTransferTimestamp[tx.origin] = block.number; } } } } uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev); bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity; if ( !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && overMinTokenBalance ) { swapAndLiquify(); } bool takeFee = true; if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){ takeFee = false; } _tokenTransfer(from,to,amount,takeFee); }",
        "vulnerability": "Blacklist Bypass",
        "reason": "The _transfer function checks if the sender's address is blacklisted, however, there are no conditions to prevent a blacklisted address from receiving tokens. This could potentially allow a blacklisted address to circumvent restrictions by receiving tokens from non-blacklisted addresses.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Centralized Control of Blacklist",
        "reason": "This function allows the owner to arbitrarily blacklist addresses, giving the owner excessive control over the ability of users to transfer tokens. This could be exploited to freeze user funds and is a centralization risk.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "Excessive Fee Adjustment",
        "reason": "The setFeesPercent function allows the owner to set transaction fees up to 90% of the transaction amount. This high level of fees can be extremely detrimental to token holders, as it could effectively drain their balances with each transaction, serving as a mechanism for the owner to extract value from users.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    }
]