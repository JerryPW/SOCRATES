[
    {
        "function_name": "_transfer",
        "vulnerability": "Blacklist Bypass",
        "criticism": "The reasoning is correct that the _transfer function does not prevent a blacklisted address from receiving tokens. However, the severity and profitability of this vulnerability are moderate, because it depends on the intention of the non-blacklisted addresses. If they are not malicious, they will not send tokens to the blacklisted addresses.",
        "correctness": 7,
        "severity": 5,
        "profitability": 5,
        "reason": "The _transfer function checks if the sender's address is blacklisted, however, there are no conditions to prevent a blacklisted address from receiving tokens. This could potentially allow a blacklisted address to circumvent restrictions by receiving tokens from non-blacklisted addresses.",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(_isBlacklistWallet[from] == false, \"You're in blacklist\"); if(limitsEnabled){ if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){ require(amount <= maxBuyLimit,\"Over the Max buy\"); require(amount.add(balanceOf(to)) <= maxWallet); } if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !inSwapAndLiquify ){ if(!trading){ require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isinwl[to], \"Trading is not active.\"); } if (transferDelayEnabled){ if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){ require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"); _holderLastTransferTimestamp[tx.origin] = block.number; } } } } uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev); bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity; if ( !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && overMinTokenBalance ) { swapAndLiquify(); } bool takeFee = true; if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){ takeFee = false; } _tokenTransfer(from,to,amount,takeFee); }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 6.0
    },
    {
        "function_name": "setBlacklistWallet",
        "vulnerability": "Centralized Control of Blacklist",
        "criticism": "The reasoning is correct that the owner has the power to blacklist addresses arbitrarily. This is a design decision that might be questionable. The severity is high because it can freeze user funds. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 8,
        "profitability": 0,
        "reason": "This function allows the owner to arbitrarily blacklist addresses, giving the owner excessive control over the ability of users to transfer tokens. This could be exploited to freeze user funds and is a centralization risk.",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 5.5
    },
    {
        "function_name": "setFeesPercent",
        "vulnerability": "Excessive Fee Adjustment",
        "criticism": "The reasoning is correct that the owner can set transaction fees up to 90% of the transaction amount. This is a design decision that might be questionable. The severity is high because it can drain user balances. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 7,
        "severity": 8,
        "profitability": 0,
        "reason": "The setFeesPercent function allows the owner to set transaction fees up to 90% of the transaction amount. This high level of fees can be extremely detrimental to token holders, as it could effectively drain their balances with each transaction, serving as a mechanism for the owner to extract value from users.",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol",
        "final_score": 5.5
    }
]