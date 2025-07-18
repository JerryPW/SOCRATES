[
    {
        "function_name": "_RFT",
        "code": "function _RFT(address payable setSecretVault, address payable setDW, string memory _tokenname, string memory _tokensymbol) external onlyOwner { require(!rft); _SecretVault = payable(setSecretVault); _dW = payable(setDW); _iEFF[_SecretVault] = true; _iEFF[_dW] = true; _nm = _tokenname; _s = _tokensymbol; sS = 1_000_000_000; if (sS < 1000000000000) { _decimals = 18; _decimalsMul = _decimals; } else { _decimals = 9; _decimalsMul = _decimals; } _tTotal = sS * (10**_decimalsMul); _rTotal = (MAX - (MAX % _tTotal)); dexRouter = IUniswapV2Router02(_routerAddress); lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this)); lpPs[lpPair] = true; _als[address(this)][address(dexRouter)] = type(uint256).max; _mTA = (_tTotal * 1000) / 100000; mTAUI = (sS * 500) / 100000; _mWS = (_tTotal * 10) / 1000; mWSUI = (sS * 10) / 1000; swapThreshold = (_tTotal * 5) / 10000; swapAmount = (_tTotal * 5) / 1000; approve(_routerAddress, type(uint256).max); rft = true; _rOd[owner()] = _rTotal; emit Transfer(ZERO, owner(), _tTotal); _approve(address(this), address(dexRouter), type(uint256).max); _t(owner(), address(this), balanceOf(owner())); dexRouter.addLiquidityETH{value: address(this).balance}( address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp ); Planted = block.number; }",
        "vulnerability": "Liquidity Addition Front-Running Risk",
        "reason": "The function allows the owner to set up liquidity pairs and add liquidity without restriction immediately upon contract deployment. This creates a front-running risk where an attacker could monitor the blockchain for such transactions, and immediately buy tokens after liquidity is added, potentially manipulating the market.",
        "file_name": "0x0af27f9be4ac583a491ee6573ebdccf32d1b561c.sol"
    },
    {
        "function_name": "transferOwner",
        "code": "function transferOwner(address newOwner) external onlyOwner() { require(newOwner != address(0), \"Call renounceOwnership to transfer owner to the zero address.\"); require(newOwner != DEAD, \"Call renounceOwnership to transfer owner to the zero address.\"); setExcludedFromFee(_owner, false); setExcludedFromFee(newOwner, true); setExcludedFromReward(newOwner, true); if (_dW == payable(_owner)) _dW = payable(newOwner); _als[_owner][newOwner] = balanceOf(_owner); if(balanceOf(_owner) > 0) { _t(_owner, newOwner, balanceOf(_owner)); } _owner = newOwner; emit OwnershipTransferred(_owner, newOwner); }",
        "vulnerability": "Improper Transfer of Ownership",
        "reason": "The transfer of ownership function includes an automatic transfer of the owner's token balance to the new owner. This could be exploited if the new owner is not yet trusted, as they would receive all of the original owner's tokens upon transfer, potentially resulting in loss of funds if the new owner acts maliciously.",
        "file_name": "0x0af27f9be4ac583a491ee6573ebdccf32d1b561c.sol"
    },
    {
        "function_name": "setNewRouter",
        "code": "function setNewRouter(address newRouter) external onlyOwner() { IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter); address g_p = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH()); if (g_p == address(0)) { lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH()); } else { lpPair = g_p; } dexRouter = _newRouter; _approve(address(this), newRouter, MAX); }",
        "vulnerability": "Owner Can Change Router Arbitrarily",
        "reason": "The owner has the power to change the DEX router to any address without any checks or balances. This could allow the owner to point the contract to a malicious or incorrect router, potentially disrupting trading or causing loss of funds.",
        "file_name": "0x0af27f9be4ac583a491ee6573ebdccf32d1b561c.sol"
    }
]