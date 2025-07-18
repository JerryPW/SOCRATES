[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual {\n    require(_previousOwner == msg.sender, \"You don't have permission to unlock\");\n    require(now > _lockTime , \"Contract is locked until 7 days\");\n    emit OwnershipTransferred(_owner, _previousOwner);\n    _owner = _previousOwner;\n}",
        "vulnerability": "Time manipulation vulnerability",
        "reason": "The unlock function relies on the 'now' variable, which is deprecated as it can be influenced by miners within a certain range. This could potentially allow an attacker to unlock the contract before the expected time if they can manipulate the block timestamp.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    },
    {
        "function_name": "_lockLiquidityForever",
        "code": "function _lockLiquidityForever(uint liquidity) public {\n    IUniswapV2Pair(uniswapV2Pair).transferFrom(_msgSender(), address(this), liquidity);\n    emit LockLiquidityForever(liquidity);\n}",
        "vulnerability": "Improper liquidity locking logic",
        "reason": "The function _lockLiquidityForever does not actually lock the liquidity in a way that it cannot be moved or removed by the contract owner. This function just transfers tokens to the contract's address and emits an event, which does not ensure that the liquidity is truly locked and inaccessible.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor (address airdrop) public {\n    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n    uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n        .createPair(address(this), _uniswapV2Router.WETH());\n    uniswapV2Router = _uniswapV2Router;\n    _isExcludedFromFee[owner()] = true;\n    _isExcludedFromFee[address(this)] = true;\n    _isExcludedFromFee[airdrop] = true;\n    excludeFromReward(airdrop);\n    _rOwned[address(this)] = _rTotal;\n    _transfer(address(this), airdrop, _tTotal * 50 / 100);\n    _transfer(address(this), owner(), _tTotal * 10 / 100);\n    _transfer(address(this), address(0xdead), _tTotal * 40 / 100);\n    init = true;\n}",
        "vulnerability": "Massive allocation to airdrop address",
        "reason": "In the constructor, 50% of the total supply is allocated to the airdrop address immediately upon contract deployment. If the airdrop address is not carefully controlled, it can lead to massive market manipulation, as this address has the power to dump a significant portion of the tokens into the market, potentially leading to a crash in token value.",
        "file_name": "0x25ad23adf5da60190d5f44297ab7d7ab147ad9db.sol"
    }
]