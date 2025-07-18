[
    {
        "function_name": "initializeContract",
        "code": "function intializeContract(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner { require(!contractInitialized); _marketWallet = payable(setMarketWallet); _devWallet = payable(setDevWallet); _name = _tokenname; _symbol = _tokensymbol; startingSupply = 1_000_000_000_000; if (startingSupply < 10000000000000) { _decimals = 18; _decimalsMul = _decimals; } else { _decimals = 9; _decimalsMul = _decimals; } _tTotal = startingSupply * (10**_decimalsMul); _rTotal = (MAX - (MAX % _tTotal)); dexRouter = IUniswapV2Router02(_routerAddress); lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this)); lpPairs[lpPair] = true; _allowances[address(this)][address(dexRouter)] = type(uint256).max; _maxTxAmount = (_tTotal * 100) / 100; maxTxAmountUI = (startingSupply * 1000) / 100000; _maxWalletSize = (_tTotal * 100) / 100; maxWalletSizeUI = (startingSupply * 10) / 1000; swapThreshold = (_tTotal * 5) / 10000; swapAmount = (_tTotal * 5) / 1000; approve(_routerAddress, type(uint256).max); contractInitialized = true; _rOwned[owner()] = _rTotal; emit Transfer(ZERO, owner(), _tTotal); _approve(address(this), address(dexRouter), type(uint256).max); _transfer(owner(), address(this), balanceOf(owner())); dexRouter.addLiquidityETH{value: address(this).balance}( address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp ); Planted = block.number; }",
        "vulnerability": "Liquidity addition vulnerability",
        "reason": "The function allows the owner to initialize the contract and add liquidity without any restrictions once the contract is deployed. This could be exploited by the owner to manipulate initial liquidity settings and potentially engage in unfair practices such as rug pulling.",
        "file_name": "0x0b452278223d3954f4ac050949d7998e373e7e43.sol"
    },
    {
        "function_name": "_hasLimits",
        "code": "function _hasLimits(address from, address to) internal view returns (bool) { return from != owner() && to != owner() && !_liquidityHolders[to] && !_liquidityHolders[from] && to != DEAD && to != address(0) && from != address(this); }",
        "vulnerability": "Owner bypass of transaction limits",
        "reason": "The _hasLimits function allows the owner to bypass transaction limits, which can lead to potential abuse where the owner could execute large transactions without restrictions, potentially harming token holders by causing price manipulation or other malicious activities.",
        "file_name": "0x0b452278223d3954f4ac050949d7998e373e7e43.sol"
    },
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner() { setExcludedFromFee(_owner, false); _owner = address(0); emit OwnershipTransferred(_owner, address(0)); }",
        "vulnerability": "Incomplete renounce ownership",
        "reason": "Renouncing ownership does not update states such as _isExcludedFromFee or _liquidityHolders properly for the previous owner. This incomplete renunciation can leave the contract in a vulnerable state where the previous owner might still have some privileges or the contract could become non-functional.",
        "file_name": "0x0b452278223d3954f4ac050949d7998e373e7e43.sol"
    }
]