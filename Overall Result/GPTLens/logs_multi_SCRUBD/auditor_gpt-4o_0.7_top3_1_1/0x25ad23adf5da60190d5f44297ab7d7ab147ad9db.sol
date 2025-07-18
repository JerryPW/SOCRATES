[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if(from != owner() && to != owner() && init) require(amount <= _maxTxAmount, \"Transfer amount exceeds the maxTxAmount.\"); uint256 contractTokenBalance = balanceOf(address(this)); if(contractTokenBalance >= _maxTxAmount) { contractTokenBalance = _maxTxAmount; } bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity; if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled && init ) { contractTokenBalance = numTokensSellToAddToLiquidity; swapAndLiquify(contractTokenBalance); } bool takeFee = true; if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){ takeFee = false; } _tokenTransfer(from,to,amount,takeFee); }",
        "vulnerability": "Reentrancy via swapAndLiquify",
        "reason": "The function does not employ reentrancy protection beyond a simple boolean flag. An attacker can potentially exploit this during the swapAndLiquify process by triggering a callback that reenters the function, allowing them to manipulate the contract state or perform unauthorized operations.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(now > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Time manipulation",
        "reason": "The use of 'now' (an alias for block.timestamp) can be manipulated by miners slightly. This could potentially allow a malicious miner to unlock the contract prematurely by influencing the timestamp of the block.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); if (_allowances[address(this)][address(uniswapV2Router)] == 0) { _approve(address(this), address(uniswapV2Router), MAX); } uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); }",
        "vulnerability": "Unbounded approval",
        "reason": "The function sets the token allowance to the maximum possible value (MAX) without bounds. This can be exploited if the uniswapV2Router or the integration with Uniswap is compromised, allowing an attacker to drain the contract of its tokens.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    }
]