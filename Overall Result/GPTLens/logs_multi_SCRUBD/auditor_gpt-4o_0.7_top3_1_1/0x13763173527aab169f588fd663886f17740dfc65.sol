[
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external payable onlyOwner lockTaxSwap { require(_primaryLP == address(0), \"LP exists\"); require(!_tradingOpen, \"trading is open\"); require(msg.value > 0 || address(this).balance>0, \"No ETH in contract or message\"); require(_balances[address(this)]>0, \"No tokens in contract\"); _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH()); _addLiquidity(_balances[address(this)], address(this).balance, false); _balances[_primaryLP] -= _swapLimit; (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature(\"sync()\")); require(lpAddSuccess, \"Failed adding liquidity\"); _isLP[_primaryLP] = lpAddSuccess; _openTrading(); }",
        "vulnerability": "Liquidity Addition Manipulation",
        "reason": "The function allows the owner to add liquidity only once and opens trading immediately after. An attacker could front-run the liquidity addition and manipulate the initial token price.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    },
    {
        "function_name": "_transferFrom",
        "code": "function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) { require(sender != address(0), \"No transfers from Zero wallet\"); if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], \"Trading not open\"); } if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); } if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), \"TX exceeds limits\"); } uint256 _taxAmount = _calculateTax(sender, recipient, amount); uint256 _transferAmount = amount - _taxAmount; _balances[sender] = _balances[sender] - amount; _swapLimit += _taxAmount; _balances[recipient] = _balances[recipient] + _transferAmount; emit Transfer(sender, recipient, amount); return true; }",
        "vulnerability": "Reentrancy Issue in Tax Swap",
        "reason": "The function calls `_swapTaxAndLiquify` which involves external calls without proper reentrancy protection. This could allow an attacker to exploit the reentrancy and drain funds.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    },
    {
        "function_name": "setExempt",
        "code": "function setExempt(address wallet, bool noFees, bool noLimits) external onlyOwner { if (noLimits || noFees) { require(!_isLP[wallet], \"Cannot exempt LP\"); } _noFees[ wallet ] = noFees; _noLimits[ wallet ] = noLimits; }",
        "vulnerability": "Centralization Risk",
        "reason": "The owner can arbitrarily exempt any address from fees and limits, allowing potential manipulation of trading rules and undermining the decentralized nature of the contract.",
        "file_name": "0x13763173527aab169f588fd663886f17740dfc65.sol"
    }
]