[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(_isBlacklistWallet[from] == false, \"You're in blacklist\"); if(limitsEnabled){ if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){ require(amount <= maxBuyLimit,\"Over the Max buy\"); require(amount.add(balanceOf(to)) <= maxWallet); } if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !inSwapAndLiquify ){ if(!trading){ require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isinwl[to], \"Trading is not active.\"); } if (transferDelayEnabled){ if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){ require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"); _holderLastTransferTimestamp[tx.origin] = block.number; } } } } uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev); bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity; if ( !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && overMinTokenBalance ) { swapAndLiquify(); } bool takeFee = true; if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){ takeFee = false; } _tokenTransfer(from,to,amount,takeFee); }",
        "vulnerability": "Blacklist Bypass Vulnerability",
        "reason": "The contract uses a blacklist mechanism in the `_transfer` function to prevent blacklisted addresses from transferring tokens. However, there is no mechanism to prevent blacklisted addresses from receiving tokens. This means that a blacklisted address could still receive tokens, which it could then potentially use to attack the contract or the token ecosystem.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setFeesPercent",
        "code": "function setFeesPercent(uint256 distributionFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee,uint256 devFee ) external onlyOwner() { require(distributionFee + liquidityFee + marketingFee + burnFee + devFee <= 900, \"Total tax should not more than 90% (900/1000)\"); _taxFee = distributionFee; _liquidityFee = liquidityFee; _marketingFee = marketingFee; _burnFee = burnFee; _devFee = devFee; _marketingDevLiquidNBurnFee = _liquidityFee + _marketingFee + _burnFee + _devFee; }",
        "vulnerability": "Potential Fee Exploit",
        "reason": "The `setFeesPercent` function allows the contract owner to set various fees up to a total of 90%. While the intention might be to have a cap on the fees, 90% is excessively high, and an owner with malicious intent could set the fees to this level, effectively siphoning off most of the transaction value. This could severely impact token holders and the token's usability.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership Transfer Risk",
        "reason": "The `transferOwnership` function allows the current owner to transfer ownership to any address, without any additional checks or balances. This introduces a risk where the contract owner could transfer ownership to a malicious address, which could then exploit other vulnerabilities in the contract or alter the contract's state detrimentally for token holders. There is no mechanism to recover or revert such an action, leaving the contract vulnerable to permanent compromise.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    }
]