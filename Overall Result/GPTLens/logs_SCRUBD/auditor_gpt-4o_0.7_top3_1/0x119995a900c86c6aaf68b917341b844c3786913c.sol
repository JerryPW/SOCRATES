[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) private {\n    require(sender != address(0), \"Glitch: transfer from the zero address\");\n    require(recipient != address(0), \"Glitch: transfer to the zero address\");\n    require(amount > 0, \"Glitch: Transfer amount must be greater than zero\");\n    if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {\n        require(amount <= _maxTxAmount, \"Glitch: Transfer amount exceeds the maxTxAmount.\");\n        if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)\n            require(false, \"Glitch: trading is disabled.\");\n    }\n    if(!inSwapAndLiquify) {\n        uint256 lockedBalanceForPool = balanceOf(address(this));\n        bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;\n        if ( overMinTokenBalance && msg.sender != currentPoolAddress && swapAndLiquifyEnabled ) {\n            if(currentPairTokenAddress == _uniswapV2Router.WETH())\n                swapAndLiquifyForEth(lockedBalanceForPool);\n            else\n                swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);\n        }\n    }\n    if (_isExcluded[sender] && !_isExcluded[recipient]) {\n        _transferFromExcluded(sender, recipient, amount);\n    } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n        _transferToExcluded(sender, recipient, amount);\n    } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n        _transferStandard(sender, recipient, amount);\n    } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n        _transferBothExcluded(sender, recipient, amount);\n    } else {\n        _transferStandard(sender, recipient, amount);\n    }\n}",
        "vulnerability": "Trading lock bypass",
        "reason": "The tradingEnabled flag is intended to prevent trading until the owner enables it. However, the check for tradingEnabled is only applied when the sender is the currentPoolAddress or the UniswapV2Router. This means that tokens can still be transferred between regular addresses despite trading being disabled, effectively bypassing the trading lock.",
        "file_name": "0x119995a900c86c6aaf68b917341b844c3786913c.sol"
    },
    {
        "function_name": "rebalance",
        "code": "function rebalance() external returns (uint256) {\n    swapEthForTokens(address(this).balance);\n}",
        "vulnerability": "Arbitrary ETH draining",
        "reason": "The rebalance function uses address(this).balance to determine the amount of ETH to swap for tokens. This could allow an attacker to send a large amount of ETH to the contract and call rebalance, causing all of the contract's ETH balance to be swapped for tokens. This could lead to unexpected behavior or loss of ETH if not properly managed.",
        "file_name": "0x119995a900c86c6aaf68b917341b844c3786913c.sol"
    },
    {
        "function_name": "swapAndLiquifyForEth",
        "code": "function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {\n    uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);\n    uint256 half = lockedForSwap.div(2);\n    uint256 otherHalf = lockedForSwap.sub(half);\n    uint256 initialBalance = address(this).balance;\n    swapTokensForEth(half);\n    uint256 newBalance = address(this).balance.sub(initialBalance);\n    addLiquidityForEth(otherHalf, newBalance);\n    emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);\n    _transfer(address(this), tx.origin, _autoSwapCallerFee);\n    _sendRewardInterestToPool();\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function first performs a swap and liquidity addition, then transfers a fee to the transaction origin using _transfer. If the recipient is a contract that exploits reentrancy, it could call back into this function or another vulnerable function to manipulate the state of the contract before the function completes. Although the lockTheSwap modifier is intended to prevent reentrancy, the use of tx.origin and the structure of the function could still pose a reentrancy risk.",
        "file_name": "0x119995a900c86c6aaf68b917341b844c3786913c.sol"
    }
]