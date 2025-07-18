[
    {
        "function_name": "_swapTokensForEth",
        "code": "function _swapTokensForEth(uint256 tokenAmount, address tokenContract) private {\n    address[] memory path = new address[](2);\n    path[0] = tokenContract;\n    path[1] = uniswapV2Router.WETH();\n    _approve(tokenContract, address(uniswapV2Router), tokenAmount);\n    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        tokenContract,\n        block.timestamp\n    );\n}",
        "vulnerability": "Incorrect token contract address",
        "reason": "The function seems to incorrectly use the 'tokenContract' parameter as the address for approval and as the starting path for the swap. This could lead to incorrect token being swapped or approved, potentially causing loss of tokens or failure in the swap.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "manualTokenomics",
        "code": "function manualTokenomics() public onlyOwner() {\n    if(balanceOf(address(this)) > 0) {\n        this.transfer(_wMarketing, balanceOf(address(this)));\n    }\n    if(address(this).balance > 0) {\n        _wMarketing.transfer(address(this).balance);\n    }\n}",
        "vulnerability": "Potential misuse of contract funds",
        "reason": "The function allows the contract owner to transfer all tokens and ETH balance from the contract to the marketing wallet without any restrictions or conditions. This could be exploited by a malicious owner to drain the contract's funds.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    },
    {
        "function_name": "_doLiquidity",
        "code": "function _doLiquidity(uint256 liqTokensAmount, uint256 fullBalance, uint256 burnAmount) private {\n    uint256 bnbHalf = liqTokensAmount.div(2);\n    uint256 tokenHalf = liqTokensAmount.sub(bnbHalf);\n    uint256 bnbBalance = address(this).balance;\n    _swapTokensForEth(fullBalance.sub(tokenHalf), address(this));\n    uint256 bnbNewBalance = address(this).balance.sub(bnbBalance);\n    if(bnbNewBalance > 0) {\n        uint256 liqBnbAmount = _findPercent(bnbNewBalance, _autoLiqPer);\n        uint256 devBnbAmount = _findPercent(bnbNewBalance, _devPer);\n        uint256 marketingBnbAmount = _findPercent(bnbNewBalance, _marketingPer);\n        if(liqTokensAmount > 0) {\n            _addLiquidity(tokenHalf, liqBnbAmount);\n            _liqAllTime += liqBnbAmount;\n        }\n        if(devBnbAmount > 0) {\n            _doDev(devBnbAmount);\n        }\n        if(marketingBnbAmount > 0) {\n            _doMarketing(marketingBnbAmount);\n        }\n        if(burnAmount > 0) {\n            _doBurn(burnAmount);\n        }\n    }\n}",
        "vulnerability": "Incorrect calculation of liquidity and token burn",
        "reason": "The function calculates 'bnbHalf' as half of the liquidity token amount, but incorrectly uses this for token calculations instead of ETH. This might lead to incorrect amounts being swapped and added to liquidity, causing potential financial discrepancies.",
        "file_name": "0x0d1c59da19c60092cc3a56ee6750bd162582f857.sol"
    }
]