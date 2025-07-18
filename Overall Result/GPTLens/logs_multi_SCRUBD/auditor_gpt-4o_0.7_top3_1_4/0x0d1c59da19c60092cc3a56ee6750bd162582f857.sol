[
    {
        "function_name": "_doTokenomics",
        "code": "function _doTokenomics() public lockLiquidities {\n    uint256 amount = balanceOf(address(this));\n    if(amount >= _minTokensForLiquidity && _lockLiquiditiesEnabled == true && amount > 0) {\n        if(amount >= _maxTransAmount) {\n            amount = _maxTransAmount;\n        }\n        uint256 liqAmount = _findPercent(amount, _autoLiqPer);\n        uint256 burnAmount = _findPercent(amount, _burnPer);\n        _doLiquidity(liqAmount, amount.sub(burnAmount), burnAmount);\n    }\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The _doTokenomics function is marked as public and involves calling _doLiquidity, which can involve external calls. This can lead to a reentrancy attack if the attacker is able to re-enter the contract and modify the state before the function completes its execution.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "_swapTokensForEth",
        "code": "function _swapTokensForEth(uint256 tokenAmount, address tokenContract) private {\n    address[] memory path = new address[](2);\n    path[0] = tokenContract;\n    path[1] = uniswapV2Router.WETH();\n    _approve(tokenContract, address(uniswapV2Router), tokenAmount);\n    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        tokenContract,\n        block.timestamp\n    );\n}",
        "vulnerability": "Token hijacking",
        "reason": "The function _swapTokensForEth swaps tokens for ETH using an arbitrary token contract address passed as a parameter. An attacker could call this function with a malicious token contract address and potentially manipulate the token balances or cause unintended swaps.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "_doLiquidity",
        "code": "function _doLiquidity(uint256 liqTokensAmount, uint256 fullBalance, uint256 burnAmount) private {\n    uint256 bnbHalf = liqTokensAmount.div(2);\n    uint256 tokenHalf = liqTokensAmount.sub(bnbHalf);\n    uint256 bnbBalance = address(this).balance;\n    _swapTokensForEth(fullBalance.sub(tokenHalf), address(this));\n    uint256 bnbNewBalance = address(this).balance.sub(bnbBalance);\n    if(bnbNewBalance > 0) {\n        uint256 liqBnbAmount = _findPercent(bnbNewBalance, _autoLiqPer);\n        uint256 devBnbAmount = _findPercent(bnbNewBalance, _devPer);\n        uint256 marketingBnbAmount = _findPercent(bnbNewBalance, _marketingPer);\n        if(liqTokensAmount > 0) {\n            _addLiquidity(tokenHalf, liqBnbAmount);\n            _liqAllTime += liqBnbAmount;\n        }\n        if(devBnbAmount > 0) {\n            _doDev(devBnbAmount);\n        }\n        if(marketingBnbAmount > 0) {\n            _doMarketing(marketingBnbAmount);\n        }\n        if(burnAmount > 0) {\n            _doBurn(burnAmount);\n        }\n    }\n}",
        "vulnerability": "Potential for locked funds",
        "reason": "This function relies on the assumption that the BNB balance increases correctly after the token swap. If the swap fails or the token contract behaves unexpectedly, this could lead to locked funds or incorrect distribution of liquidity, dev, and marketing funds.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    }
]