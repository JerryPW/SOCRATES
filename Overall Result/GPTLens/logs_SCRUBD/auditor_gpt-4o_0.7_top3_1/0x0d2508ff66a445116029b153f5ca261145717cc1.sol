[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual {\n    for (uint i = 1; i < m_TaxAlloc.length; i++) {\n        uint256 _alloc = m_TaxAlloc[i];\n        address payable _address = m_TaxAddresses[i];\n        uint256 _amount = _eth.mul(_alloc).div(_d);\n        if (_amount > 1){\n            _address.transfer(_amount);\n            if(_address == m_DevAddress) External.deposit(_amount);\n        }\n    }\n}",
        "vulnerability": "Reentrancy",
        "reason": "The function transfers Ether to payable addresses which can potentially allow them to re-enter the contract and manipulate state variables. The external call to `_address.transfer(_amount);` followed by `External.deposit(_amount);` can be exploited if any of the addresses are malicious contracts that leverage reentrancy.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _address) public virtual onlyOwner {\n    emit OwnershipTransferred(m_Owner, _address);\n    m_Owner = _address;\n}",
        "vulnerability": "Potential loss of ownership",
        "reason": "There is no check to ensure that the new owner address `_address` is a non-zero address. This could potentially lead to loss of control over the contract if the ownership is transferred to the zero address.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    },
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external onlyOwner() {\n    require(!m_Liquidity,\"Liquidity already added.\");\n    uint256 _ethBalance = address(this).balance;\n    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n    m_UniswapV2Router = _uniswapV2Router;\n    _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);\n    m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n    m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);\n    IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max);\n    FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(60 days), msg.sender);\n    EthReflect.init(address(this), 5000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);\n    m_Liquidity = true;\n}",
        "vulnerability": "Lack of input validation",
        "reason": "The function does not validate the amount of liquidity being added, and the `TOTAL_SUPPLY` is approved for transfer, which might lead to unexpected behavior or errors if the total supply is not available for the liquidity operation. Additionally, using `type(uint).max` for approving tokens can be dangerous if there is a bug in the `lockTokens` function.",
        "file_name": "0x0d2508ff66a445116029b153f5ca261145717cc1.sol"
    }
]