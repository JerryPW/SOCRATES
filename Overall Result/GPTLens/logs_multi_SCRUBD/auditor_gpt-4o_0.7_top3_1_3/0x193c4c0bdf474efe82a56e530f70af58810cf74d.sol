[
    {
        "function_name": "payTaxes",
        "code": "function payTaxes(uint256 _eth, uint256 _d) internal virtual {\n    for (uint i = 1; i < m_TaxAlloc.length; i++) {\n        uint256 _alloc = m_TaxAlloc[i];\n        address payable _address = m_TaxAddresses[i];\n        uint256 _amount = _eth.mul(_alloc).div(_d);\n        if (_amount > 1){\n            _address.transfer(_amount);\n            if(_address == m_DevAddress)\n                External.deposit(_amount);\n        }\n    }\n}",
        "vulnerability": "Reentrancy vulnerability in payTaxes",
        "reason": "The function `payTaxes` transfers Ether to addresses stored in `m_TaxAddresses` without protecting against reentrancy attacks. If any of these addresses are smart contracts, they could potentially reenter the contract and manipulate state or cause unexpected behavior.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external onlyOwner() {\n    require(!m_Liquidity,\"Liquidity already added.\");\n    uint256 _ethBalance = address(this).balance;\n    _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);\n    m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH());\n    m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);\n    IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max);\n    FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(4 days), msg.sender);\n    WETH.approve(address(this), type(uint).max);\n    m_Liquidity = true;\n}",
        "vulnerability": "Liquidity front-running",
        "reason": "The function `addLiquidity` does not have any measures to prevent front-running attacks. An attacker could monitor the blockchain for this transaction and execute trades that exploit the price before liquidity is added, potentially causing significant losses.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address _address) public virtual onlyOwner {\n    emit OwnershipTransferred(m_Owner, _address);\n    m_Owner = _address;\n}",
        "vulnerability": "Ownership transfer without zero-address check",
        "reason": "The function `transferOwnership` allows transferring ownership to the zero address, which can lead to a permanent loss of control over the contract. This is a critical issue as no one would be able to call `onlyOwner` functions afterwards.",
        "file_name": "0x193c4c0bdf474efe82a56e530f70af58810cf74d.sol"
    }
]