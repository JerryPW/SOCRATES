[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual {\n    require(_previousOwner == msg.sender, \"You don't have permission to unlock\");\n    require(now > _lockTime , \"Contract is locked until 7 days\");\n    emit OwnershipTransferred(_owner, _previousOwner);\n    _owner = _previousOwner;\n}",
        "vulnerability": "Time manipulation vulnerability",
        "reason": "The use of 'now' in the unlock function can be potentially manipulated by miners to unlock the contract earlier than intended. This creates a risk, especially if the contract lock mechanism is critical for security or financial operations.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "_tokenTransfer",
        "code": "function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 feeType, uint256 feeMultiplicator) private {\n    uint256 currentRate = _getRate();\n    uint256 tTransferAmount = amount;\n    if (feeType != 0) {\n        tTransferAmount = _takeOperations(amount, feeType, feeMultiplicator);\n    }\n    uint256 rTransferAmount = tTransferAmount.mul(currentRate);\n    uint256 rAmount = amount.mul(currentRate);\n    if (_isExcluded[sender] && !_isExcluded[recipient]) {\n        _transferFromExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);\n    } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n        _transferToExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);\n    } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n        _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);\n    } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n        _transferBothExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);\n    } else {\n        _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);\n    }\n    emit Transfer(sender, recipient, tTransferAmount);\n}",
        "vulnerability": "Missing authorization checks",
        "reason": "The '_tokenTransfer' function lacks proper checks on sender and recipient. This could allow unauthorized transfers or manipulation of token balances if any other vulnerabilities are exploited to call this function with malicious intent.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {\n    uint256 liquidityPart = 0;\n    if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;\n    uint256 distributionPart = contractTokenBalance.sub(liquidityPart);\n    uint256 liquidityHalfPart = liquidityPart.div(2);\n    uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);\n    uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);\n    swapTokensForEth(totalETHSwap);\n    uint256 newBalance = address(this).balance;\n    uint256 devBalance = _pendingDevelopmentFees.mul(newBalance).div(totalETHSwap);\n    uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);\n    if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);\n    if (devBalance > 0 && devBalance < address(this).balance) dev.call{ value: devBalance }(\"\");\n    if (address(this).balance > 0) marketing.call{ value: address(this).balance }(\"\");\n    _pendingDevelopmentFees = 0;\n    _pendingLiquidityFees = 0;\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The 'swapAndLiquify' function involves sending ETH to external addresses (dev and marketing) without using the 'transfer' or 'send' methods, which can revert on failure. This introduces a possibility for reentrancy attacks, where a malicious recipient could re-enter the function and manipulate the contract state before the function completes.",
        "file_name": "0x2e09a70dca6ab05505b26382003912783e588f9c.sol"
    }
]