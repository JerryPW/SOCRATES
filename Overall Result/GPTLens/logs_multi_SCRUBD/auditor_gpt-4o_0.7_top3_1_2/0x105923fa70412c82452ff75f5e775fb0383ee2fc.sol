[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(_isBlacklistWallet[from] == false, \"You're in blacklist\"); if(limitsEnabled){ if(!isExcludedFromMax[to] && !_isExcludedFromFee[to] && from != owner() && to != owner() && to != uniswapV2Pair ){ require(amount <= maxBuyLimit,\"Over the Max buy\"); require(amount.add(balanceOf(to)) <= maxWallet); } if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !inSwapAndLiquify ){ if(!trading){ require(_isExcludedFromFee[from] || _isExcludedFromFee[to] || isinwl[to], \"Trading is not active.\"); } if (transferDelayEnabled){ if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){ require(_holderLastTransferTimestamp[tx.origin] < block.number, \"_transfer:: Transfer Delay enabled. Only one purchase per block allowed.\"); _holderLastTransferTimestamp[tx.origin] = block.number; } } } } uint256 swapAmount = accumulatedForLiquid.add(accumulatedForMarketing).add(accumulatedForDev); bool overMinTokenBalance = swapAmount >= numTokensSellToAddToLiquidity; if ( !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && overMinTokenBalance ) { swapAndLiquify(); } bool takeFee = true; if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)){ takeFee = false; } _tokenTransfer(from,to,amount,takeFee); }",
        "vulnerability": "Trading can be enabled/disabled arbitrarily.",
        "reason": "The `trading` variable can be toggled by the contract owner without any restriction, allowing the owner to enable or disable trading at will. This gives the owner excessive control over the contract's trading capabilities, potentially leading to market manipulation or denial-of-service attacks.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "setBlacklistWallet",
        "code": "function setBlacklistWallet(address account, bool blacklisted) external onlyOwner() { _isBlacklistWallet[account] = blacklisted; }",
        "vulnerability": "Blacklist manipulation by owner.",
        "reason": "The contract owner can arbitrarily blacklist any account by calling `setBlacklistWallet`. This can be used maliciously to block users from trading or transferring tokens, effectively freezing their assets without any recourse.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership transfer without safeguards.",
        "reason": "The `transferOwnership` function allows the current owner to transfer ownership to any address, including potentially malicious contracts. There are no checks or mechanisms in place to prevent transferring ownership to an undesired or invalid address, which could compromise the contract's security.",
        "file_name": "0x105923fa70412c82452ff75f5e775fb0383ee2fc.sol"
    }
]